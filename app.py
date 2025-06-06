from flask import Flask, render_template, request, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, login_required, logout_user, current_user
from werkzeug.security import generate_password_hash, check_password_hash
import os
from dotenv import load_dotenv
from datetime import datetime
from utils.dass_utils import calculate_scores, get_severity_level, StressClassifier

# Load environment variables
load_dotenv()

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY', 'default-secret-key')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv('DATABASE_URL', 'sqlite:///stress_assessment.db')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# Initialize stress classifier
stress_classifier = StressClassifier()

# Database Models
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    password_hash = db.Column(db.String(128))
    assessments = db.relationship('Assessment', backref='user', lazy=True)

class Assessment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)
    depression_score = db.Column(db.Integer, nullable=False)
    anxiety_score = db.Column(db.Integer, nullable=False)
    stress_score = db.Column(db.Integer, nullable=False)
    feedback = db.Column(db.Text)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Make severity level function available in templates
app.jinja_env.globals.update(get_severity_level=get_severity_level)

# Routes
@app.route('/')
def home():
    return render_template('home.html')

@app.route('/about')
def about():
    return render_template('about.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        user = User.query.filter_by(username=username).first()
        
        if user and check_password_hash(user.password_hash, password):
            login_user(user)
            return redirect(url_for('dashboard'))
        flash('Invalid username or password')
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')
        confirm_password = request.form.get('confirm_password')
        
        if password != confirm_password:
            flash('Passwords do not match')
            return redirect(url_for('signup'))
        
        if User.query.filter_by(username=username).first():
            flash('Username already exists')
            return redirect(url_for('signup'))
            
        if User.query.filter_by(email=email).first():
            flash('Email already registered')
            return redirect(url_for('signup'))
            
        user = User(
            username=username,
            email=email,
            password_hash=generate_password_hash(password)
        )
        db.session.add(user)
        db.session.commit()
        
        login_user(user)
        return redirect(url_for('dashboard'))
    return render_template('signup.html')

@app.route('/dashboard')
@login_required
def dashboard():
    assessments = Assessment.query.filter_by(user_id=current_user.id).order_by(Assessment.date.desc()).all()
    return render_template('dashboard.html', assessments=assessments)

@app.route('/assessment/new')
@login_required
def new_assessment():
    return render_template('assessment.html')

@app.route('/assessment/submit', methods=['POST'])
@login_required
def submit_assessment():
    # Get responses from form
    responses = []
    for i in range(1, 22):  # DASS-21 has 21 questions
        response = request.form.get(f'q{i}')
        if response is None:
            flash('Please answer all questions')
            return redirect(url_for('new_assessment'))
        responses.append(int(response))
    
    # Calculate scores
    depression_score, anxiety_score, stress_score = calculate_scores(responses)
    
    # Get AI feedback
    feedback = stress_classifier.get_feedback(depression_score, anxiety_score, stress_score)
    
    # Save assessment
    assessment = Assessment(
        user_id=current_user.id,
        date=datetime.now(),
        depression_score=depression_score,
        anxiety_score=anxiety_score,
        stress_score=stress_score,
        feedback=feedback
    )
    db.session.add(assessment)
    db.session.commit()
    
    flash('Assessment completed successfully!')
    return redirect(url_for('dashboard'))

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(debug=True) 