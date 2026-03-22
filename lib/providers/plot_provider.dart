import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/database_service.dart';

class Plot {
  final String id;
  final String surveyNo;
  final String cropName;
  final String variety;
  final String area;
  final String unit;
  final String ownerName;
  final String location;
  final String status; // 'Healthy', 'At Risk', 'Investigate'
  final String lastScan;

  // Detailed Crop Fields
  final String? cropType;
  final String? cropSeason;
  final String? seedSource;
  final String? specificTech;
  final String? seedTreatment;
  final DateTime? sowingDate;
  final bool hasMixedCrop;
  final String? mixedCropName;
  final String? mixedCropVariety;
  final String? mixedCropSpecificTech;

  const Plot({
    required this.id,
    required this.surveyNo,
    required this.cropName,
    required this.variety,
    required this.area,
    required this.unit,
    required this.ownerName,
    required this.location,
    this.status = 'Healthy',
    this.lastScan = 'N/A',
    this.cropType,
    this.cropSeason,
    this.seedSource,
    this.specificTech,
    this.seedTreatment,
    this.sowingDate,
    this.hasMixedCrop = false,
    this.mixedCropName,
    this.mixedCropVariety,
    this.mixedCropSpecificTech,
  });

  Plot copyWith({
    String? cropName,
    String? variety,
    String? cropType,
    String? cropSeason,
    String? seedSource,
    String? specificTech,
    String? seedTreatment,
    DateTime? sowingDate,
    bool? hasMixedCrop,
    String? mixedCropName,
    String? mixedCropVariety,
    String? mixedCropSpecificTech,
    String? status,
    String? lastScan,
  }) {
    return Plot(
      id: id,
      surveyNo: surveyNo,
      cropName: cropName ?? this.cropName,
      variety: variety ?? this.variety,
      area: area,
      unit: unit,
      ownerName: ownerName,
      location: location,
      status: status ?? this.status,
      lastScan: lastScan ?? this.lastScan,
      cropType: cropType ?? this.cropType,
      cropSeason: cropSeason ?? this.cropSeason,
      seedSource: seedSource ?? this.seedSource,
      specificTech: specificTech ?? this.specificTech,
      seedTreatment: seedTreatment ?? this.seedTreatment,
      sowingDate: sowingDate ?? this.sowingDate,
      hasMixedCrop: hasMixedCrop ?? this.hasMixedCrop,
      mixedCropName: mixedCropName ?? this.mixedCropName,
      mixedCropVariety: mixedCropVariety ?? this.mixedCropVariety,
      mixedCropSpecificTech: mixedCropSpecificTech ?? this.mixedCropSpecificTech,
    );
  }

  factory Plot.fromMap(Map<String, dynamic> map) {
    // Handle both nested and top-level fields for robustness
    final landDetails = map['landDetails'] as Map<String, dynamic>?;
    final areaValue = landDetails != null ? landDetails['area'] : map['area'];
    final unitValue = landDetails != null ? landDetails['unit'] : map['unit'];

    String locationValue = 'Unknown';
    final rawLocation = map['location'];
    if (rawLocation is String) {
      locationValue = rawLocation;
    } else if (rawLocation is Map && rawLocation['coordinates'] != null) {
      final coords = rawLocation['coordinates'] as List;
      locationValue = '${coords[1]}, ${coords[0]}';
    }

    return Plot(
      id: map['_id']?.toHexString() ?? map['id'] ?? '',
      surveyNo: map['surveyNo'] ?? '',
      cropName: map['cropName'] ?? '',
      variety: map['variety'] ?? '',
      area: areaValue?.toString() ?? '0',
      unit: unitValue ?? 'Acres',
      ownerName: map['ownerName'] ?? 'Farmer',
      location: locationValue,
      status: map['status'] ?? 'Healthy',
      lastScan: map['lastScan'] ?? 'N/A',
      cropType: map['cropType'],
      cropSeason: map['cropSeason'],
      seedSource: map['seedSource'],
      specificTech: map['specificTech'],
      seedTreatment: map['seedTreatment'],
      sowingDate: map['sowingDate'] is DateTime ? map['sowingDate'] : null,
      hasMixedCrop: map['hasMixedCrop'] ?? false,
      mixedCropName: map['mixedCropName'],
      mixedCropVariety: map['mixedCropVariety'],
      mixedCropSpecificTech: map['mixedCropSpecificTech'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'surveyNo': surveyNo,
      'cropName': cropName,
      'variety': variety,
      'landDetails': {
        'area': double.tryParse(area) ?? 0.0,
        'unit': unit,
      },
      'location': {
        'type': 'Point',
        'coordinates': [
          double.tryParse(location.split(',')[1].trim()) ?? 0.0,
          double.tryParse(location.split(',')[0].trim()) ?? 0.0,
        ],
      },
      'status': status,
      'lastScan': lastScan,
      'cropType': cropType,
      'cropSeason': cropSeason,
      'seedSource': seedSource,
      'specificTech': specificTech,
      'seedTreatment': seedTreatment,
      'sowingDate': sowingDate,
      'hasMixedCrop': hasMixedCrop,
      'mixedCropName': mixedCropName,
      'mixedCropVariety': mixedCropVariety,
      'mixedCropSpecificTech': mixedCropSpecificTech,
    };
  }
}

// Mock Data for testing
final List<Plot> mockPlots = [
  const Plot(
    id: 'plot_1',
    surveyNo: '124/A',
    cropName: 'Jasmine',
    variety: 'Sambangi',
    area: '1.2',
    unit: 'Hectares',
    ownerName: 'Sakshi',
    location: 'Theni, TN',
    status: 'At Risk',
    lastScan: 'Yesterday',
  ),
  const Plot(
    id: 'plot_2',
    surveyNo: '125/B',
    cropName: 'Marigold',
    variety: 'African Orange',
    area: '0.8',
    unit: 'Acre',
    ownerName: 'Sakshi',
    location: 'Theni, TN',
    status: 'Healthy',
    lastScan: '3 days ago',
  ),
  const Plot(
    id: 'plot_3',
    surveyNo: '78/1',
    cropName: 'Tomato',
    variety: 'Hybrid-7',
    area: '2.5',
    unit: 'Guntha',
    ownerName: 'Sakshi',
    location: 'Dindigul, TN',
    status: 'Healthy',
    lastScan: 'Just now',
  ),
];

class PlotsNotifier extends AsyncNotifier<List<Plot>> {
  final DatabaseService _db = DatabaseService();
  final String _tempUid = 'user_123';

  @override
  Future<List<Plot>> build() async {
    return _db.getUserPlots(_tempUid);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _db.getUserPlots(_tempUid));
  }

  Future<void> addPlot(Plot plot) async {
    state = const AsyncLoading();
    try {
      await _db.addPlot(plot);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updatePlot(Plot plot) async {
    state = const AsyncLoading();
    try {
      await _db.updatePlot(plot);
      await refresh();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final plotsProvider = AsyncNotifierProvider<PlotsNotifier, List<Plot>>(() {
  return PlotsNotifier();
});

class ActivePlotNotifier extends Notifier<Plot?> {
  @override
  Plot? build() {
    final plotsAsync = ref.watch(plotsProvider);
    return plotsAsync.when(
      data: (plots) => plots.isNotEmpty ? plots.first : null,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  void setActivePlot(Plot plot) {
    state = plot;
  }
}

final activePlotProvider = NotifierProvider<ActivePlotNotifier, Plot?>(() {
  return ActivePlotNotifier();
});
