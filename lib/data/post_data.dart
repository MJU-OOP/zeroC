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
  final DateTime createAt; // 변경: String에서 DateTime으로
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
      'profile_image':
          profileImage != null ? base64Encode(profileImage!) : null,
      'feed_image': feedImage != null ? base64Encode(feedImage!) : null,
      'create_at': createAt, // 타임스탬프로 저장
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
      profileImage: data['profile_image'] != null
          ? base64Decode(data['profile_image'])
          : null,
      feedImage: data['feed_image'] != null
          ? base64Decode(data['feed_image'])
          : null,
      createAt: (data['create_at'] as Timestamp).toDate(),
      schoolId: data['school_id'] ?? 'Unknown',
    );
  }
}
