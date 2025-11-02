import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String gender; // 'male', 'female', 'other'
  final String? photoURL;
  final double rating;
  final int totalRides;
  
  // University Info
  final String universityId;
  final String universityName;
  final String verifiedEmail;
  final String? studentId;
  final bool verified;
  final DateTime? verifiedAt;
  
  // Safety
  final String idVerificationStatus; // 'pending', 'approved', 'rejected'
  final String? idDocumentURL;
  
  // Emergency Contact
  final String? emergencyContactName;
  final String? emergencyContactPhone;
  final String? emergencyContactRelationship;
  
  // Preferences
  final String genderPreference; // 'any', 'same-gender', 'female-only'
  final bool smokingAllowed;
  final bool chatty;
  
  final DateTime createdAt;
  final DateTime? lastActive;

  UserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    this.photoURL,
    this.rating = 0.0,
    this.totalRides = 0,
    required this.universityId,
    required this.universityName,
    required this.verifiedEmail,
    this.studentId,
    this.verified = false,
    this.verifiedAt,
    this.idVerificationStatus = 'pending',
    this.idDocumentURL,
    this.emergencyContactName,
    this.emergencyContactPhone,
    this.emergencyContactRelationship,
    this.genderPreference = 'any',
    this.smokingAllowed = false,
    this.chatty = true,
    required this.createdAt,
    this.lastActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'photoURL': photoURL,
      'rating': rating,
      'totalRides': totalRides,
      'university': {
        'id': universityId,
        'name': universityName,
        'verifiedEmail': verifiedEmail,
        'studentId': studentId,
        'verified': verified,
        'verifiedAt': verifiedAt != null ? Timestamp.fromDate(verifiedAt!) : null,
      },
      'idVerificationStatus': idVerificationStatus,
      'idDocumentURL': idDocumentURL,
      'emergencyContact': {
        'name': emergencyContactName,
        'phone': emergencyContactPhone,
        'relationship': emergencyContactRelationship,
      },
      'preferences': {
        'genderPreference': genderPreference,
        'smokingAllowed': smokingAllowed,
        'chatty': chatty,
      },
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': lastActive != null ? Timestamp.fromDate(lastActive!) : null,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final university = map['university'] as Map<String, dynamic>? ?? {};
    final emergencyContact = map['emergencyContact'] as Map<String, dynamic>? ?? {};
    final preferences = map['preferences'] as Map<String, dynamic>? ?? {};

    return UserModel(
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      photoURL: map['photoURL'],
      rating: map['rating']?.toDouble() ?? 0.0,
      totalRides: map['totalRides'] ?? 0,
      universityId: university['id'] ?? '',
      universityName: university['name'] ?? '',
      verifiedEmail: university['verifiedEmail'] ?? '',
      studentId: university['studentId'],
      verified: university['verified'] ?? false,
      verifiedAt: university['verifiedAt'] != null
          ? (university['verifiedAt'] as Timestamp).toDate()
          : null,
      idVerificationStatus: map['idVerificationStatus'] ?? 'pending',
      idDocumentURL: map['idDocumentURL'],
      emergencyContactName: emergencyContact['name'],
      emergencyContactPhone: emergencyContact['phone'],
      emergencyContactRelationship: emergencyContact['relationship'],
      genderPreference: preferences['genderPreference'] ?? 'any',
      smokingAllowed: preferences['smokingAllowed'] ?? false,
      chatty: preferences['chatty'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: map['lastActive'] != null
          ? (map['lastActive'] as Timestamp).toDate()
          : null,
    );
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? gender,
    String? photoURL,
    double? rating,
    int? totalRides,
    String? studentId,
    bool? verified,
    DateTime? verifiedAt,
    String? idVerificationStatus,
    String? idDocumentURL,
    String? emergencyContactName,
    String? emergencyContactPhone,
    String? emergencyContactRelationship,
    String? genderPreference,
    bool? smokingAllowed,
    bool? chatty,
    DateTime? lastActive,
  }) {
    return UserModel(
      userId: userId,
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      photoURL: photoURL ?? this.photoURL,
      rating: rating ?? this.rating,
      totalRides: totalRides ?? this.totalRides,
      universityId: universityId,
      universityName: universityName,
      verifiedEmail: verifiedEmail,
      studentId: studentId ?? this.studentId,
      verified: verified ?? this.verified,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      idVerificationStatus: idVerificationStatus ?? this.idVerificationStatus,
      idDocumentURL: idDocumentURL ?? this.idDocumentURL,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone: emergencyContactPhone ?? this.emergencyContactPhone,
      emergencyContactRelationship: emergencyContactRelationship ?? this.emergencyContactRelationship,
      genderPreference: genderPreference ?? this.genderPreference,
      smokingAllowed: smokingAllowed ?? this.smokingAllowed,
      chatty: chatty ?? this.chatty,
      createdAt: createdAt,
      lastActive: lastActive ?? this.lastActive,
    );
  }
}
