import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_clone/features/home/bloc/homescreenbloc_event.dart';
import 'package:youtube_clone/features/profile/bloc/profile_bloc.dart';
import 'package:youtube_clone/features/theme/theme_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:youtube_clone/features/video/videocard/bloc/videocard_bloc.dart';
import 'package:youtube_clone/features/home/bloc/homescreenbloc_bloc.dart';
import 'package:youtube_clone/features/auth/LoginScreen/login_screen.dart';
import 'package:youtube_clone/features/auth/ForgotPassword/forgotpassword.dart';
import 'package:youtube_clone/features/auth/otpPage/otpverification.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/phonenumber.dart';
import 'package:youtube_clone/features/auth/Signup/signup.dart';
import 'package:youtube_clone/features/home/home_screen.dart';
import 'package:youtube_clone/features/splash/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(ThemeData.light()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileBloc(), // Initialize ProfileBloc
        ),
        BlocProvider(
          create: (context) => VideoBloc(), // Initialize VideoBloc
        ),
        BlocProvider(
          create: (context) => HomeBloc()..add(FetchVideosEvent()), // Initialize HomeBloc
        ),
      ],
      child: MaterialApp(
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
      ),
    );
  }
}
