part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoginButtonStateChanged extends AuthState {
  final bool isEnabled;
  AuthLoginButtonStateChanged(this.isEnabled);
}

class AuthVerificationButtonStateChanged extends AuthState {
  final bool isEnabled;
  AuthVerificationButtonStateChanged(this.isEnabled);
}

final class AuthTimerTick extends AuthState {
  final int secondsLeft;
  final bool canResend;

  AuthTimerTick(this.secondsLeft, this.canResend);
}

final class UpdateObscureState extends AuthState {}

final class UpdateRegisterDriverParams extends AuthState {}

final class UpdateRegisterMerchantParams extends AuthState {}

// Register Driver States
final class RegisterDriverLoading extends AuthState {}

final class RegisterDriverSuccess extends AuthState {
  final String message;
  RegisterDriverSuccess(this.message);
}

final class RegisterDriverError extends AuthState {
  final String message;
  RegisterDriverError(this.message);
}

// Register Merchant States
final class RegisterMerchantLoading extends AuthState {}

final class RegisterMerchantSuccess extends AuthState {
  final String message;
  RegisterMerchantSuccess(this.message);
}

final class RegisterMerchantError extends AuthState {
  final String message;
  RegisterMerchantError(this.message);
}
