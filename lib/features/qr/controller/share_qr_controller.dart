import 'package:get/get.dart';

class ContactItem {
  final String name;
  final String phoneNumber;
  final String? avatarUrl;

  ContactItem({required this.name, required this.phoneNumber, this.avatarUrl});
}

class ShareQrController extends GetxController {
  final RxList<ContactItem> _allContacts = <ContactItem>[].obs;
  final RxList<ContactItem> filteredContacts = <ContactItem>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // Listen to search query changes
    debounce(
      searchQuery,
      (_) => _filterContacts(),
      time: const Duration(milliseconds: 300),
    );
  }

  void _filterContacts() {
    if (searchQuery.value.isEmpty) {
      filteredContacts.assignAll(_allContacts);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredContacts.assignAll(
        _allContacts.where((contact) {
          return contact.name.toLowerCase().contains(query) ||
              contact.phoneNumber.toLowerCase().contains(query);
        }).toList(),
      );
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void addContact(String phoneNumber) {
    // Simply mocked add functionality
    if (phoneNumber.isNotEmpty) {
      final newContact = ContactItem(
        name: 'Unknown User',
        phoneNumber: phoneNumber,
      );
      _allContacts.insert(0, newContact);
      _filterContacts();
    }
  }

  void deleteContact(ContactItem contact) {
    _allContacts.remove(contact);
    _filterContacts();
  }
}
