import 'package:expense/features/friends/controller/friends_controller.dart';
import 'package:expense/features/friends/models/friend_model.dart';
import 'package:get/get.dart';

class ShareAnalysisController extends GetxController {
  final FriendsController _friendsController = Get.find<FriendsController>();

  List<FriendModel> get filteredFriends => _friendsController.filteredFriends;

  void updateSearchQuery(String query) {
    _friendsController.searchQuery.value = query;
  }

  void addContact(String phoneNumber) {
    // Logic to send share link to a phone number not in friends list if needed
  }

  void deleteContact(FriendModel friend) {
    // Logic to remove from "Shared with" list if we were tracking that
  }
}
