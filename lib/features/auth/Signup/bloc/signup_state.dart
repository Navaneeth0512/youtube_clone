part of 'signup_bloc.dart';

abstract class SignupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {}

class SignupFailure extends SignupState {
  final String errorMessage;

  SignupFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class OtpSentSuccess extends SignupState {}
