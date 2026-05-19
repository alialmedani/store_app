import 'package:bloc/bloc.dart';
import 'package:store/features/store/lookups/data/usecase/get_size_groups_usecase.dart';
import '../../../../core/results/result.dart';
import '../data/repository/lookups_repository.dart';
import '../data/usecase/get_brands_usecase.dart';
import '../data/usecase/get_categories_usecase.dart';
part 'lookups_state.dart';

class LookupsCubit extends Cubit<LookupsState> {
  LookupsCubit() : super(LookupsInitial());

  Future<Result> fetchCategories() async {
    return await GetCategoriesUsecase(
      LookupsRepository(),
    ).call(params: GetCategoriesParams());
  }

  Future<Result> fetchBrands() async {
    return await GetBrandsUsecase(
      LookupsRepository(),
    ).call(params: GetBrandsParams());
  }

  Future<Result> fetchSizeGroups(int categoryId) async {
    return await GetSizeGroupsUsecase(
      LookupsRepository(),
    ).call(params: GetSizeGroupsParams(categoryId: categoryId));
  }
}
