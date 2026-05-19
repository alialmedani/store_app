import 'package:bloc/bloc.dart';

import '../../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../../core/results/result.dart';
import '../data/repository/home_repository.dart';
import '../data/usecase/get_products_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  PaginationCubit? productsPagination;

  int refreshKey = 0;

  Future<Result> fetchProducts(data) async {
    return await GetProductsUsecase(
      HomeRepository(),
    ).call(params: GetProductsParams(request: data));
  }

  void refreshProducts() {
    refreshKey++;
    emit(HomeRefreshChanged(refreshKey));
  }
}