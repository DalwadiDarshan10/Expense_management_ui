import 'package:get/get.dart';

class FriendsController extends GetxController {
  final friends = <FriendModel>[].obs;
  final isDeleteMode = false.obs;

  void toggleDeleteMode() {
    if (isDeleteMode.value) {
      // Currently in delete mode, user clicked Check (Confirm Delete)
      final selectedCount = friends.where((f) => f.isSelected.value).length;
      if (selectedCount > 0) {
        friends.removeWhere((element) => element.isSelected.value);
        friends.refresh();
        Get.snackbar('Success', '$selectedCount friends deleted');
      }
      isDeleteMode.value = false;
    } else {
      // Enter delete mode
      // Clear any previous selection
      for (var f in friends) {
        f.isSelected.value = false;
      }
      friends.refresh();
      isDeleteMode.value = true;
    }
  }

  Map<String, List<FriendModel>> get groupedFriends {
    final sortedFriends = List<FriendModel>.from(friends);
    sortedFriends.sort((a, b) => a.name.compareTo(b.name));

    final Map<String, List<FriendModel>> groups = {};
    for (var friend in sortedFriends) {
      final initial = friend.name[0].toUpperCase();
      if (!groups.containsKey(initial)) {
        groups[initial] = [];
      }
      groups[initial]!.add(friend);
    }
    return groups;
  }

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  void loadFriends() {
    // Dummy data matching the design
    friends.assignAll([
      FriendModel(name: 'Arene Perry', phone: '505-267-3051', imageUrl: ''),
      FriendModel(name: 'Ane Holden', phone: '414-688-7314'),
      FriendModel(name: 'Alfred Weber', phone: '414-566-7314'),
      FriendModel(name: 'Amene Perry', phone: '505-267-6061'),
      FriendModel(name: 'Ana Hana', phone: '414-566-7314'),
      FriendModel(name: 'Besley Glover', phone: '414-566-7314'),
    ]);
  }

  void toggleSelection(FriendModel friend) {
    friend.isSelected.toggle();
    friends.refresh();
  }

  void toggleGroupSelection(String initial) {
    if (!groupedFriends.containsKey(initial)) return;

    final group = groupedFriends[initial]!;
    // Check if all are currently selected
    final allSelected = group.every((f) => f.isSelected.value);

    // Toggle state: if all selected, deselect all. Otherwise select all.
    for (var friend in group) {
      friend.isSelected.value = !allSelected;
    }
    friends.refresh();
  }

  void addFriend(FriendModel friend) {
    friends.add(friend);
    friends.refresh();
  }
}

class FriendModel {
  final String name;
  final String phone;
  final String? imageUrl;
  RxBool isSelected;

  FriendModel({
    required this.name,
    required this.phone,
    this.imageUrl,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;
}
