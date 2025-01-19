
import 'package:equatable/equatable.dart';

abstract class OTPVerificationState extends Equatable {
  const OTPVerificationState();

  @override
  List<Object> get props => [];
}

class OTPVerificationInitial extends OTPVerificationState {}

class OTPVerificationLoading extends OTPVerificationState {}

class OTPVerificationSuccess extends OTPVerificationState {}

class OTPVerificationFailure extends OTPVerificationState {
  final String errorMessage;

  const OTPVerificationFailure({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
