import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MongoDBService {
  static final MongoDBService _instance = MongoDBService._internal();
  factory MongoDBService() => _instance;
  MongoDBService._internal();

  mongo.Db? _db;
  Future<void>? _connecting;

  /// True only if DB instance exists and is actively open and connected.
  bool get isConnected {
    final db = _db;
    if (db == null) return false;
    try {
      return db.isConnected && db.state == mongo.State.open;
    } catch (_) {
      return false;
    }
  }

  Future<void> connect() async {
    if (isConnected) return;

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

  /// Force-closes any stale/broken connection and opens a clean new socket.
  Future<void> reconnect() async {
    try {
      await _db?.close();
    } catch (_) {}
    _db = null;
    await connect();
  }

  Future<void> _connectInternal() async {
    if (isConnected) return;

    try {
      final url = dotenv.env['MONGODB_URL'] ?? '';
      if (url.trim().isEmpty) {
        throw Exception('MONGODB_URL is missing from .env');
      }

      if (_db != null) {
        try {
          await _db!.close();
        } catch (_) {}
        _db = null;
      }

      final newDb = await mongo.Db.create(url);
      // Bound the connection attempt so poor connectivity never hangs the app
      await newDb.open().timeout(
        const Duration(seconds: 8),
        onTimeout: () {
          try {
            newDb.close();
          } catch (_) {}
          throw Exception('MongoDB connection attempt timed out after 8s');
        },
      );

      _db = newDb;
      print('--- Connected to MongoDB Atlas ---');
    } catch (e) {
      _db = null;
      print('--- MongoDB Connection Error: $e ---');
      rethrow;
    }
  }

  /// Ensure the DB is connected and open. Auto-reconnects if the socket dropped.
  Future<void> ensureConnected() async {
    if (isConnected) return;
    await connect();
  }

  mongo.DbCollection getCollection(String name) {
    final db = _db;
    if (db == null || !isConnected) {
      throw Exception('MongoDB is not currently open. Call ensureConnected() first.');
    }
    return db.collection(name);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
