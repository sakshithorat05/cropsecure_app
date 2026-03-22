import 'dart:io';
import 'package:get_it/get_it.dart';
import 'cloudinary_service.dart';
import 'mongodb_service.dart';

final _getIt = GetIt.instance;

/// Helper function to upload image to Cloudinary and save URL to MongoDB
Future<String> uploadImageAndSave({
  required File imageFile,
  required String collectionName,
  required String documentId,
  required String fieldName,
  String folder = 'cropsecure',
}) async {
  try {
    // Upload to Cloudinary
    final cloudinaryService = _getIt<CloudinaryService>();
    final imageUrl = await cloudinaryService.uploadImage(imageFile, folder: folder);

    // Save URL to MongoDB
    final mongoService = _getIt<MongoDBService>();
    final collection = mongoService.getCollection(collectionName);

    await collection.updateOne(
      {'_id': documentId},
      {
        r'$set': {fieldName: imageUrl}
      },
    );

    return imageUrl;
  } catch (e) {
    print('--- Image Upload Error: $e ---');
    rethrow;
  }
}
