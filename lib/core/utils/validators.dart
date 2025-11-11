/// Form validation utilities for the app

class Validators {
  /// Email validation regex pattern
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  /// Password validation regex (at least 8 chars, 1 uppercase, 1 lowercase, 1 number)
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$',
  );

  /// Phone validation regex (international format)
  static final RegExp _phoneRegex = RegExp(
    r'^\+?[1-9]\d{1,14}$',
  );

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El email es requerido';
    }

    if (!_emailRegex.hasMatch(value.trim())) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  /// Validate password
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }

    if (!_passwordRegex.hasMatch(value)) {
      return 'Debe contener mayúscula, minúscula y número';
    }

    return null;
  }

  /// Validate password confirmation
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != password) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Validate name (minimum 2 characters, only letters and spaces)
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre es requerido';
    }

    if (value.trim().length < 2) {
      return 'El nombre debe tener al menos 2 caracteres';
    }

    if (!RegExp(r"^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$").hasMatch(value.trim())) {
      return 'El nombre solo puede contener letras';
    }

    return null;
  }

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    if (!_phoneRegex.hasMatch(value.trim())) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, {String fieldName = 'Este campo'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Use validateRequired for empty checks
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $minLength caracteres';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'Este campo'} no puede exceder $maxLength caracteres';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    try {
      final uri = Uri.parse(value);
      if (!uri.hasScheme || !uri.hasAuthority) {
        return 'Ingresa una URL válida';
      }
    } catch (e) {
      return 'Ingresa una URL válida';
    }

    return null;
  }

  /// Validate numeric value
  static String? validateNumeric(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número válido';
    }

    return null;
  }

  /// Validate integer value
  static String? validateInteger(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (int.tryParse(value) == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número entero';
    }

    return null;
  }

  /// Validate range
  static String? validateRange(
    String? value,
    num min,
    num max, {
    String? fieldName,
  }) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final number = num.tryParse(value);
    if (number == null) {
      return '${fieldName ?? 'Este campo'} debe ser un número válido';
    }

    if (number < min || number > max) {
      return '${fieldName ?? 'Este campo'} debe estar entre $min y $max';
    }

    return null;
  }

  /// Validate age (must be 18 or older)
  static String? validateAge(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La edad es requerida';
    }

    final age = int.tryParse(value);
    if (age == null) {
      return 'Ingresa una edad válida';
    }

    if (age < 18) {
      return 'Debes ser mayor de 18 años';
    }

    if (age > 120) {
      return 'Ingresa una edad válida';
    }

    return null;
  }

  /// Validate credit card number (basic Luhn algorithm)
  static String? validateCreditCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El número de tarjeta es requerido';
    }

    // Remove spaces and dashes
    final cardNumber = value.replaceAll(RegExp(r'[\s-]'), '');

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Número de tarjeta inválido';
    }

    if (!RegExp(r'^\d+$').hasMatch(cardNumber)) {
      return 'El número de tarjeta solo puede contener dígitos';
    }

    // Luhn algorithm
    int sum = 0;
    bool alternate = false;

    for (int i = cardNumber.length - 1; i >= 0; i--) {
      int digit = int.parse(cardNumber[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit -= 9;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    if (sum % 10 != 0) {
      return 'Número de tarjeta inválido';
    }

    return null;
  }

  /// Validate CVV code
  static String? validateCvv(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El CVV es requerido';
    }

    if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
      return 'CVV inválido (3 o 4 dígitos)';
    }

    return null;
  }

  /// Validate expiry date (MM/YY format)
  static String? validateExpiryDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La fecha de vencimiento es requerida';
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'Formato inválido (MM/AA)';
    }

    final parts = value.split('/');
    final month = int.tryParse(parts[0]);
    final year = int.tryParse(parts[1]);

    if (month == null || year == null) {
      return 'Fecha inválida';
    }

    if (month < 1 || month > 12) {
      return 'Mes inválido';
    }

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;

    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      return 'Tarjeta vencida';
    }

    return null;
  }

  /// Validate playlist title
  static String? validatePlaylistTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El título es requerido';
    }

    if (value.trim().length < 3) {
      return 'El título debe tener al menos 3 caracteres';
    }

    if (value.length > 100) {
      return 'El título no puede exceder 100 caracteres';
    }

    return null;
  }

  /// Validate description
  static String? validateDescription(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional field
    }

    if (value.length > maxLength) {
      return 'La descripción no puede exceder $maxLength caracteres';
    }

    return null;
  }
}
