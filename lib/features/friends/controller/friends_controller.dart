import 'package:expense/core/services/firestore_service.dart';
import 'package:expense/core/utils/app_logger.dart';
import 'package:expense/features/friends/models/friend_model.dart';
import 'package:get/get.dart';

class FriendsController extends GetxController {
  final friends = <FriendModel>[].obs;
  final isDeleteMode = false.obs;
  final searchQuery = ''.obs;

  List<FriendModel> get filteredFriends {
    if (searchQuery.value.isEmpty) {
      return friends;
    }
    final query = searchQuery.value.toLowerCase();
    return friends.where((friend) {
      return friend.name.toLowerCase().contains(query) ||
          friend.phone.toLowerCase().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    syncFriends();
  }

  void syncFriends() {
    try {
      AppLogger.info("Syncing friends from Firestore...");
      FirestoreService.userDoc()
          .collection('friends')
          .snapshots()
          .listen(
            (snapshot) {
              friends.assignAll(
                snapshot.docs
                    .map((doc) => FriendModel.fromMap(doc.data()))
                    .toList(),
              );
              AppLogger.info("Fetched ${friends.length} friends.");
            },
            onError: (error) {
              AppLogger.error("Error syncing friends: $error");
            },
          );
    } catch (e) {
      AppLogger.error("Failed to setup friends sync: $e");
    }
  }

  void toggleDeleteMode() async {
    if (isDeleteMode.value) {
      // Currently in delete mode, user clicked Check (Confirm Delete)
      final selectedFriends = friends.where((f) => f.isSelected.value).toList();
      if (selectedFriends.isNotEmpty) {
        try {
          final batch = FirestoreService.userDoc().firestore.batch();
          for (var friend in selectedFriends) {
            batch.delete(
              FirestoreService.userDoc().collection('friends').doc(friend.id),
            );
          }
          await batch.commit();
          Get.snackbar('Success', '${selectedFriends.length} friends deleted');
        } catch (e) {
          AppLogger.error("Error deleting friends: $e");
          Get.snackbar('Error', 'Failed to delete friends');
        }
      }
      isDeleteMode.value = false;
    } else {
      for (var f in friends) {
        f.isSelected.value = false;
      }
      friends.refresh();
      isDeleteMode.value = true;
    }
  }

  Map<String, List<FriendModel>> get groupedFriends {
    final sortedFriends = List<FriendModel>.from(friends);
    sortedFriends.sort(
      (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
    );

    final Map<String, List<FriendModel>> groups = {};
    for (var friend in sortedFriends) {
      if (friend.name.isEmpty) continue;
      final initial = friend.name[0].toUpperCase();
      if (!groups.containsKey(initial)) {
        groups[initial] = [];
      }
      groups[initial]!.add(friend);
    }
    return groups;
  }

  void toggleSelection(FriendModel friend) {
    friend.isSelected.toggle();
    friends.refresh();
  }

  void toggleGroupSelection(String initial) {
    final groups = groupedFriends;
    if (!groups.containsKey(initial)) return;

    final group = groups[initial]!;
    // Check if all are currently selected
    final allSelected = group.every((f) => f.isSelected.value);

    // Toggle state: if all selected, deselect all. Otherwise select all.
    for (var friend in group) {
      friend.isSelected.value = !allSelected;
    }
    friends.refresh();
  }

  Future<void> addFriendToFirestore(FriendModel friend) async {
    try {
      await FirestoreService.userDoc()
          .collection('friends')
          .doc(friend.id)
          .set(friend.toMap());
      AppLogger.info("Friend added to Firestore: ${friend.name}");
    } catch (e) {
      AppLogger.error("Error adding friend to Firestore: $e");
      rethrow;
    }
  }
}
