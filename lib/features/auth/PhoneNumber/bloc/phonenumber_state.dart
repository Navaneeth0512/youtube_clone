
import 'package:equatable/equatable.dart';

abstract class PhoneInputState extends Equatable {
  const PhoneInputState();

  @override
  List<Object> get props => [];
}

class PhoneInputInitial extends PhoneInputState {}

class PhoneInputLoading extends PhoneInputState {}

class PhoneInputCodeSent extends PhoneInputState {
  final String verificationId;
  final String phoneNumber;

  const PhoneInputCodeSent({required this.verificationId, required this.phoneNumber});

  @override
  List<Object> get props => [verificationId, phoneNumber];
}

class PhoneInputSuccess extends PhoneInputState {}

class PhoneInputVerificationFailed extends PhoneInputState {
  final String errorMessage;

  const PhoneInputVerificationFailed(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
