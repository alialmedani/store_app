part of 'product_cubit.dart';

@immutable
sealed class ProductState {}

final class ProductInitial extends ProductState {}

final class ProductParamsUpdated extends ProductState {}

final class ProductValidationError extends ProductState {}
