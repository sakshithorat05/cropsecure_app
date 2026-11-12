from __future__ import annotations

from pathlib import Path
from typing import Any

import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, ConfigDict, Field


ROOT = Path(__file__).resolve().parents[2]
JASMINE_ARTIFACT = ROOT / "jasmine_ield_prediction_xgboost_model.joblib"
IRRIGATION_ARTIFACT = ROOT / "smart_irrigation_classifier.joblib"
IRRIGATION_AMOUNT_ARTIFACT = ROOT / "smart_irrigation_amount_regressor.joblib"
IRRIGATION_METADATA = ROOT / "smart_irrigation_metadata.joblib"
BUYER_ARTIFACT = ROOT / "best_buyer_model_randomforest.joblib"
RISK_ARTIFACT = ROOT / "best_risk_model_xgboost.joblib"
DEMAND_ARTIFACT = ROOT / "best_demand_model_xgboost.joblib"
PRICE_ARTIFACT = ROOT / "best_price_model_xgboost.joblib"

if (
    not JASMINE_ARTIFACT.exists()
    or not IRRIGATION_ARTIFACT.exists()
    or not IRRIGATION_AMOUNT_ARTIFACT.exists()
    or not IRRIGATION_METADATA.exists()
    or not BUYER_ARTIFACT.exists()
    or not RISK_ARTIFACT.exists()
    or not DEMAND_ARTIFACT.exists()
    or not PRICE_ARTIFACT.exists()
):
    raise RuntimeError("Required CropSecure ML artifacts are missing from the project root.")

_jasmine_bundle: dict[str, Any] = joblib.load(JASMINE_ARTIFACT)
_irrigation_model = joblib.load(IRRIGATION_ARTIFACT)
_irrigation_amount_model = joblib.load(IRRIGATION_AMOUNT_ARTIFACT)
_irrigation_metadata: dict[str, Any] = joblib.load(IRRIGATION_METADATA)
_buyer_model = joblib.load(BUYER_ARTIFACT)
_risk_model = joblib.load(RISK_ARTIFACT)
_demand_model = joblib.load(DEMAND_ARTIFACT)
_price_model = joblib.load(PRICE_ARTIFACT)

JASMINE_FEATURES = [
    *_jasmine_bundle["features"]["numerical"],
    *_jasmine_bundle["features"]["categorical"],
]
JASMINE_FEATURES = [
    feature
    for feature in _jasmine_bundle["preprocessor"].feature_names_in_
    if feature in JASMINE_FEATURES
]
IRRIGATION_FEATURES = list(_irrigation_metadata["feature_columns"])
MARKET_FEATURES = list(_demand_model.feature_names_in_)
MARKET_BASE_FEATURES = list(_price_model.feature_names_in_)

_irrigation_preprocessor = _irrigation_model.named_steps["preprocessor"]
_categorical_values: dict[str, set[str]] = {}
for pipeline in (_irrigation_model, _demand_model):
    preprocessor = pipeline.named_steps["preprocessor"]
    for _, transformer, columns in preprocessor.transformers_:
        if hasattr(transformer, "categories_"):
            for column, values in zip(columns, transformer.categories_):
                _categorical_values[column] = {str(value) for value in values}


class FeaturesRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")
    features: dict[str, Any] = Field(..., min_length=1)


app = FastAPI(title="CropSecure ML API", version="1.0.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


def _validated_frame(features: dict[str, Any], expected: list[str]) -> pd.DataFrame:
    missing = [feature for feature in expected if feature not in features]
    unknown = [feature for feature in features if feature not in expected]
    if missing or unknown:
        detail: dict[str, list[str]] = {}
        if missing:
            detail["missing_features"] = missing
        if unknown:
            detail["unknown_features"] = unknown
        raise HTTPException(status_code=422, detail=detail)

    for feature, allowed in _categorical_values.items():
        if feature in expected and str(features[feature]) not in allowed:
            raise HTTPException(
                status_code=422,
                detail={
                    "feature": feature,
                    "allowed_values": sorted(allowed),
                    "received": features[feature],
                },
            )

    frame = pd.DataFrame([{feature: features[feature] for feature in expected}])
    for feature in expected:
        if feature not in _categorical_values:
            try:
                frame[feature] = pd.to_numeric(frame[feature], errors="raise")
            except (TypeError, ValueError) as error:
                raise HTTPException(
                    status_code=422,
                    detail={"feature": feature, "message": "Expected a numeric value."},
                ) from error
    return frame


@app.get("/health")
def health() -> dict[str, Any]:
    return {
        "status": "ok",
        "models": {
            "jasmine_yield": _jasmine_bundle["model_name"],
            "smart_irrigation": _irrigation_metadata["best_classifier"],
            "smart_irrigation_amount": _irrigation_metadata["best_regressor"],
            "market_buyer": "RandomForest",
            "market_risk": "XGBoost",
            "market_demand": "XGBoost",
            "market_price": "XGBoost",
        },
    }


@app.post("/predict/jasmine-yield")
def predict_jasmine_yield(request: FeaturesRequest) -> dict[str, Any]:
    frame = _validated_frame(request.features, JASMINE_FEATURES)
    transformed = _jasmine_bundle["preprocessor"].transform(frame)
    prediction = _jasmine_bundle["model"].predict(transformed)
    return {
        "prediction": float(prediction[0]),
        "target": "jasmine_yield",
        "unit": "kg_per_acre",
    }


@app.post("/predict/smart-irrigation")
def predict_smart_irrigation(request: FeaturesRequest) -> dict[str, Any]:
    frame = _validated_frame(request.features, IRRIGATION_FEATURES)
    predicted_class = _irrigation_model.predict(frame)[0]
    probabilities = _irrigation_model.predict_proba(frame)[0]
    recommended_amount = _irrigation_amount_model.predict(frame)[0]
    classes = _irrigation_model.classes_
    return {
        "predicted_class": int(predicted_class),
        "probabilities": {
            str(int(label)): float(probability)
            for label, probability in zip(classes, probabilities)
        },
        "recommended_irrigation_l_per_plant": float(recommended_amount),
        "target": _irrigation_metadata["classification_target"],
        "regression_target": _irrigation_metadata["regression_target"],
    }


@app.post("/predict/smart-irrigation-amount")
def predict_smart_irrigation_amount(request: FeaturesRequest) -> dict[str, Any]:
    frame = _validated_frame(request.features, IRRIGATION_FEATURES)
    prediction = _irrigation_amount_model.predict(frame)
    return {
        "prediction": float(prediction[0]),
        "target": _irrigation_metadata["regression_target"],
        "unit": "l_per_plant",
    }


@app.post("/predict/market-insights")
def predict_market_insights(request: FeaturesRequest) -> dict[str, Any]:
    frame = _validated_frame(request.features, MARKET_FEATURES)
    base_frame = frame[MARKET_BASE_FEATURES]
    risk_class = _risk_model.predict(base_frame)[0]
    risk_probabilities = _risk_model.predict_proba(base_frame)[0]
    return {
        "buyer_prediction": float(_buyer_model.predict(base_frame)[0]),
        "risk_class": int(risk_class),
        "risk_probabilities": {
            str(int(label)): float(probability)
            for label, probability in zip(_risk_model.classes_, risk_probabilities)
        },
        "demand_prediction": float(_demand_model.predict(frame)[0]),
        "price_prediction": float(_price_model.predict(base_frame)[0]),
    }
