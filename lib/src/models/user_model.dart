import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String schoolId;
  final String phone;
  final String sex;
  final String birth;
  final String name;
  final String nickName;
  final String profileImage;
  final String profileContent;

  UserModel({
    required this.userId,
    required this.schoolId,
    required this.phone,
    required this.sex,
    required this.birth,
    required this.name,
    required this.nickName,
    required this.profileImage,
    required this.profileContent,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      userId: doc.id,
      schoolId: data['school_id'] ?? '',
      phone: data['phone'] ?? '',
      sex: data['sex'] ?? '',
      birth: data['birth'] ?? '',
      name: data['name'] ?? '',
      nickName: data['nick_name'] ?? '',
      profileImage: data['profile_image'] ?? '',
      profileContent: data['profile_content'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'school_id': schoolId,
      'phone': phone,
      'sex': sex,
      'birth': birth,
      'name': name,
      'nick_name': nickName,
      'profile_image': profileImage,  
      'profile_content': profileContent
  };}
  }