import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'mongodb_service.dart';
import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/profile/models/farm_history_model.dart';
import '../../models/product_model.dart';
import '../../screens/profile/models/purchase_model.dart';
import '../../../providers/plot_provider.dart';

class DatabaseService {
  final MongoDBService _mongo = MongoDBService();

  // Collection Accessors
  mongo.DbCollection get usersCollection => _mongo.getCollection('users');
  mongo.DbCollection get farmHistoryCollection => _mongo.getCollection('farm_history');
  mongo.DbCollection get plotsCollection => _mongo.getCollection('plots');
  mongo.DbCollection get diseasesCollection => _mongo.getCollection('pests_and_diseases');
  mongo.DbCollection get productsCollection => _mongo.getCollection('products');
  mongo.DbCollection get purchasesCollection => _mongo.getCollection('purchases');
  mongo.DbCollection get weatherLogsCollection => _mongo.getCollection('weather_logs');
  mongo.DbCollection get remindersCollection => _mongo.getCollection('reminders');

  // --- User Operations ---

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      return await usersCollection.findOne(mongo.where.eq('uid', uid));
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<void> saveUserProfile(String uid, Map<String, dynamic> profileData) async {
    try {
      await usersCollection.update(
        mongo.where.eq('uid', uid),
        {r'$set': profileData},
        upsert: true,
      );
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  // --- Reminder Operations ---

  Future<List<Map<String, dynamic>>> getUserReminders(String uid) async {
    try {
      final results = await remindersCollection
          .find(mongo.where.eq('uid', uid).sortBy('dueDate'))
          .toList();
      return results;
    } catch (e) {
      return [];
    }
  }

  // --- Plot Operations ---

  Future<void> addPlot(Plot plot) async {
    try {
      await plotsCollection.insert(plot.toMap());
    } catch (e) {
      throw Exception('Failed to add plot: $e');
    }
  }

  Future<List<Plot>> getUserPlots(String ownerId) async {
    try {
      final results = await plotsCollection.find(mongo.where.eq('ownerId', ownerId)).toList();
      return results.map((map) => Plot.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get plots: $e');
    }
  }

  Future<void> updatePlot(Plot plot) async {
    try {
      await plotsCollection.update(
        mongo.where.id(mongo.ObjectId.fromHexString(plot.id)),
        plot.toMap(),
      );
    } catch (e) {
      throw Exception('Failed to update plot: $e');
    }
  }

  // --- Farm History Operations ---

  Future<void> addFarmHistoryLog(String uid, Map<String, dynamic> logData) async {
    try {
      logData['uid'] = uid;
      logData['createdAt'] = DateTime.now();
      await farmHistoryCollection.insert(logData);
    } catch (e) {
      throw Exception('Failed to add farm history log: $e');
    }
  }

  Future<List<FarmHistoryModel>> getUserFarmHistory(String uid) async {
    try {
      final results = await farmHistoryCollection
          .find(mongo.where.eq('uid', uid).sortBy('createdAt', descending: true))
          .toList();

      return results.map((map) => FarmHistoryModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get farm history: $e');
    }
  }

  // --- Pests & Diseases Operations ---

  Future<List<DiseaseDetailsModel>> getAllDiseases() async {
    try {
      final results = await diseasesCollection.find().toList();
      return results.map((map) => DiseaseDetailsModel.fromJson(map, map['_id'].toHexString())).toList();
    } catch (e) {
      throw Exception('Failed to get all diseases: $e');
    }
  }

  Future<List<DiseaseDetailsModel>> getDiseasesByCrop(String cropName) async {
    try {
      // Use case-insensitive regex for better matching
      final results = await diseasesCollection.find(
        mongo.where.match('cropAffected', '^$cropName\$', caseInsensitive: true)
      ).toList();
      return results.map((map) => DiseaseDetailsModel.fromJson(map, map['_id'].toHexString())).toList();
    } catch (e) {
      throw Exception('Failed to get diseases for $cropName: $e');
    }
  }

  // --- Weather Operations ---

  Future<Map<String, dynamic>?> getLatestWeather() async {
    try {
      final results = await weatherLogsCollection
          .find(mongo.where.sortBy('timestamp', descending: true).limit(1))
          .toList();
      return results.isNotEmpty ? results.first : null;
    } catch (e) {
      return null;
    }
  }

  // --- Marketplace Operations ---

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final results = await productsCollection.find().toList();
      return results.map((map) => ProductModel.fromMap(map, map['_id'].toHexString())).toList();
    } catch (e) {
      throw Exception('Failed to get products: $e');
    }
  }

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
        'recoveryRate': '92%', 
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

  // --- Purchase Operations ---

  Future<List<PurchaseModel>> getUserPurchases(String uid) async {
    try {
      final results = await purchasesCollection
          .find(mongo.where.eq('uid', uid).sortBy('purchaseDate', descending: true))
          .toList();

      return results.map((map) => PurchaseModel.fromMap(map)).toList();
    } catch (e) {
      throw Exception('Failed to get purchases: $e');
    }
  }

  Future<void> purchaseProduct(String uid, PurchaseModel purchase) async {
    try {
      final purchaseData = {
        'uid': uid,
        'productName': purchase.productName,
        'productCategory': purchase.productCategory,
        'price': purchase.price,
        'quantity': purchase.quantity,
        'purchaseDate': DateTime.now(),
        'status': 'Completed',
        'imageUrl': purchase.imageUrl,
      };
      await purchasesCollection.insert(purchaseData);
    } catch (e) {
      throw Exception('Failed to record purchase: $e');
    }
  }
}

