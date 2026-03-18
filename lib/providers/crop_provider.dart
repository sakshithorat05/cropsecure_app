import 'package:flutter_riverpod/flutter_riverpod.dart';

class Crop {
  final String id;
  final String name;
  final String variety;
  final String stage;
  final String imageUrl;

  const Crop({
    required this.id,
    required this.name,
    required this.variety,
    required this.stage,
    required this.imageUrl,
  });
}

final cropProvider = NotifierProvider<CropNotifier, List<Crop>>(() {
  return CropNotifier();
});

class CropNotifier extends Notifier<List<Crop>> {
  @override
  List<Crop> build() => [];

  void addCrop(Crop crop) {
    state = [...state, crop];
  }

  void removeCrop(String id) {
    state = state.where((crop) => crop.id != id).toList();
  }
}

final selectedCropProvider = NotifierProvider<SelectedCropNotifier, Crop?>(() {
  return SelectedCropNotifier();
});

class SelectedCropNotifier extends Notifier<Crop?> {
  @override
  Crop? build() => null;
  void setCrop(Crop? crop) => state = crop;
}
