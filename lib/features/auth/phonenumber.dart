import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({Key? key}) : super(key: key);

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _sendOTP() async {
    String phoneNumber = _phoneController.text.trim();

    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+$phoneNumber'; // Add '+' if missing
    }

    final phoneRegex = RegExp(r'^\+\d{7,15}$');
    if (!phoneRegex.hasMatch(phoneNumber)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number with country code.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          print("Auto-verification completed");
          await _auth.signInWithCredential(credential);
          Navigator.pushReplacementNamed(context, '/home');
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Verification failed: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Verification failed.")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent to $phoneNumber with verification ID: $verificationId");
          Navigator.pushNamed(
            context,
            '/otp_verification',
            arguments: {
              'verificationId': verificationId,
              'phoneNumber': phoneNumber,
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print("Code auto-retrieval timeout: $verificationId");
        },
      );
    } catch (e) {
      print("Error sending OTP: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to send OTP: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.sms_outlined,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "Verify Your Phone Number",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Enter your phone number to receive a verification code via SMS.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.phone),
                prefixText: "+",
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Send OTP",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(fontSize: 14, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}