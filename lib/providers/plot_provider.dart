import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PlotsNotifier extends Notifier<List<Plot>> {
  @override
  List<Plot> build() => mockPlots;

  void addPlot(Plot plot) {
    state = [...state, plot];
  }

  void updatePlot(Plot updatedPlot) {
    state = [
      for (final plot in state)
        if (plot.id == updatedPlot.id) updatedPlot else plot
    ];
  }
}

final plotsProvider = NotifierProvider<PlotsNotifier, List<Plot>>(() {
  return PlotsNotifier();
});

class ActivePlotNotifier extends Notifier<Plot?> {
  @override
  Plot? build() {
    final plots = ref.watch(plotsProvider);
    return plots.isNotEmpty ? plots.first : null;
  }

  void setActivePlot(Plot plot) {
    state = plot;
  }
}

final activePlotProvider = NotifierProvider<ActivePlotNotifier, Plot?>(() {
  return ActivePlotNotifier();
});
