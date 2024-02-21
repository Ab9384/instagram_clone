class RegExFunction {
  // Function to check if the email is valid
  static bool isEmailValid(String email) {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(email);
  }

  // Function to check if the password is valid (8 characters, 1 uppercase, 1 lowercase, 1 number, 1 special character)
  static bool isPasswordValid(String password) {
    String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  // Function to check if the username is valid (only letters and numbers, 3-20 characters)
  static bool isUsernameValid(String username) {
    String pattern = r'^[a-zA-Z0-9]{3,20}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(username);
  }

  // Function to check if the name is valid (only letters, 3-20 characters)
  static bool isNameValid(String name) {
    String pattern = r'^[a-zA-Z]{3,20}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(name);
  }

  // Function to check if the phone number is valid (10 digits)
  static bool isPhoneNumberValid(String phoneNumber) {
    String pattern = r'^[0-9]{10}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(phoneNumber);
  }

  // Function to check if the bio is valid (1-150 characters)
  static bool isBioValid(String bio) {
    String pattern = r'^.{1,150}$';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(bio);
  }
}
