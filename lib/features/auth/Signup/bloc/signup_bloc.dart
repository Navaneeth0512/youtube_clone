import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_clone/features/auth/auth_services.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  final AuthService _authService;

  SignupBloc(this._authService) : super(SignupInitial()) {
    on<SignupRequested>((event, emit) async {
      emit(SignupLoading());
      try {
        // Sign up with email and password
        final user = await _authService.signUpWithEmail(event.email, event.password);

        if (user != null) {
          emit(SignupSuccess());
        } else {
          emit(SignupFailure("Signup failed. Please try again."));
        }
      } catch (e) {
        emit(SignupFailure(e.toString()));
      }
    });
  }
}
