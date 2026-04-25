# cropsecure_app

A new Flutter project.

## Getting Started

This project requires environment variables for MongoDB and Cloudinary services.

### Environment Setup

1. Create a `.env` file in the root directory (one has been provided with placeholders).
2. Fill in the following keys:
   - `MONGODB_URL`: Your MongoDB Atlas connection string.
   - `CLOUDINARY_CLOUD_NAME`: Your Cloudinary Cloud Name.
   - `CLOUDINARY_API_KEY`: Your Cloudinary API Key.
   - `CLOUDINARY_API_SECRET`: Your Cloudinary API Secret.

If these are missing, the app will still start but features like image upload and database sync will fail.

### Resources
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
...

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
