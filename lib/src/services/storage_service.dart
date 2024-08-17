import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadImage(String userId, String feedId) async {
    try {
      // 이미지 선택
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        print('No image selected.');
        return null;
      }

      File file = File(image.path);

      // 고유한 파일 이름 생성
      String fileName = 'images/$userId/$feedId/${DateTime.now().millisecondsSinceEpoch}.png';

      // 파일 업로드
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);
      TaskSnapshot snapshot = await uploadTask;

      // 업로드된 파일의 다운로드 URL 반환
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Image uploaded successfully. Download URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      // 예외 발생 시 에러 메시지 출력
      print('Error uploading image: $e');
      return null;
    }
  }
}