part of 'create_product_cubit.dart';

abstract class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class CreateProductChanged extends CreateProductState {}

class CreateProductLoading extends CreateProductState {}

class CreateProductSuccess extends CreateProductState {
  final dynamic data;

  CreateProductSuccess(this.data);
}

class CreateProductError extends CreateProductState {
  final String message;

  CreateProductError(this.message);
}