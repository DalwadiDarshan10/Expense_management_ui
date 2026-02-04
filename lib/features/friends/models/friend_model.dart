import 'package:get/get.dart';

class FriendModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String? imageUrl;
  RxBool isSelected;

  FriendModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.imageUrl,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'imageUrl': imageUrl,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
      isSelected: false,
    );
  }

  FriendModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? imageUrl,
    bool? isSelected,
  }) {
    return FriendModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }
}
