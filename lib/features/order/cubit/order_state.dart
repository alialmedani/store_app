part of 'order_cubit.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderItemsUpdated extends OrderState {}

final class OrderValidationError extends OrderState {}
