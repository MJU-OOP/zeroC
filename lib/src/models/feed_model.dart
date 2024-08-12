import 'package:cloud_firestore/cloud_firestore.dart';

class FeedModel {
  final String feedId;
  final String feedContent;
  final Timestamp feedCreatedAt;
  final String feedUserId;
  final String feedChallengeId;

  FeedModel({
    required this.feedId,
    required this.feedContent,
    required this.feedCreatedAt,
    required this.feedUserId,
    required this.feedChallengeId,
  });

  factory FeedModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return FeedModel(
      feedId: doc.id,
      feedContent: data['feed_content'] ?? '',
      feedCreatedAt: data['feed_created_at'] ?? Timestamp.now(),
      feedUserId: data['feed_user_id'] ?? '',
      feedChallengeId: data['feed_challenge_id'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'feed_content': feedContent,
      'feed_created_at': feedCreatedAt,
      'feed_user_id': feedUserId,
      'feed_challenge_id': feedChallengeId,
    };
  }

  FeedModel copyWith({
    String? feedId,
    String? feedContent,
    Timestamp? feedCreatedAt,
    String? feedUserId,
    String? feedChallengeId,
  }) {
    return FeedModel(
      feedId: feedId ?? this.feedId,
      feedContent: feedContent ?? this.feedContent,
      feedCreatedAt: feedCreatedAt ?? this.feedCreatedAt,
      feedUserId: feedUserId ?? this.feedUserId,
      feedChallengeId: feedChallengeId ?? this.feedChallengeId,
    );
  }
}