import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import '../../../core/repository/file_upload_repository.dart';
import '../../../core/results/result.dart';
import '../data/model/category_model.dart';
import '../data/model/category_stock_summary_model.dart';
import '../data/repository/category_repository.dart';
import '../data/usecase/create_category_usecase.dart';
import '../data/usecase/get_category_details_usecase.dart';
import '../data/usecase/get_category_list_usecase.dart';
import '../data/usecase/get_category_stock_summary_usecase.dart';
import '../data/usecase/update_category_usecase.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  // Params
  CreateCategoryParams createCategoryParams = CreateCategoryParams(
    name: '',
    description: '',
    sizeType: 1,
    isActive: true,
  );

  UpdateCategoryParams updateCategoryParams = UpdateCategoryParams(
    name: '',
    description: '',
    sizeType: 1,
    isActive: true,
  );

  // UI State Variables
  int? selectedSizeType = 1;
  File? selectedImageFile;
  bool isUploadingImage = false;

  // Validation Error Variables
  String? nameError;
  String? sizeTypeError;

  // UI State Methods (with emit)
  void selectSizeType(int sizeType) {
    selectedSizeType = sizeType;
    createCategoryParams.sizeType = sizeType;
    clearSizeTypeError();
    emit(CategoryParamsUpdated());
  }

  void toggleIsActive(bool value) {
    createCategoryParams.isActive = value;
    emit(CategoryParamsUpdated());
  }

  void setNameError(String error) {
    nameError = error;
    emit(CategoryValidationError());
  }

  void clearNameError() {
    nameError = null;
    emit(CategoryValidationError());
  }

  void setSizeTypeError(String error) {
    sizeTypeError = error;
    emit(CategoryValidationError());
  }

  void clearSizeTypeError() {
    sizeTypeError = null;
    emit(CategoryValidationError());
  }

  void clearAllErrors() {
    nameError = null;
    sizeTypeError = null;
    emit(CategoryValidationError());
  }

  void selectImageFile(File? file) {
    selectedImageFile = file;
    emit(CategoryParamsUpdated());
  }

  void clearImageFile() {
    selectedImageFile = null;
    emit(CategoryParamsUpdated());
  }

  // API Methods (NO emit - boilerplate handles state)

  /// 🚀 NEW METHOD: Create category with image (all in one)
  Future<Result<CategoryModel>> createCategoryWithImage() async {
    // Step 1: Create category first
    print('📦 Step 1: Creating category...');
    final categoryResult = await CreateCategoryUsecase(
      CategoryRepository(),
    ).call(params: createCategoryParams);

    if (categoryResult.hasErrorOnly) {
      print('❌ Category creation failed: ${categoryResult.error}');
      return categoryResult;
    }

    final category = categoryResult.data!;
    final categoryId = category.id;
    print('✅ Category created: $categoryId');

    // Step 2: Upload image if selected
    if (selectedImageFile != null && categoryId != null) {
      print('📤 Step 2: Uploading image...');

      isUploadingImage = true;
      emit(CategoryParamsUpdated());

      final uploadResult = await FileUploadRepository().uploadFile(
        file: selectedImageFile!,
        entityId: categoryId, // ✅ Real categoryId
        entityType: 1, // Category = 1
        filePlacement: 'main',
      );

      isUploadingImage = false;
      emit(CategoryParamsUpdated());

      if (uploadResult.hasDataOnly) {
        print('✅ Image uploaded successfully');
      } else {
        print('⚠️ Image upload failed: ${uploadResult.error}');
      }
    }

    print('✅ Process complete!');
    return Result(data: category);
  }

  /// OLD METHOD: Create category only (no image handling)
  Future<Result<CategoryModel>> createCategory() async {
    return await CreateCategoryUsecase(
      CategoryRepository(),
    ).call(params: createCategoryParams);
  }

  Future<Result<List<CategoryModel>>> fetchCategoryList(data) async {
    return await GetCategoryListUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryListParams(request: data));
  }

  Future<Result<CategoryModel>> getCategoryDetails(String categoryId) async {
    return await GetCategoryDetailsUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryDetailsParams(categoryId: categoryId));
  }


  Future<Result<CategoryModel>> updateCategory() async {
    return await UpdateCategoryUsecase(
      CategoryRepository(),
    ).call(params: updateCategoryParams);
  }
  Future<Result<List<CategoryStockSummaryModel>>> fetchCategoryStockSummary(
    data,
  ) async {
    return await GetCategoryStockSummaryUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryStockSummaryParams(request: data));
  }
}
