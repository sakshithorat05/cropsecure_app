export 'tflite_service_stub.dart'
    if (dart.library.io) 'tflite_service_io.dart'
    if (dart.library.html) 'tflite_service_web.dart';
