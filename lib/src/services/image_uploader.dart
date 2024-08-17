import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';

class ImageUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final Uuid _uuid = Uuid();  // UUID 생성기

  Future<String?> uploadImage(String userId) async {
    try {
      // 이미지 선택
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return null;

      // 고유한 파일 이름 생성
      String fileName = '${userId}_${_uuid.v4()}.png';

      // Firebase Storage에 업로드
      File file = File(image.path);
      TaskSnapshot snapshot = await _storage.ref().child('uploads/$fileName').putFile(file);

      // 업로드된 이미지의 URL 반환
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}