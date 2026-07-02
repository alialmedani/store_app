import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:store/core/constant/enum/enum.dart';

import '../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../core/results/result.dart';
import '../data/repository/category_repository.dart';
import '../data/usecase/create_category_params.dart';
import '../data/usecase/create_category_usecase.dart';
import '../data/usecase/get_category_by_id_usecase.dart';
import '../data/usecase/get_category_list_usecase.dart';
import '../data/usecase/get_category_params.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  /// Pagination cubit instance for category lists
  PaginationCubit? categoryPagination;

  /// Params for create/update operations
  CreateCategoryParams createCategoryParams = CreateCategoryParams(
    name: '',
    description: '',
    sizeType: SizeType.none,
    isActive: true,
  );

  /// Create a new category
  Future<Result> createCategory() async {
    return await CreateCategoryUsecase(
      CategoryRepository(),
    ).call(params: createCategoryParams);
  }

  /// Fetch list of categories with pagination
  Future<Result> fetchCategoryList(data) async {
    return await GetCategoryListUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryParams(request: data));
  }

  /// Fetch single category by ID
  Future<Result> fetchCategoryById(String id) async {
    return await GetCategoryByIdUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryParams(id: id));
  }

  /// Update selected size type
  void selectSizeType(SizeType type) {
    createCategoryParams.sizeType = type;
  }

  /// Toggle active status
  void toggleActive(bool value) {
    createCategoryParams.isActive = value;
  }

  /// Reset params to defaults
  void resetParams() {
    createCategoryParams = CreateCategoryParams(
      name: '',
      description: '',
      sizeType: SizeType.none,
      isActive: true,
    );
  }
}
