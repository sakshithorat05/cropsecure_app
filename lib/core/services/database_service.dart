import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get farmHistoryCollection => _firestore.collection('farm_history');
  CollectionReference get diseasesCollection => _firestore.collection('pests_and_diseases');

  // --- User Operations ---

  /// Creates or updates a user profile document
  Future<void> saveUserProfile(String uid, Map<String, dynamic> userData) async {
    try {
      await usersCollection.doc(uid).set(userData, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Fetches a user profile document
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await usersCollection.doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  // --- Farm History Operations ---

  /// Adds a new farm history log for a specific user
  Future<void> addFarmHistoryLog(String uid, Map<String, dynamic> logData) async {
    try {
      logData['uid'] = uid;
      logData['createdAt'] = FieldValue.serverTimestamp();
      await farmHistoryCollection.add(logData);
    } catch (e) {
      throw Exception('Failed to add farm history log: $e');
    }
  }

  /// Fetches the farm history logs for a specific user ordered by newest
  Future<List<Map<String, dynamic>>> getUserFarmHistory(String uid) async {
    try {
      QuerySnapshot querySnapshot = await farmHistoryCollection
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Failed to get farm history: $e');
    }
  }

  // --- Pests & Diseases Operations ---

  /// Fetches a list of diseases filtered by a specific crop stage
  Future<List<Map<String, dynamic>>> getDiseasesByStage(String stage) async {
    try {
      QuerySnapshot querySnapshot = await diseasesCollection
          .where('stage', isEqualTo: stage)
          .get();

      return querySnapshot.docs
          .map((doc) => {...doc.data() as Map<String, dynamic>, 'id': doc.id})
          .toList();
    } catch (e) {
      throw Exception('Failed to get diseases by stage: $e');
    }
  }
}
