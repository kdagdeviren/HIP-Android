import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_medical_data_app/features/auth/data/models/user_model.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get all users from Firestore
  Future<List<UserModel>> getAllUsers() async {
    final querySnapshot = await _firestore.collection('users').get();
    return querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }

  /// Get unverified users
  Future<List<UserModel>> getUnverifiedUsers() async {
    final querySnapshot = await _firestore
        .collection('users')
        .where('isVerified', isEqualTo: false)
        .get();
    return querySnapshot.docs
        .map((doc) => UserModel.fromJson(doc.data()))
        .toList();
  }

  /// Verify a user by updating isVerified to true
  Future<void> verifyUser(String userId) async {
    await _firestore.collection('users').doc(userId).update({
      'isVerified': true,
    });
  }

  /// Reject a user by deleting the user document (or mark as rejected)
  Future<void> rejectUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }
}
