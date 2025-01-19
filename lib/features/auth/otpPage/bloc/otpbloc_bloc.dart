import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_clone/features/auth/otpPage/bloc/otpbloc_event.dart';
import 'package:youtube_clone/features/auth/otpPage/bloc/otpbloc_state.dart';


class OTPVerificationBloc extends Bloc<OTPVerificationEvent, OTPVerificationState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  OTPVerificationBloc() : super(OTPVerificationInitial());

  @override
  Stream<OTPVerificationState> mapEventToState(OTPVerificationEvent event) async* {
    if (event is VerifyOTP) {
      yield OTPVerificationLoading();
      try {
        final credential = PhoneAuthProvider.credential(
          verificationId: event.verificationId,
          smsCode: event.otp,
        );
        await _auth.signInWithCredential(credential);
        yield OTPVerificationSuccess();
      } on FirebaseAuthException catch (e) {
        yield OTPVerificationFailure(errorMessage: e.message ?? "Failed to verify OTP. Please try again.");
      }
    }
  }
}
