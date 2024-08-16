import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String? feedId;
  final String userId;
  final String challengeId;
  final String username;
  final String content;
  final String? profileImage;
  final String? feedImage; 
  final DateTime createAt;
  final String schoolId;

  PostData({
    this.feedId,
    required this.userId,
    required this.challengeId,
    required this.username,
    required this.content,
    this.profileImage,
    this.feedImage,
    required this.createAt,
    required this.schoolId,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'challenge_id': challengeId,
      'username': username,
      'content': content,
      'profile_image': profileImage,
      'feed_image': feedImage,
      'create_at': createAt,
      'school_id': schoolId,
    };
  }

  factory PostData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostData(
      feedId: doc.id,
      userId: data['user_id'] ?? 'Unknown',
      challengeId: data['challenge_id'] ?? 'Unknown',
      username: data['username'] ?? 'Unknown',
      content: data['content'] ?? '',
      profileImage: data['profile_image'],
      feedImage: data['feed_image'],
      createAt: (data['create_at'] as Timestamp).toDate(),
      schoolId: data['school_id'] ?? 'Unknown',
    );
  }

  PostData copyWith({String? feedImage}) {
    return PostData(
      feedId: feedId,
      userId: userId,
      challengeId: challengeId,
      username: username,
      content: content,
      profileImage: profileImage,
      feedImage: feedImage ?? this.feedImage,
      createAt: createAt,
      schoolId: schoolId,
    );
  }
}
