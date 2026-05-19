import 'package:bloc/bloc.dart';

import '../../../../core/results/result.dart';
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

  Future<Result> fetchCategories() async {
    return await GetCategoriesUsecase(
      CategoryRepository(),
    ).call(params: GetCategoriesParams());
  }

  Future<Result<dynamic>> createCategory() async {
    return await CreateCategoryUsecase(
      CategoryRepository(),
    ).call(params: createParams);
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
}