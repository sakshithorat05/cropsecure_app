/**
 * MONGODB SEED SCRIPT: CropSecure (Indestructible & Paste-Safe)
 * Run this in your MongoDB Atlas 'mongosh' or Compass 'MDB Shell'
 */

// We use direct db.getSiblingDB calls everywhere for 100% paste safety.

// --- CLEANUP INDEXES ---
print("🧹 Cleaning up old indexes...");
try {
    db.getSiblingDB('CropSecureDB').plots.dropIndexes();
} catch (e) {
    print("No indexes to drop or collection doesn't exist yet.");
}

// --- 1. USER PROFILE ---
db.getSiblingDB('CropSecureDB').users.deleteMany({ "uid": "user_123" });
db.getSiblingDB('CropSecureDB').users.insertOne({
  "uid": "user_123",
  "name": "Sakshi Thorat",
  "phone": "9876543210",
  "profile": {
    "fatherName": "Rajesh Thorat",
    "dob": ISODate("1995-10-15T00:00:00Z"),
    "gender": "Female",
    "age": "28",
    "caste": "OBC",
    "isHandicapped": "No",
    "isMinority": "No"
  },
  "address": {
    "village": "Theni",
    "district": "Theni",
    "taluka": "Theni-West",
    "state": "Tamil Nadu",
    "pincode": "625531"
  },
  "kyc": {
    "aadhar": "123456781234",
    "pan": "ABCDE1234F",
    "ration": "987654321"
  }
});

// --- 2. PLOTS ---
db.getSiblingDB('CropSecureDB').plots.deleteMany({ "ownerId": "user_123" });
db.getSiblingDB('CropSecureDB').plots.insertMany([
  {
    "ownerId": "user_123",
    "surveyNo": "124/A",
    "cropName": "Jasmine",
    "variety": "Sambangi",
    "area": "1.2",
    "unit": "Hectares",
    "location": "Theni-West, Theni",
    "status": "At Risk",
    "lastScan": "21 Mar 2024",
    "cropSeason": "Kharif",
    "sowingDate": ISODate("2024-03-01T00:00:00Z"),
    "ownerName": "Sakshi"
  },
  {
    "ownerId": "user_123",
    "surveyNo": "125/B",
    "cropName": "Tomato",
    "variety": "Hybrid-7",
    "area": "0.8",
    "unit": "Acres",
    "location": "Theni-East, Theni",
    "status": "Healthy",
    "lastScan": "Just now",
    "cropSeason": "Rabi",
    "sowingDate": ISODate("2024-02-15T00:00:00Z"),
    "ownerName": "Sakshi"
  }
]);

// --- 3. PESTS & DISEASES ---
db.getSiblingDB('CropSecureDB').pests_and_diseases.deleteMany({});
db.getSiblingDB('CropSecureDB').pests_and_diseases.insertMany([
  {
    "cropAffected": "Jasmine",
    "diseaseName": "Leaf Blight",
    "stages": ["Seedling", "Vegetative"],
    "diseaseType": "Fungal",
    "scientificName": "Exserohilum turcicum",
    "causalOrganism": "Fungus",
    "symptoms": [
      {
        "title": "Leaf Lesions",
        "iconName": "eco",
        "bullets": ["Oval water-soaked spots", "Browning of leaf tips"]
      }
    ],
    "organicTreatments": [
      {
        "title": "Neem Oil Spray",
        "type": "Organic",
        "use": "Foliar Spray",
        "dose": "5ml/L",
        "steps": ["Mix with soap water", "Spray thoroughly after sunset", "Apply twice a month"],
        "estimatedCost": "₹120",
        "repeatAfter": "10 days",
        "bestTime": "Evening",
        "benefit": "Effective antifungal and insect deterrent."
      }
    ],
    "chemicalTreatments": [
      {
        "title": "Mancozeb 75 WP",
        "type": "Chemical",
        "use": "Foliar Spray",
        "dose": "2g/L",
        "steps": ["Wear safety gear", "Mix thoroughly with water", "Spray affected areas only"],
        "estimatedCost": "₹450",
        "repeatAfter": "15 days",
        "bestTime": "Early Morning",
        "benefit": "Broad spectrum contact fungicide."
      }
    ],
    "preventiveMeasures": ["Crop rotation", "Proper spacing"]
  },
  {
    "cropAffected": "Tomato",
    "diseaseName": "Early Blight",
    "stages": ["Vegetative", "Flowering", "Harvesting"],
    "diseaseType": "Fungal",
    "scientificName": "Alternaria solani",
    "symptoms": [
      {
        "title": "Concentric Rings",
        "iconName": "circle_outlined",
        "bullets": ["Target-like spots on lower leaves", "Premature leaf fall"]
      }
    ],
    "organicTreatments": [
      {
        "title": "Bio-Fungicide (Bacillus subtilis)",
        "type": "Organic",
        "use": "Drenching",
        "dose": "10g/L",
        "steps": ["Apply to root zone", "Use in moist soil"],
        "estimatedCost": "₹280",
        "repeatAfter": "15 days",
        "bestTime": "Evening",
        "benefit": "Natural bacterial protection for roots."
      }
    ],
    "chemicalTreatments": [],
    "preventiveMeasures": ["Mulching", "Drip irrigation"]
  }
]);

