import 'package:cloud_firestore/cloud_firestore.dart';
import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/profile/models/farm_history_model.dart';
import '../../screens/marketplace/models/product_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection References
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get farmHistoryCollection => _firestore.collection('farm_history');
  CollectionReference get productsCollection => _firestore.collection('products');
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
  Future<List<FarmHistoryModel>> getUserFarmHistory(String uid) async {
    try {
      QuerySnapshot querySnapshot = await farmHistoryCollection
          .where('uid', isEqualTo: uid)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => FarmHistoryModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get farm history: $e');
    }
  }

  // --- Pests & Diseases Operations ---

  /// Fetches all diseases to be grouped locally
  Future<List<DiseaseDetailsModel>> getAllDiseases() async {
    try {
      QuerySnapshot querySnapshot = await diseasesCollection.get();

      return querySnapshot.docs
          .map((doc) => DiseaseDetailsModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get all diseases: $e');
    }
  }

  // --- Marketplace Operations ---

  /// Fetches all products for the marketplace
  Future<List<ProductModel>> getAllProducts() async {
    try {
      QuerySnapshot querySnapshot = await productsCollection.get();
      return querySnapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

  /// Fetches summary stats for the dashboard
  Future<Map<String, dynamic>> getDashboardStats(String uid) async {
    try {
      final history = await getUserFarmHistory(uid);
      
      int totalScans = history.where((l) => l.type == FarmHistoryType.scan).length;
      int treatmentsApplied = history.where((l) => l.type == FarmHistoryType.treatment).length;
      int diseasesDetected = history.where((l) => l.type == FarmHistoryType.scan && l.metadata.containsKey('disease')).length;

      return {
        'totalScans': totalScans.toString(),
        'treatmentsApplied': treatmentsApplied.toString(),
        'diseasesDetected': diseasesDetected.toString(),
        'recoveryRate': '92%', // Placeholder for now or calculate if logic exists
      };
    } catch (e) {
      return {
        'totalScans': '0',
        'treatmentsApplied': '0',
        'diseasesDetected': '0',
        'recoveryRate': '0%',
      };
    }
  }
}

