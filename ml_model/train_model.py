import sys
import os
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
import joblib

def train_stress_model(data_path):
    """
    Train the stress classification model using StressLevelDataset.csv
    data_path: path to the CSV file
    """
    # Load data
    df = pd.read_csv(data_path)
    
    # Features: all columns except 'stress_level'
    X = df.drop(columns=['stress_level'])
    y = df['stress_level']
    
    # Encode target if not numeric
    if y.dtype == 'O' or not np.issubdtype(y.dtype, np.number):
        le = LabelEncoder()
        y = le.fit_transform(y)
        joblib.dump(le, os.path.join(os.path.dirname(__file__), 'label_encoder.joblib'))
    
    # Fill missing values if any
    X = X.fillna(X.mean())
    
    # Split the data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Scale the features
    scaler = StandardScaler()
    X_train_scaled = scaler.fit_transform(X_train)
    X_test_scaled = scaler.transform(X_test)
    
    # Train the model
    model = RandomForestClassifier(n_estimators=100, random_state=42)
    model.fit(X_train_scaled, y_train)
    
    # Evaluate the model
    train_score = model.score(X_train_scaled, y_train)
    test_score = model.score(X_test_scaled, y_test)
    
    print(f"Training accuracy: {train_score:.2f}")
    print(f"Testing accuracy: {test_score:.2f}")
    
    # Save the model and scaler
    os.makedirs(os.path.dirname(__file__), exist_ok=True)
    joblib.dump(model, os.path.join(os.path.dirname(__file__), 'stress_classifier.joblib'))
    joblib.dump(scaler, os.path.join(os.path.dirname(__file__), 'scaler.joblib'))
    
    return model, scaler

if __name__ == "__main__":
    data_path = "Datasets/StressLevelDataset.csv"
    train_stress_model(data_path) 