import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:youtube_clone/features/splash/splashscreen.dart';
import 'package:youtube_clone/features/theme/theme_provider.dart';
import 'package:youtube_clone/features/auth/login_screen.dart';
import 'package:youtube_clone/features/auth/forgotpassword.dart';
import 'package:youtube_clone/features/auth/otpverification.dart';
import 'package:youtube_clone/features/auth/phonenumber.dart';
import 'package:youtube_clone/features/auth/signup.dart';
import 'package:youtube_clone/features/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(ThemeData.light()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.themeData,
      initialRoute: '/splashscreen',
      routes: {
        '/splashscreen': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/SignupScreen': (context) => const SignupScreen(),
        '/phonenumber': (context) => const PhoneInputScreen(),
        '/otp_verification': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          if (args == null || !args.containsKey('verificationId')) {
            throw Exception("Verification ID is required for OTP Verification");
          }
          return OTPVerificationScreen(verificationId: args['verificationId']);
        },
        '/home': (context) => const HomeScreen(),
        '/forgot_password': (context) => ForgotPasswordScreen(),
      },
    );
  }
}