import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users collection reference
  CollectionReference get _usersCollection => _firestore.collection('users');

  // Create user document
  Future<void> createUser(UserModel user) async {
    try {
      await _usersCollection.doc(user.userId).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Get user by ID
  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  // Stream user data
  Stream<UserModel?> streamUser(String userId) {
    return _usersCollection.doc(userId).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }

  // Update user
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Update user's last active timestamp
  Future<void> updateLastActive(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'lastActive': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update last active: $e');
    }
  }

  // Check if user exists
  Future<bool> userExists(String userId) async {
    try {
      final doc = await _usersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Check if email is already registered
  Future<bool> isEmailRegistered(String email) async {
    try {
      final querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      await _usersCollection.doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Get users by university
  Future<List<UserModel>> getUsersByUniversity(String universityId) async {
    try {
      final querySnapshot = await _usersCollection
          .where('university.id', isEqualTo: universityId)
          .where('university.verified', isEqualTo: true)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get users by university: $e');
    }
  }

  // Update user rating
  Future<void> updateUserRating(String userId, double newRating, int totalRides) async {
    try {
      await _usersCollection.doc(userId).update({
        'rating': newRating,
        'totalRides': totalRides,
      });
    } catch (e) {
      throw Exception('Failed to update user rating: $e');
    }
  }

  // Update ID verification status
  Future<void> updateIdVerificationStatus({
    required String userId,
    required String status,
    String? documentURL,
  }) async {
    try {
      final data = {
        'idVerificationStatus': status,
      };
      if (documentURL != null) {
        data['idDocumentURL'] = documentURL;
      }
      await _usersCollection.doc(userId).update(data);
    } catch (e) {
      throw Exception('Failed to update verification status: $e');
    }
  }

  // Search users by name
  Future<List<UserModel>> searchUsersByName(String name) async {
    try {
      final querySnapshot = await _usersCollection
          .where('name', isGreaterThanOrEqualTo: name)
          .where('name', isLessThanOrEqualTo: '$name\uf8ff')
          .limit(20)
          .get();

      return querySnapshot.docs
          .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search users: $e');
    }
  }
}
