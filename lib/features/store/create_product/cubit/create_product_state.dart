part of 'create_product_cubit.dart';

abstract class CreateProductState {}

class CreateProductInitial extends CreateProductState {}

class CreateProductChanged extends CreateProductState {}

class CreateProductError extends CreateProductState {
  final String message;

  CreateProductError(this.message);
}

class CreateProductSuccess extends CreateProductState {
  final dynamic data;

  CreateProductSuccess(this.data);
}