// --- 4. DASHBOARD REMINDERS ---
db.getSiblingDB('CropSecureDB').reminders.deleteMany({ "uid": "user_123" });
db.getSiblingDB('CropSecureDB').reminders.insertMany([
  { "uid": "user_123", "title": "Spray scheduled 8 PM", "dueDate": ISODate("2024-03-22T20:00:00Z") },
  { "uid": "user_123", "title": "Check soil moisture level", "dueDate": ISODate("2024-03-23T08:00:00Z") },
  { "uid": "user_123", "title": "Market fertilizer check", "dueDate": ISODate("2024-03-23T10:00:00Z") }
]);

// --- 5. WEATHER LOGS ---
db.getSiblingDB('CropSecureDB').weather_logs.deleteMany({});
db.getSiblingDB('CropSecureDB').weather_logs.insertOne({
  "humidity": "Normal (65%)",
  "temperature": "28.5°C",
  "condition": "Partly Cloudy",
  "timestamp": ISODate("2024-03-22T19:00:00Z")
});

// --- 6. MARKETPLACE PRODUCTS ---
db.getSiblingDB('CropSecureDB').products.deleteMany({});
db.getSiblingDB('CropSecureDB').products.insertMany([
  {
    "name": "Blue Copper",
    "brandName": "Brand A",
    "category": "Fungicide",
    "imageUrls": [],
    "pricePerUnit": 550,
    "unitLabel": "per kg",
    "weightOrVolume": 1,
    "weightUnit": "kg",
    "inStock": true,
    "rating": 4.5,
    "reviewCount": 320,
    "alsoKnownAs": ["Copper Oxychloride 50% WP"],
    "targetDiseases": ["Leaf Spot", "Canker", "Late Blight"],
    "safetyInstructions": "Use gloves and mask during application. " + 
                          "Avoid spraying on windy days.",
    "dosagePerAcre": 2.5,
    "dosageUnit": "kg",
    "relatedProductIds": [],
    "description": "Powerful copper-based fungicide for broad-spectrum protection."
  },
  {
    "name": "Trichoderma",
    "brandName": "Brand B",
    "category": "Fungicide",
    "imageUrls": [],
    "pricePerUnit": 250,
    "unitLabel": "per kg",
    "weightOrVolume": 1,
    "weightUnit": "kg",
    "inStock": true,
    "rating": 4.8,
    "reviewCount": 150,
    "alsoKnownAs": ["Trichoderma Viride Powder"],
    "targetDiseases": ["Root Rot", "Wilt"],
    "safetyInstructions": "Keep away from direct sunlight. " + 
                          "Do not mix with chemical fungicides.",
    "dosagePerAcre": 1.0,
    "dosageUnit": "kg",
    "relatedProductIds": [],
    "description": "Natural bio-fungicide for soil health and root protection."
  },
  {
    "name": "Urea",
    "brandName": "Brand X",
    "category": "Fertiliser",
    "imageUrls": [],
    "pricePerUnit": 250,
    "unitLabel": "per 50kg bag",
    "weightOrVolume": 50,
    "weightUnit": "kg",
    "inStock": true,
    "rating": 4.6,
    "reviewCount": 500,
    "alsoKnownAs": ["Nitrogen 46%"],
    "targetDiseases": [],
    "safetyInstructions": "Apply to soil, avoid direct leaf contact.",
    "dosagePerAcre": 50.0,
    "dosageUnit": "kg",
    "relatedProductIds": [],
    "description": "High-nitrogen fertilizer for rapid vegetative growth."
  }
]);

// --- 7. FARM HISTORY ---
db.getSiblingDB('CropSecureDB').farm_history.deleteMany({ "uid": "user_123" });
db.getSiblingDB('CropSecureDB').farm_history.insertMany([
  {
    "uid": "user_123",
    "type": "scan",
    "title": "Scan Result",
    "subtitle": "Leaf Blight detected",
    "createdAt": ISODate("2024-03-21T10:30:00Z"),
    "metadata": { "disease": "Leaf Blight", "severity": "Medium" }
  },
  {
    "uid": "user_123",
    "type": "treatment",
    "title": "Treatment Applied",
    "subtitle": "Neem Oil Spray",
    "createdAt": ISODate("2024-03-20T08:00:00Z"),
    "metadata": { "treatment": "Neem Oil", "type": "Organic" }
  }
]);

// --- 8. PURCHASE HISTORY ---
db.getSiblingDB('CropSecureDB').purchases.deleteMany({ "uid": "user_123" });
db.getSiblingDB('CropSecureDB').purchases.insertMany([
  {
    "uid": "user_123",
    "productName": "Bio-Nitro Fertilizer",
    "productCategory": "Fertilizers",
    "price": 450,
    "quantity": 1,
    "purchaseDate": ISODate("2024-03-15T14:30:00Z"),
    "status": "Completed",
    "imageUrl": ""
  },
  {
    "uid": "user_123",
    "productName": "Organic Neem Oil",
    "productCategory": "Pesticides",
    "price": 320,
    "quantity": 2,
    "purchaseDate": ISODate("2024-03-10T11:00:00Z"),
    "status": "Completed",
    "imageUrl": ""
  }
]);

print("✅ Data Seeding Complete!");
