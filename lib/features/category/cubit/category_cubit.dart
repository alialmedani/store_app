import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/results/result.dart';
import '../data/model/category_model.dart';
import '../data/repository/category_repository.dart';
import '../data/usecase/create_category_usecase.dart';
import '../data/usecase/get_category_list_usecase.dart';

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

  // UI State Variables
  int? selectedSizeType = 1;

  // Validation Error Variables
  String? nameError;
  String? sizeTypeError;

  // UI State Methods (with emit)
  void selectSizeType(int sizeType) {
    selectedSizeType = sizeType;
    createCategoryParams.sizeType = sizeType;
    clearSizeTypeError();
    emit(UpdateCategoryParams());
  }

  void toggleIsActive(bool value) {
    createCategoryParams.isActive = value;
    emit(UpdateCategoryParams());
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

  // API Methods (NO emit - boilerplate handles state)
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
}
