import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  mongo.Db? _db;
  bool _isConnected = false;
  Future<void>? _connecting;

  Future<void> connect() async {
    if (_isConnected && _db != null) return;

    if (_connecting != null) {
      return _connecting!;
    }

    _connecting = _connectInternal();
    try {
      await _connecting;
    } finally {
      _connecting = null;
    }
  }

  Future<void> _connectInternal() async {
    if (_isConnected && _db != null) return;

    try {
      final url = dotenv.env['MONGODB_URL'] ?? '';
      if (url.trim().isEmpty) {
        throw Exception('MONGODB_URL is missing from .env');
      }
      _db = await mongo.Db.create(url);
      await _db!.open();
      _isConnected = true;
      print('--- Connected to MongoDB Atlas ---');
    } catch (e) {
      _db = null;
      _isConnected = false;
      print('--- MongoDB Connection Error: $e ---');
      rethrow;
    }
  }

  /// Ensure the DB is connected and open. Call this before using collections.
  Future<void> ensureConnected() async {
    if (_isConnected && _db != null) return;
    await connect();
  }

  mongo.DbCollection getCollection(String name) {
    if (_db == null) {
      throw Exception('MongoDB not connected. Call await MongoDBService().connect() or ensureConnected() before using collections.');
    }

    // If the underlying Db hasn't finished opening, give a clear error instead
    // of letting mongo_dart throw a low-level state error. We rely on
    // `_isConnected` which is set to true after a successful `open()`.
    if (!_isConnected) {
      throw Exception('MongoDB not open. Call await MongoDBService().connect() or ensureConnected() before using collections.');
    }

    return _db!.collection(name);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _isConnected = false;
  }
}
