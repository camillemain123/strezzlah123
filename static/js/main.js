// Form validation
document.addEventListener('DOMContentLoaded', function() {
    const dassForm = document.getElementById('dassForm');
    if (dassForm) {
        dassForm.addEventListener('submit', function(e) {
            const questions = document.querySelectorAll('.question');
            let allAnswered = true;

            questions.forEach(question => {
                const radioButtons = question.querySelectorAll('input[type="radio"]');
                const answered = Array.from(radioButtons).some(radio => radio.checked);
                
                if (!answered) {
                    allAnswered = false;
                    question.classList.add('border-danger');
                } else {
                    question.classList.remove('border-danger');
                }
            });

            if (!allAnswered) {
                e.preventDefault();
                alert('Please answer all questions before submitting.');
            }
        });
    }

    // Password confirmation validation
    const signupForm = document.querySelector('form[action*="signup"]');
    if (signupForm) {
        signupForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password');
            const confirmPassword = document.getElementById('confirm_password');
            
            if (password.value !== confirmPassword.value) {
                e.preventDefault();
                alert('Passwords do not match!');
            }
        });
    }

    // Auto-hide flash messages
    const flashMessages = document.querySelectorAll('.alert');
    flashMessages.forEach(message => {
        setTimeout(() => {
            message.style.opacity = '0';
            setTimeout(() => message.remove(), 300);
        }, 5000);
    });
}); 