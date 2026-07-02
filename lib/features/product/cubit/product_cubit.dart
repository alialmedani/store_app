import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/results/result.dart';
import '../data/model/product_model.dart';
import '../data/repository/product_repository.dart';
import '../data/usecase/create_product_usecase.dart';
import '../data/usecase/get_product_list_usecase.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(ProductInitial());

  // Params
  CreateProductParams createProductParams = CreateProductParams(
    name: '',
    description: '',
    price: 0.0,
    isActive: true,
    targetAudience: 0,
    categoryId: '',
  );

  // UI State Variables
  int? selectedTargetAudience = 0;
  String? selectedCategoryId;

  // Validation Error Variables
  String? nameError;
  String? priceError;
  String? categoryError;

  // UI State Methods (with emit)
  void selectTargetAudience(int value) {
    selectedTargetAudience = value;
    createProductParams.targetAudience = value;
    emit(UpdateProductParams());
  }

  void selectCategory(String id) {
    selectedCategoryId = id;
    createProductParams.categoryId = id;
    clearCategoryError();
    emit(UpdateProductParams());
  }

  void toggleIsActive(bool value) {
    createProductParams.isActive = value;
    emit(UpdateProductParams());
  }

  void setNameError(String error) {
    nameError = error;
    emit(ProductValidationError());
  }

  void clearNameError() {
    nameError = null;
    emit(ProductValidationError());
  }

  void setPriceError(String error) {
    priceError = error;
    emit(ProductValidationError());
  }

  void clearPriceError() {
    priceError = null;
    emit(ProductValidationError());
  }

  void setCategoryError(String error) {
    categoryError = error;
    emit(ProductValidationError());
  }

  void clearCategoryError() {
    categoryError = null;
    emit(ProductValidationError());
  }

  void clearAllErrors() {
    nameError = null;
    priceError = null;
    categoryError = null;
    emit(ProductValidationError());
  }

  // API Methods (NO emit - boilerplate handles state)
  Future<Result<ProductModel>> createProduct() async {
    return await CreateProductUsecase(
      ProductRepository(),
    ).call(params: createProductParams);
  }

  Future<Result<List<ProductModel>>> fetchProductList(data) async {
    return await GetProductListUsecase(
      ProductRepository(),
    ).call(params: GetProductListParams(request: data));
  }
}
