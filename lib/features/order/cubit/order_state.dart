part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class UpdateOrderParams extends OrderState {}

final class OrderValidationError extends OrderState {}
