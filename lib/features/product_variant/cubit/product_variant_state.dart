part of 'product_variant_cubit.dart';

@immutable
sealed class ProductVariantState {}

final class ProductVariantInitial extends ProductVariantState {}

final class UpdateProductVariantParams extends ProductVariantState {}

final class ProductVariantValidationError extends ProductVariantState {}
