import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/bloc/phonenumber_bloc.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/bloc/phonenumber_event.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/bloc/phonenumber_state.dart';

class PhoneInputScreen extends StatelessWidget {
  const PhoneInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController _phoneController = TextEditingController();

    return BlocProvider(
      create: (context) => PhoneInputBloc(),
      child: BlocListener<PhoneInputBloc, PhoneInputState>(
        listener: (context, state) {
          if (state is PhoneInputVerificationFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          } else if (state is PhoneInputCodeSent) {
            Navigator.pushNamed(
              context,
              '/otp_verification',
              arguments: {
                'verificationId': state.verificationId,
                'phoneNumber': state.phoneNumber,
              },
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
                BlocBuilder<PhoneInputBloc, PhoneInputState>(
                  builder: (context, state) {
                    if (state is PhoneInputLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ElevatedButton(
                      onPressed: () {
                        final phoneNumber = _phoneController.text.trim();
                        if (!phoneNumber.startsWith('+')) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please include the country code (e.g., +1).")),
                          );
                          return;
                        }
                        context.read<PhoneInputBloc>().add(RequestOTP(phoneNumber));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text(
                        "Send OTP",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
                  },
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
        ),
      ),
    );
  }
}
