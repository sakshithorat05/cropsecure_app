import 'package:flutter/material.dart';

class DiseaseDetailsModel {
  final String diseaseName;
  final String cropAffected;
  final String diseaseType;
  final String causalOrganism;
  final String affectedPlantPart;
  final String primarySpread;
  final String severityLevel;
  final String description;
  final String imageUrl;
  final List<IdentifyStage> identifyStages;
  final List<FavourableCondition> favourableConditions;

  DiseaseDetailsModel({
    required this.diseaseName,
    required this.cropAffected,
    required this.diseaseType,
    required this.causalOrganism,
    required this.affectedPlantPart,
    required this.primarySpread,
    required this.severityLevel,
    required this.description,
    required this.imageUrl,
    required this.identifyStages,
    required this.favourableConditions,
  });
}

class IdentifyStage {
  final int stageNumber;
  final String title;
  final String description;

  IdentifyStage({
    required this.stageNumber,
    required this.title,
    required this.description,
  });
}

class FavourableCondition {
  final IconData icon;
  final String title;
  final String description;
  final Color backgroundColor;

  FavourableCondition({
    required this.icon,
    required this.title,
    required this.description,
    required this.backgroundColor,
  });
}
