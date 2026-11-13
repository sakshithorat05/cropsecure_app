import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'mongodb_service.dart';
import '../../screens/treatment/models/disease_details_model.dart';
import '../../screens/profile/models/farm_history_model.dart';
import '../../models/product_model.dart';
import '../../screens/profile/models/purchase_model.dart';
import '../../../providers/plot_provider.dart';

class DatabaseService {
  final MongoDBService _mongo = MongoDBService();

  // In-Memory Caches for Offline / Screen Persistence
  static final Map<String, Map<String, dynamic>> _userProfileCache = {};
  static final Map<String, List<Map<String, dynamic>>> _remindersCache = {};
  static final Map<String, List<Plot>> _plotsCache = {};
  static final Map<String, List<FarmHistoryModel>> _farmHistoryCache = {};
  static List<DiseaseDetailsModel>? _allDiseasesCache;
  static final Map<String, List<DiseaseDetailsModel>> _diseasesByCropCache = {};
  static Map<String, dynamic>? _weatherCache;
  static List<ProductModel>? _productsCache;
  static final Map<String, Map<String, dynamic>> _dashboardStatsCache = {};
  static final Map<String, List<PurchaseModel>> _purchasesCache = {};

  // Collection Accessors
  mongo.DbCollection get usersCollection => _mongo.getCollection('users');
  mongo.DbCollection get farmHistoryCollection => _mongo.getCollection('farm_history');
  mongo.DbCollection get plotsCollection => _mongo.getCollection('plots');
  mongo.DbCollection get diseasesCollection => _mongo.getCollection('pests_and_diseases');
  mongo.DbCollection get productsCollection => _mongo.getCollection('products');
  mongo.DbCollection get purchasesCollection => _mongo.getCollection('purchases');
  mongo.DbCollection get weatherLogsCollection => _mongo.getCollection('weather_logs');
  mongo.DbCollection get remindersCollection => _mongo.getCollection('reminders');

  /// Executes a query safely. If connection drops, attempts a single reconnect.
  /// If offline or network fails, gracefully returns the cached fallback.
  Future<T> _safeExecute<T>(Future<T> Function() query, {required T Function() fallback}) async {
    try {
      await _mongo.ensureConnected();
      return await query();
    } catch (e) {
      print('DatabaseService: query failed ($e), attempting reconnect...');
      try {
        await _mongo.reconnect();
        return await query();
      } catch (retryError) {
        print('DatabaseService: reconnect failed ($retryError), using cached fallback.');
        return fallback();
      }
    }
  }

