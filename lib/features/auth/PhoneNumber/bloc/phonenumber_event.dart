
import 'package:equatable/equatable.dart';

abstract class PhoneInputEvent extends Equatable {
  const PhoneInputEvent();

  @override
  List<Object> get props => [];
}

class RequestOTP extends PhoneInputEvent {
  final String phoneNumber;

  const RequestOTP(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}
