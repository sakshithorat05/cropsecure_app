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

## Machine-learning backend

The supplied Jasmine yield and Smart Irrigation artifacts are served by the FastAPI
backend in `backend/`. Create a Python environment, install the pinned runtime
dependencies, and start the API from the repository root:

```powershell
python -m venv .venv
.venv\Scripts\Activate.ps1
python -m pip install -r backend\requirements.txt
python -m backend.app
```

The API listens on `http://localhost:8000`. The Android emulator reaches that
server through `http://10.0.2.2:8000`, which is the Flutter default in
`lib/core/constants/app_constants.dart`. Change that constant for a physical
device or deployed backend.

Available endpoints:

- `GET /health`
- `POST /predict/jasmine-yield`
- `POST /predict/smart-irrigation`
- `POST /predict/smart-irrigation-amount`

Both prediction endpoints accept `{ "features": { ... } }`. The Flutter forms
send every required feature and validate numeric fields and trained categorical
values before submitting. Smart Irrigation intentionally displays numeric class
`0` or `1` and the model probabilities because the supplied metadata does not
contain human-readable class labels.

The Smart Irrigation response also includes the recommended irrigation amount
from `smart_irrigation_amount_regressor.joblib` in litres per plant.

### Resources
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
...

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