  // --- User Operations ---

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    return _safeExecute<Map<String, dynamic>?>(
      () async {
        final coll = _mongo.getCollection('users');
        final doc = await coll.findOne(mongo.where.eq('uid', uid));
        if (doc != null) {
          _userProfileCache[uid] = doc;
        }
        return doc ?? _userProfileCache[uid];
      },
      fallback: () => _userProfileCache[uid],
    );
  }

  Future<void> saveUserProfile(String uid, Map<String, dynamic> profileData) async {
    _userProfileCache[uid] = {
      ...?_userProfileCache[uid],
      ...profileData,
    };

    try {
      await _mongo.ensureConnected();
      await usersCollection.update(
        mongo.where.eq('uid', uid),
        {r'$set': profileData},
        upsert: true,
      );
    } catch (e) {
      print('DatabaseService: failed to save user profile remotely: $e');
      // Already cached locally
    }
  }

  // --- Reminder Operations ---

  Future<List<Map<String, dynamic>>> getUserReminders(String uid) async {
    return _safeExecute<List<Map<String, dynamic>>>(
      () async {
        final results = await remindersCollection
            .find(mongo.where.eq('uid', uid).sortBy('dueDate'))
            .toList();
        _remindersCache[uid] = results;
        return results;
      },
      fallback: () => _remindersCache[uid] ?? [],
    );
  }

  // --- Plot Operations ---

  Future<void> addPlot(Plot plot) async {
    final currentPlots = _plotsCache[plot.ownerName] ?? [];
    _plotsCache[plot.ownerName] = [...currentPlots, plot];

    try {
      await _mongo.ensureConnected();
      await plotsCollection.insert(plot.toMap());
    } catch (e) {
      print('DatabaseService: plot added locally, remote sync error: $e');
    }
  }

  Future<List<Plot>> getUserPlots(String ownerId) async {
    return _safeExecute<List<Plot>>(
      () async {
        final results = await plotsCollection.find(mongo.where.eq('ownerId', ownerId)).toList();
        final plots = results.map((map) => Plot.fromMap(map)).toList();
        if (plots.isNotEmpty) {
          _plotsCache[ownerId] = plots;
        }
        return plots.isNotEmpty ? plots : (_plotsCache[ownerId] ?? []);
      },
      fallback: () => _plotsCache[ownerId] ?? [],
    );
  }

  Future<void> updatePlot(Plot plot) async {
    try {
      await _mongo.ensureConnected();
      await plotsCollection.update(
        mongo.where.id(mongo.ObjectId.fromHexString(plot.id)),
        plot.toMap(),
      );
    } catch (e) {
      print('DatabaseService: plot update error: $e');
    }
  }

  // --- Farm History Operations ---

  Future<void> addFarmHistoryLog(String uid, Map<String, dynamic> logData) async {
    try {
      await _mongo.ensureConnected();
      logData['uid'] = uid;
      logData['createdAt'] = DateTime.now();
      await farmHistoryCollection.insert(logData);
    } catch (e) {
      print('DatabaseService: failed to add farm history: $e');
    }
  }

  Future<List<FarmHistoryModel>> getUserFarmHistory(String uid) async {
    return _safeExecute<List<FarmHistoryModel>>(
      () async {
        final results = await farmHistoryCollection
            .find(mongo.where.eq('uid', uid).sortBy('createdAt', descending: true))
            .toList();
        final logs = results.map((map) => FarmHistoryModel.fromMap(map)).toList();
        if (logs.isNotEmpty) {
          _farmHistoryCache[uid] = logs;
        }
        return logs.isNotEmpty ? logs : (_farmHistoryCache[uid] ?? []);
      },
      fallback: () => _farmHistoryCache[uid] ?? [],
    );
  }

  // --- Pests & Diseases Operations ---

  Future<List<DiseaseDetailsModel>> getAllDiseases() async {
    return _safeExecute<List<DiseaseDetailsModel>>(
      () async {
        final coll = _mongo.getCollection('pests_and_diseases');
        final results = await coll.find().toList();
        final list = results.map((map) => DiseaseDetailsModel.fromJson(map, map['_id'].toHexString())).toList();
        if (list.isNotEmpty) {
          _allDiseasesCache = list;
        }
        return list.isNotEmpty ? list : (_allDiseasesCache ?? []);
      },
      fallback: () => _allDiseasesCache ?? [],
    );
  }

  Future<List<DiseaseDetailsModel>> getDiseasesByCrop(String cropName) async {
    final key = cropName.trim().toLowerCase();
    return _safeExecute<List<DiseaseDetailsModel>>(
      () async {
        final results = await diseasesCollection.find(
          mongo.where.match('cropAffected', '^$cropName\$', caseInsensitive: true)
        ).toList();
        final list = results.map((map) => DiseaseDetailsModel.fromJson(map, map['_id'].toHexString())).toList();
        if (list.isNotEmpty) {
          _diseasesByCropCache[key] = list;
        }
        return list.isNotEmpty ? list : (_diseasesByCropCache[key] ?? []);
      },
      fallback: () => _diseasesByCropCache[key] ?? [],
    );
  }

  // --- Weather Operations ---

  Future<Map<String, dynamic>?> getLatestWeather() async {
    return _safeExecute<Map<String, dynamic>?>(
      () async {
        final results = await weatherLogsCollection
            .find(mongo.where.sortBy('timestamp', descending: true).limit(1))
            .toList();
        if (results.isNotEmpty) {
          _weatherCache = results.first;
        }
        return results.isNotEmpty ? results.first : _weatherCache;
      },
      fallback: () => _weatherCache,
    );
  }

  // --- Marketplace Operations ---

  Future<List<ProductModel>> getAllProducts() async {
    return _safeExecute<List<ProductModel>>(
      () async {
        final results = await productsCollection.find().toList();
        final products = results.map((map) => ProductModel.fromMap(map, map['_id'].toHexString())).toList();
        if (products.isNotEmpty) {
          _productsCache = products;
        }
        return products.isNotEmpty ? products : (_productsCache ?? []);
      },
      fallback: () => _productsCache ?? [],
    );
  }

  Future<Map<String, dynamic>> getDashboardStats(String uid) async {
    try {
      final history = await getUserFarmHistory(uid);
      if (history.isEmpty && _dashboardStatsCache.containsKey(uid)) {
        return _dashboardStatsCache[uid]!;
      }

      int totalScans = history.where((l) => l.type == FarmHistoryType.scan).length;
      int treatmentsApplied = history.where((l) => l.type == FarmHistoryType.treatment).length;
      int diseasesDetected = history.where((l) => l.type == FarmHistoryType.scan && l.metadata.containsKey('disease')).length;

      final stats = {
        'totalScans': totalScans.toString(),
        'treatmentsApplied': treatmentsApplied.toString(),
        'diseasesDetected': diseasesDetected.toString(),
        'recoveryRate': '92%', 
      };
      _dashboardStatsCache[uid] = stats;
      return stats;
    } catch (e) {
      return _dashboardStatsCache[uid] ?? {
        'totalScans': '0',
        'treatmentsApplied': '0',
        'diseasesDetected': '0',
        'recoveryRate': '92%',
      };
    }
  }

  // --- Purchase Operations ---

  Future<List<PurchaseModel>> getUserPurchases(String uid) async {
    return _safeExecute<List<PurchaseModel>>(
      () async {
        final results = await purchasesCollection
            .find(mongo.where.eq('uid', uid).sortBy('purchaseDate', descending: true))
            .toList();
        final list = results.map((map) => PurchaseModel.fromMap(map)).toList();
        if (list.isNotEmpty) {
          _purchasesCache[uid] = list;
        }
        return list.isNotEmpty ? list : (_purchasesCache[uid] ?? []);
      },
      fallback: () => _purchasesCache[uid] ?? [],
    );
  }

  Future<void> purchaseProduct(String uid, PurchaseModel purchase) async {
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

    final currentPurchases = _purchasesCache[uid] ?? [];
    _purchasesCache[uid] = [purchase, ...currentPurchases];

    try {
      await _mongo.ensureConnected();
      await purchasesCollection.insert(purchaseData);
    } catch (e) {
      print('DatabaseService: purchase recorded locally, sync error: $e');
    }
  }
}
