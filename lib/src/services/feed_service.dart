import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zeroC/src/models/feed_model.dart';

class FeedService {
  final CollectionReference feedCollection = FirebaseFirestore.instance.collection('feeds');

  Future<void> createFeed(FeedModel feed) async {
    DocumentReference docRef = feedCollection.doc();
    return await docRef.set(feed.copyWith(feedId: docRef.id).toFirestore());
  }

  Stream<List<FeedModel>> getFeeds() {
    return feedCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => FeedModel.fromFirestore(doc)).toList();
    });
  }
}