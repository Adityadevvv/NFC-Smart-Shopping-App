import 'package:flutter/material.dart';

class PasswordChecklist extends StatelessWidget {
  final String password;

  PasswordChecklist({required this.password});

  bool hasUppercase(String s) => s.contains(RegExp(r'[A-Z]'));
  bool hasLowercase(String s) => s.contains(RegExp(r'[a-z]'));
  bool hasNumber(String s) => s.contains(RegExp(r'[0-9]'));
  bool hasSpecial(String s) => s.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _check("8+ characters", password.length >= 8),
        _check("Uppercase letter", hasUppercase(password)),
        _check("Lowercase letter", hasLowercase(password)),
        _check("Number", hasNumber(password)),
        _check("Special character", hasSpecial(password)),
      ],
    );
  }

  Widget _check(String text, bool valid) {
    return Row(
      children: [
        Icon(valid ? Icons.check : Icons.close,
            color: valid ? Colors.green : Colors.red, size: 18),
        SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}