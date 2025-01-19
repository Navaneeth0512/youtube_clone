import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/bloc/phonenumber_event.dart';
import 'package:youtube_clone/features/auth/PhoneNumber/bloc/phonenumber_state.dart';


class PhoneInputBloc extends Bloc<PhoneInputEvent, PhoneInputState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PhoneInputBloc() : super(PhoneInputInitial()) {
    on<RequestOTP>((event, emit) async {
      emit(PhoneInputLoading());
      try {
        await _auth.verifyPhoneNumber(
          phoneNumber: event.phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _auth.signInWithCredential(credential);
            emit(PhoneInputSuccess());
          },
          verificationFailed: (FirebaseAuthException e) {
            emit(PhoneInputVerificationFailed(e.message ?? "Verification failed."));
          },
          codeSent: (String verificationId, int? resendToken) {
            emit(PhoneInputCodeSent(
              verificationId: verificationId,
              phoneNumber: event.phoneNumber,
            ));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Optional: Handle timeout if needed.
          },
        );
      } catch (e) {
        emit(PhoneInputVerificationFailed("Failed to send OTP: $e"));
      }
    });
  }
}
