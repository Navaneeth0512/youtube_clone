import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:youtube_clone/features/auth/ForgotPassword/bloc/forgottpass_event.dart';
import 'package:youtube_clone/features/auth/ForgotPassword/bloc/forgottpass_state.dart';
import 'package:youtube_clone/features/auth/auth_services.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthService _authService;

  ForgotPasswordBloc(this._authService) : super(ForgotPasswordInitial()) {
    on<ForgotPasswordRequested>((event, emit) async {
      emit(ForgotPasswordLoading());
      try {
        await _authService.resetPassword(event.email);
        emit(ForgotPasswordSuccess());
      } catch (e) {
        emit(ForgotPasswordFailure(e.toString()));
      }
    });
  }
}
