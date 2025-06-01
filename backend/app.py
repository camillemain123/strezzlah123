from flask import Flask, request, jsonify
from flask_cors import CORS
import mysql.connector
import hashlib

app = Flask(__name__)
CORS(app)

# Database configuration
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="haidar123",
    database="strezzlah_db"
)
cursor = db.cursor(dictionary=True)

def hash_password(password):
    return hashlib.sha256(password.encode()).hexdigest()

@app.route("/register", methods=["POST"])
def register():
    data = request.json
    email = data['email']
    password = hash_password(data['password'])

    try:
        cursor.execute("INSERT INTO users (email, password) VALUES (%s, %s)", (email, password))
        db.commit()
        return jsonify({"status": "success"}), 201
    except mysql.connector.errors.IntegrityError:
        return jsonify({"status": "error", "message": "Email already exists"}), 400

@app.route("/login", methods=["POST"])
def login():
    data = request.json
    email = data['email']
    password = hash_password(data['password'])

    cursor.execute("SELECT * FROM users WHERE email = %s AND password = %s", (email, password))
    user = cursor.fetchone()

    if user:
        return jsonify({"status": "success", "user": user}), 200
    else:
        return jsonify({"status": "error", "message": "Invalid credentials"}), 401

if __name__ == "__main__":
    app.run(debug=True)
