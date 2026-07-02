import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../core/repository/file_upload_repository.dart';
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

  Future<Result<String>> uploadProductImage() async {
    if (selectedImageFile == null) {
      return Result(error: 'No image selected');
    }

    isUploadingImage = true;
    emit(UpdateProductParams());

    final result = await FileUploadRepository().uploadFile(
      file: selectedImageFile!,
      entityId: 'temp-product',
      entityType: 2, // Product = 2
      filePlacement: 'product-main',
    );

    isUploadingImage = false;

    if (result.hasDataOnly && result.data != null) {
      createProductParams.imageUrl = result.data!.fileName ?? '';
      emit(UpdateProductParams());
      return Result(data: result.data!.fileName ?? '');
    } else {
      emit(UpdateProductParams());
      return Result(error: result.error ?? 'Upload failed');
    }
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
