import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  mongo.Db? _db;
  bool _isConnected = false;

  Future<void> connect() async {
    if (_isConnected && _db != null) return;

    try {
      final url = dotenv.env['MONGODB_URL'] ?? '';
      _db = await mongo.Db.create(url);
      await _db!.open();
      _isConnected = true;
      print('--- Connected to MongoDB Atlas ---');
    } catch (e) {
      print('--- MongoDB Connection Error: $e ---');
      rethrow;
    }
  }

  mongo.DbCollection getCollection(String name) {
    if (_db == null) throw Exception('MongoDB not connected');
    return _db!.collection(name);
  }

  Future<void> close() async {
    await _db?.close();
    _isConnected = false;
  }
}
