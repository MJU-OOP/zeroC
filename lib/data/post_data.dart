import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostData {
  String? feedId;
  final String userId;
  final String challengeId;
  final String username;
  final String content;
  final Uint8List? profileImage;
  final Uint8List? feedImage;
  final String createAt;
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

  @override
  String toString() {
    return 'feedId: $feedId, userId: $userId, challengeId: $challengeId, username: $username, content: $content, createAt: $createAt, schoolId: $schoolId';
  }

  Map<String, Object?> toMap() {
    return {
      'feed_id': feedId,
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

  // Firestore에 저장할 때 사용할 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'challenge_id': challengeId,
      'username': username,
      'content': content,
      'profile_image': profileImage != null ? base64Encode(profileImage!) : null,
      'feed_image': feedImage != null ? base64Encode(feedImage!) : null,
      'create_at': createAt,
      'school_id': schoolId,
    };
  }

  // Firestore에서 데이터를 가져올 때 사용할 메서드
  factory PostData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PostData(
      feedId: doc.id,
      userId: data['user_id'] ?? 'Unknown',  // null 안전 처리
      challengeId: data['challenge_id'] ?? 'Unknown',  // null 안전 처리
      username: data['username'] ?? 'Unknown',  // null 안전 처리
      content: data['content'] ?? '',  // null 안전 처리
      profileImage: data['profile_image'] != null ? base64Decode(data['profile_image']) : null,
      feedImage: data['feed_image'] != null ? base64Decode(data['feed_image']) : null,
      createAt: data['create_at'] ?? 'Unknown',  // null 안전 처리
      schoolId: data['school_id'] ?? 'Unknown',  // null 안전 처리
    );
  }
}
