# DASS-21 Stress Classification System

A comprehensive web application for stress assessment and management using the DASS-21 questionnaire.

## Features

- User authentication (login/signup)
- DASS-21 questionnaire implementation
- Stress level classification using Machine Learning
- AI-powered feedback and recommendations
- History of past assessments
- Educational content about stress categories

## Setup Instructions

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up environment variables:
Create a `.env` file with the following variables:
```
SECRET_KEY=your_secret_key
DATABASE_URL=sqlite:///stress_assessment.db
```

4. Initialize the database:
```bash
python init_db.py
```

5. Run the application:
```bash
python app.py
```

## Project Structure

- `app.py`: Main application file
- `models/`: Database models
- `templates/`: HTML templates
- `static/`: CSS, JavaScript, and other static files
- `ml_model/`: Machine learning model for stress classification
- `utils/`: Utility functions

## DASS-21 Information

The DASS-21 (Depression, Anxiety, and Stress Scale) is a 21-item self-report questionnaire designed to measure the three related negative emotional states of depression, anxiety, and tension/stress.

## License

MIT License 