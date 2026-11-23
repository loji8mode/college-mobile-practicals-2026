String? requiredValue(String? value) =>
    value == null || value.trim().isEmpty ? 'Обов’язкове поле' : null;

String? emailValidator(String? value) {
  final required = requiredValue(value);
  if (required != null) return required;
  final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  return valid.hasMatch(value!.trim()) ? null : 'Некоректний email';
}

String? passwordValidator(String? value) {
  final required = requiredValue(value);
  if (required != null) return required;
  return value!.runes.length >= 7 ? null : 'Мінімум 7 символів';
}

String? confirmationValidator(String? value, String password) {
  final required = requiredValue(value);
  if (required != null) return required;
  return value == password ? null : 'Паролі не збігаються';
}
