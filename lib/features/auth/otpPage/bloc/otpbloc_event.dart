
import 'package:equatable/equatable.dart';

abstract class OTPVerificationEvent extends Equatable {
  const OTPVerificationEvent();

  @override
  List<Object> get props => [];
}

class VerifyOTP extends OTPVerificationEvent {
  final String verificationId;
  final String otp;

  const VerifyOTP({required this.verificationId, required this.otp});

  @override
  List<Object> get props => [verificationId, otp];
}
