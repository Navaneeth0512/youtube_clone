import 'package:flutter/material.dart';
import 'package:youtube_clone/features/auth/auth_services.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _authService = AuthService();

  ForgotPasswordScreen({Key? key}) : super(key: key);

  void _resetPassword(BuildContext context) async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid email address.")),
      );
      return;
    }
    try {
      await _authService.resetPassword(email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _resetPassword(context),
              child: const Text("Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}
