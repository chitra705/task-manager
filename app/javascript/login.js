  document.addEventListener("DOMContentLoaded", function() {
  const togglePasswordButton = document.getElementById('toggle_password');
  const passwordField = document.getElementById('password_field');
  const eyeIcon = document.getElementById('eye_icon');

  togglePasswordButton.addEventListener('click', function() {
    // Toggle the type attribute
    const type = passwordField.getAttribute('type') === 'password' ? 'text' : 'password';
    passwordField.setAttribute('type', type);

    // Toggle the eye icon
    if (type === 'password') {
      eyeIcon.classList.remove('fa-eye-slash');
      eyeIcon.classList.add('fa-eye');
    } else {
      eyeIcon.classList.remove('fa-eye');
      eyeIcon.classList.add('fa-eye-slash');
    }
  });
});