import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolData {
  String? schoolId;
  final String schoolName;
  String? schoolImage;

  SchoolData({
    this.schoolId,
    required this.schoolName,
    required this.schoolImage,
  });

  @override
  String toString() {
    return 'schoolId: $schoolId, schoolName: $schoolName, schoolImage: $schoolImage';
  }

  Map<String, Object?> toMap() {
    return {
      'school_id': schoolId,
      'school_name': schoolName,
      'school_image': schoolImage,
    };
  }

  // Firestore에 저장할 때 사용할 메서드
  Map<String, dynamic> toFirestore() {
    return {
      'school_id': schoolId,
      'school_name': schoolName,
      'school_image': schoolImage,
    };
  }

  // Firestore에서 데이터를 가져올 때 사용할 메서드
  factory SchoolData.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SchoolData(
      schoolId: data['school_id'] ?? 'Unkown',
      schoolName: data['school_name'] ?? 'Unknown',
      schoolImage: data['school_image'],
    );
  }
}