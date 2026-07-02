import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/results/result.dart';
import '../data/model/product_variant_model.dart';
import '../data/repository/product_variant_repository.dart';
import '../data/usecase/create_product_variant_usecase.dart';
import '../data/usecase/get_product_variant_list_usecase.dart';

part 'product_variant_state.dart';

class ProductVariantCubit extends Cubit<ProductVariantState> {
  ProductVariantCubit() : super(ProductVariantInitial());

  // Params
  CreateProductVariantParams createProductVariantParams =
      CreateProductVariantParams(
    productId: '',
    color: '',
    size: '',
    stockQuantity: 0,
    isActive: true,
  );

  // UI State Variables
  String? selectedProductId;

  // Validation Error Variables
  String? productError;
  String? colorError;
  String? sizeError;
  String? stockQuantityError;

  // UI State Methods (with emit)
  void selectProduct(String id) {
    selectedProductId = id;
    createProductVariantParams.productId = id;
    clearProductError();
    emit(UpdateProductVariantParams());
  }

  void toggleIsActive(bool value) {
    createProductVariantParams.isActive = value;
    emit(UpdateProductVariantParams());
  }

  void setProductError(String error) {
    productError = error;
    emit(ProductVariantValidationError());
  }

  void clearProductError() {
    productError = null;
    emit(ProductVariantValidationError());
  }

  void setColorError(String error) {
    colorError = error;
    emit(ProductVariantValidationError());
  }

  void clearColorError() {
    colorError = null;
    emit(ProductVariantValidationError());
  }

  void setSizeError(String error) {
    sizeError = error;
    emit(ProductVariantValidationError());
  }

  void clearSizeError() {
    sizeError = null;
    emit(ProductVariantValidationError());
  }

  void setStockQuantityError(String error) {
    stockQuantityError = error;
    emit(ProductVariantValidationError());
  }

  void clearStockQuantityError() {
    stockQuantityError = null;
    emit(ProductVariantValidationError());
  }

  void clearAllErrors() {
    productError = null;
    colorError = null;
    sizeError = null;
    stockQuantityError = null;
    emit(ProductVariantValidationError());
  }

  // API Methods (NO emit - boilerplate handles state)
  Future<Result<ProductVariantModel>> createProductVariant() async {
    return await CreateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: createProductVariantParams);
  }

  Future<Result<List<ProductVariantModel>>> fetchProductVariantList(
      data) async {
    return await GetProductVariantListUsecase(
      ProductVariantRepository(),
    ).call(params: GetProductVariantListParams(request: data));
  }
}
