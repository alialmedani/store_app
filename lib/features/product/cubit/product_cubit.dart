import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../core/repository/file_upload_repository.dart';
import '../../../core/results/result.dart';
import '../data/model/product_model.dart';
import '../data/repository/product_repository.dart';
import '../data/usecase/create_product_usecase.dart';
import '../data/usecase/get_product_details_usecase.dart';
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
    imageUrl: '',
  );

  // UI State Variables
  int? selectedTargetAudience = 0;
  String? selectedCategoryId;
  File? selectedImageFile;
  bool isUploadingImage = false;

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

  void selectImageFile(File? file) {
    selectedImageFile = file;
    emit(UpdateProductParams());
  }

  void clearImageFile() {
    selectedImageFile = null;
    createProductParams.imageUrl = '';
    emit(UpdateProductParams());
  }

  /// 🚀 NEW METHOD: Create product with image (all in one)
  /// 1. Create product first
  /// 2. If image selected, upload it with real productId
  /// 3. Return the product with image URL
  Future<Result<ProductModel>> createProductWithImage() async {
    // Step 1: Create product first (without image)
    print('📦 Step 1: Creating product...');
    final productResult = await CreateProductUsecase(
      ProductRepository(),
    ).call(params: createProductParams);

    if (productResult.hasErrorOnly) {
      print('❌ Product creation failed: ${productResult.error}');
      return productResult;
    }

    final product = productResult.data!;
    final productId = product.id;
    print('✅ Product created: $productId');

    // Step 2: Upload image if selected
    if (selectedImageFile != null && productId != null) {
      print('📤 Step 2: Uploading image...');

      isUploadingImage = true;
      emit(UpdateProductParams());

      final uploadResult = await FileUploadRepository().uploadFile(
        file: selectedImageFile!,
        entityId: productId, // ✅ Real productId
        entityType: 2, // Product = 2
        filePlacement: 'main', // or 'product-main'
      );

      isUploadingImage = false;
      emit(UpdateProductParams());

      if (uploadResult.hasDataOnly) {
        print('✅ Image uploaded successfully');
      } else {
        print('⚠️ Image upload failed: ${uploadResult.error}');
        // Product still created, just no image
      }
    }

    print('✅ Process complete!');
    return Result(data: product);
  }

  // API Methods (NO emit - boilerplate handles state)

  /// OLD METHOD: Create product only (no image handling)
  /// Use createProductWithImage() instead for new features
  Future<Result<ProductModel>> createProduct() async {
    print('📦 Creating product with params:');
    print('   name: ${createProductParams.name}');
    print('   imageUrl: ${createProductParams.imageUrl}');
    print('   price: ${createProductParams.price}');
    print('   categoryId: ${createProductParams.categoryId}');

    return await CreateProductUsecase(
      ProductRepository(),
    ).call(params: createProductParams);
  }

  Future<Result<List<ProductModel>>> fetchProductList(data, {String? categoryId}) async {
    return await GetProductListUsecase(
      ProductRepository(),
    ).call(params: GetProductListParams(request: data, categoryId: categoryId));
  }

  Future<Result<ProductModel>> getProductDetails(String productId) async {
    return await GetProductDetailsUsecase(
      ProductRepository(),
    ).call(params: GetProductDetailsParams(productId: productId));
  }
}
