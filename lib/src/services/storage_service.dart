import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  Future<String?> uploadImage(String userId, String feedId) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      try {
        String fileName = 'images/$userId/$feedId/${DateTime.now().millisecondsSinceEpoch}.png';
        UploadTask uploadTask = _storage.ref().child(fileName).putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        return await snapshot.ref.getDownloadURL();
      } catch (e) {
        print(e);
        return null;
      }
    }
    return null;
  }
}