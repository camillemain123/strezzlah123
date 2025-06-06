import numpy as np
from sklearn.ensemble import RandomForestClassifier
import joblib
import os

# DASS-21 scoring thresholds
DEPRESSION_THRESHOLDS = {
    'normal': 9,
    'mild': 13,
    'moderate': 20,
    'severe': 27,
    'extremely_severe': float('inf')
}

ANXIETY_THRESHOLDS = {
    'normal': 7,
    'mild': 9,
    'moderate': 14,
    'severe': 19,
    'extremely_severe': float('inf')
}

STRESS_THRESHOLDS = {
    'normal': 14,
    'mild': 18,
    'moderate': 25,
    'severe': 33,
    'extremely_severe': float('inf')
}

def calculate_scores(responses):
    """
    Calculate DASS-21 scores from questionnaire responses
    responses: list of 21 integers (0-3)
    """
    # Depression items: 3, 5, 10, 13, 16, 17, 21
    depression_items = [2, 4, 9, 12, 15, 16, 20]
    depression_score = sum(responses[i] for i in depression_items) * 2

    # Anxiety items: 2, 4, 7, 9, 15, 19, 20
    anxiety_items = [1, 3, 6, 8, 14, 18, 19]
    anxiety_score = sum(responses[i] for i in anxiety_items) * 2

    # Stress items: 1, 6, 8, 11, 12, 14, 18
    stress_items = [0, 5, 7, 10, 11, 13, 17]
    stress_score = sum(responses[i] for i in stress_items) * 2

    return depression_score, anxiety_score, stress_score

def get_severity_level(score, category):
    """
    Get severity level based on score and category
    """
    thresholds = {
        'depression': DEPRESSION_THRESHOLDS,
        'anxiety': ANXIETY_THRESHOLDS,
        'stress': STRESS_THRESHOLDS
    }[category]

    if score < thresholds['normal']:
        return 'Normal'
    elif score < thresholds['mild']:
        return 'Mild'
    elif score < thresholds['moderate']:
        return 'Moderate'
    elif score < thresholds['severe']:
        return 'Severe'
    else:
        return 'Extremely Severe'

class StressClassifier:
    def __init__(self):
        self.model = None
        self.scaler = None
        self.model_path = os.path.join(os.path.dirname(__file__), '..', 'ml_model', 'stress_classifier.joblib')
        self.scaler_path = os.path.join(os.path.dirname(__file__), '..', 'ml_model', 'scaler.joblib')
        self.load_model()

    def load_model(self):
        """Load the trained model and scaler if they exist"""
        try:
            self.model = joblib.load(self.model_path)
            self.scaler = joblib.load(self.scaler_path)
        except:
            print("Model or scaler not found. Please train the model first.")
            self.model = RandomForestClassifier(n_estimators=100, random_state=42)
            self.scaler = None

    def predict(self, features):
        """Make predictions using the model. Expects a list of 20 feature values in the same order as the training data."""
        if self.model is None or self.scaler is None:
            return None
        X = np.array([features])
        X_scaled = self.scaler.transform(X)
        return self.model.predict(X_scaled)[0]

    def get_feedback(self, depression_score, anxiety_score, stress_score, prediction=None):
        """
        Generate personalized feedback based on scores and ML prediction.
        """
        feedback = []
        
        # Depression feedback
        if depression_score >= DEPRESSION_THRESHOLDS['moderate']:
            feedback.append("Consider speaking with a mental health professional about your feelings of depression.")
        elif depression_score >= DEPRESSION_THRESHOLDS['mild']:
            feedback.append("Try to maintain a regular sleep schedule and engage in activities you usually enjoy.")
        
        # Anxiety feedback
        if anxiety_score >= ANXIETY_THRESHOLDS['moderate']:
            feedback.append("Practice deep breathing exercises and consider mindfulness meditation to manage anxiety.")
        elif anxiety_score >= ANXIETY_THRESHOLDS['mild']:
            feedback.append("Regular physical exercise can help reduce anxiety symptoms.")
        
        # Stress feedback
        if stress_score >= STRESS_THRESHOLDS['moderate']:
            feedback.append("Implement stress management techniques like progressive muscle relaxation.")
        elif stress_score >= STRESS_THRESHOLDS['mild']:
            feedback.append("Try to maintain a healthy work-life balance and take regular breaks.")
        
        # ML prediction feedback
        if prediction is not None:
            if prediction >= 2:
                feedback.append("Based on your additional factors, consider seeking professional help to address your stress levels.")
            else:
                feedback.append("Your additional factors suggest you are managing stress well. Keep up the good habits!")
        
        # General recommendations
        feedback.append("Remember to stay hydrated and maintain a balanced diet.")
        feedback.append("Regular exercise and adequate sleep are important for mental health.")
        
        return " ".join(feedback) 