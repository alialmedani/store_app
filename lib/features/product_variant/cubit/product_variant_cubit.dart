import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constant/enum/enum.dart';
import '../../../core/results/result.dart';
import '../../product/data/model/product_model.dart';
import '../data/model/product_variant_model.dart';
import '../data/repository/product_variant_repository.dart';
import '../data/usecase/bulk_create_product_variant_usecase.dart';
import '../data/usecase/create_product_variant_usecase.dart';
import '../data/usecase/generate_product_variant_usecase.dart';
import '../data/usecase/get_product_variant_details_usecase.dart';
import '../data/usecase/get_product_variant_list_usecase.dart';

part 'product_variant_state.dart';

class ProductVariantCubit extends Cubit<ProductVariantState> {
  ProductVariantCubit() : super(ProductVariantInitial());

  // Params
  CreateProductVariantParams createProductVariantParams =
      CreateProductVariantParams(
        productId: '',
        color: null,
        size: null,
        stockQuantity: 0,
        isActive: true,
      );

  // UI State Variables
  ProductModel? selectedProduct;

  // Validation Error Variables
  String? productError;
  String? colorError;
  String? sizeError;
  String? stockQuantityError;

  // UI State Methods (with emit)
  void selectProduct(ProductModel product) {
    selectedProduct = product;
    createProductVariantParams.productId = product.id ?? '';
    clearProductError();
    emit(UpdateProductVariantParams());
  }

  // Check if color is required based on product category sizeType
  bool isColorRequired() {
    final sizeType = selectedProduct?.category?.sizeType;
    // Color not required only for 'none' type (accessories)
    return sizeType != SizeType.none;
  }

  // Check if size is required based on product category sizeType
  bool isSizeRequired() {
    final sizeType = selectedProduct?.category?.sizeType;
    // Size not required for 'none' and 'oneSize' types
    return sizeType != SizeType.none && sizeType != SizeType.oneSize;
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

  Future<Result<List<ProductVariantModel>>> bulkCreateProductVariant(
    BulkCreateProductVariantParams params,
  ) async {
    return await BulkCreateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: params);
  }

  Future<Result<List<ProductVariantModel>>> generateProductVariant(
    GenerateProductVariantParams params,
  ) async {
    return await GenerateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: params);
  }

  Future<Result<List<ProductVariantModel>>> fetchProductVariantList(
    data, {
    String? productId,
  }) async {
    return await GetProductVariantListUsecase(
      ProductVariantRepository(),
    ).call(params: GetProductVariantListParams(request: data, productId: productId));
  }

  Future<Result<ProductVariantModel>> getProductVariantDetails(
    String productVariantId,
  ) async {
    return await GetProductVariantDetailsUsecase(
      ProductVariantRepository(),
    ).call(
      params: GetProductVariantDetailsParams(
        productVariantId: productVariantId,
      ),
    );
  }
}
