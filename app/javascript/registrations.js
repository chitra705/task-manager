  document.addEventListener('DOMContentLoaded', function() {
    const passwordInput = document.getElementById('password');
    const confirmationInput = document.getElementById('password_confirmation');
    const requirementsList = document.createElement('ul');

    const requirements = [
      { regex: /[A-Z]/, message: "At least one uppercase letter" },
      { regex: /[a-z]/, message: "At least one lowercase letter" },
      { regex: /\d/, message: "At least one digit" },
      { regex: /[^\w\s]/, message: "At least one special character" }
    ];

    requirements.forEach(req => {
      const li = document.createElement('li');
      li.textContent = req.message;
      li.className = 'requirement';
      li.style.color = 'red'; // Red color for unmet requirements
      requirementsList.appendChild(li);
      requirementsList.style.display = 'none'; // Hide initially
    });

    passwordInput.insertAdjacentElement('afterend', requirementsList);

    passwordInput.addEventListener('input', function() {
      let allRequirementsMet = true;

      requirements.forEach((req, index) => {
        const li = requirementsList.children[index];
        if (req.regex.test(passwordInput.value)) {
          li.style.color = 'green'; // Change to green when met
        } else {
          li.style.color = 'red'; // Stay red when not met
          allRequirementsMet = false;
        }
      });

      requirementsList.style.display = allRequirementsMet ? 'none' : 'block'; // Show/hide the list
    });

    confirmationInput.addEventListener('input', function() {
      if (passwordInput.value !== confirmationInput.value) {
        confirmationInput.setCustomValidity("Passwords do not match.");
      } else {
        confirmationInput.setCustomValidity(""); // Clear error
      }
    });
  });
