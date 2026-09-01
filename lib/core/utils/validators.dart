class Validators {
  static bool isValidString(String? text) {
    return text != null && text.trim().isNotEmpty;
  }
}
