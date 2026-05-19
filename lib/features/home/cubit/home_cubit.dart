import 'package:bloc/bloc.dart';
import 'package:store/features/home/data/repository/home_repository.dart';
import 'package:store/features/home/data/usecase/get_products_usecase.dart';
import '../../../core/boilerplate/pagination/cubits/pagination_cubit.dart';
import '../../../core/results/result.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  PaginationCubit? productsPagination;

  Future<Result> fetchProducts(data) async {
    return await GetProductsUsecase(
      HomeRepository(),
    ).call(
      params: GetProductsParams(request: data),
    );
  }
}