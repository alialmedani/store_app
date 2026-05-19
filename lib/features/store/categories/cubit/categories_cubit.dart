import 'package:bloc/bloc.dart';

import '../../../../core/results/result.dart';
import '../data/model/category_model.dart';
import '../data/repository/category_repository.dart';
import '../data/usecase/category_usecase.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  int refreshKey = 0;

  CreateCategoryParams createParams = CreateCategoryParams(
    name: '',
    description: null,
  );

  UpdateCategoryParams? updateParams;

  Future<Result> fetchCategories() async {
    return await GetCategoriesUsecase(
      CategoryRepository(),
    ).call(params: GetCategoriesParams());
  }

  Future<Result> fetchCategoryById(int id) async {
    return await GetCategoryByIdUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryByIdParams(id: id));
  }

  Future<Result<dynamic>> createCategory() async {
    return await CreateCategoryUsecase(
      CategoryRepository(),
    ).call(params: createParams);
  }

  Future<Result<dynamic>> updateCategory() async {
    return await UpdateCategoryUsecase(
      CategoryRepository(),
    ).call(params: updateParams!);
  }

  Future<Result<dynamic>> deleteCategory(int id) async {
    return await DeleteCategoryUsecase(
      CategoryRepository(),
    ).call(params: CategoryActionParams(id: id));
  }

  Future<Result<dynamic>> activateCategory(int id) async {
    return await ActivateCategoryUsecase(
      CategoryRepository(),
    ).call(params: CategoryActionParams(id: id));
  }

  Future<Result<dynamic>> deactivateCategory(int id) async {
    return await DeactivateCategoryUsecase(
      CategoryRepository(),
    ).call(params: CategoryActionParams(id: id));
  }

  void refreshCategories() {
    refreshKey++;
    emit(CategoriesChanged());
  }

  void resetCreateParams() {
    createParams = CreateCategoryParams(
      name: '',
      description: null,
    );
  }

  void setUpdateParams(CategoryModel category) {
    updateParams = UpdateCategoryParams(
      id: category.id!,
      name: category.name ?? '',
      description: category.description,
    );
  }
}