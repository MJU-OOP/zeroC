import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/models/user_model.dart';

class UserService {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> createUser(UserModel user) async {
    return await userCollection.doc(user.userId).set(user.toFirestore());
  }

  Future<UserModel?> getUser(String userId) async {
    DocumentSnapshot doc = await userCollection.doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}