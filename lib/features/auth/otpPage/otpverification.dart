import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/features/auth/otpPage/bloc/otpbloc_bloc.dart';
import 'package:youtube_clone/features/auth/otpPage/bloc/otpbloc_event.dart';
import 'package:youtube_clone/features/auth/otpPage/bloc/otpbloc_state.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;

  const OTPVerificationScreen({Key? key, required this.verificationId}) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  void _verifyOTP() {
    final otp = _otpController.text.trim();

    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP.")),
      );
      return;
    }

    // Trigger the OTP verification event
    context.read<OTPVerificationBloc>().add(
      VerifyOTP(
        verificationId: widget.verificationId,
        otp: otp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPVerificationBloc, OTPVerificationState>(
      listener: (context, state) {
        if (state is OTPVerificationSuccess) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is OTPVerificationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.lock_open_outlined,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              const Text(
                "Verify OTP",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter the 6-digit OTP sent to your phone number to verify your account .",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, letterSpacing: 2.0),
                decoration: InputDecoration(
                  labelText: "Enter OTP",
                  counterText: "",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  prefixIcon: const Icon(Icons.sms),
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<OTPVerificationBloc, OTPVerificationState>(
                builder: (context, state) {
                  if (state is OTPVerificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: _verifyOTP,
                      child: const Text(
                        "Verify OTP",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive an OTP?",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Navigate back to the Phone Input Screen
                    },
                    child: const Text(
                      "Resend",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
