class MyValidators {
  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
        .hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? addressvalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
    if (value.length < 10 || value.length > 100) {
      return 'Display name must be between 10 and 100 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? phonevalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile cannot be empty';
    }
    if (value.length < 11 || value.length > 11) {
      return 'Mobile Number must be 11 characters';
    }

    return null; // Return null if display name is valid
  }

  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }
}
