class MyValidators {
  static String? uploadProdTexts({String? value, String? toBeReturnedString}) {
    if (value!.isEmpty) {
      return toBeReturnedString;
    }
    return null;
  }

  static String? displayNamevalidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
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

  static String? addressvalidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Address cannot be empty';
    }
    if (value.length < 10 || value.length > 100) {
      return 'Display name must be between 10 and 100 characters';
    }

    return null; // Return null if display name is valid
  }
}
