import 'package:bloc/bloc.dart';

import '../../../../core/results/result.dart';

import '../data/repository/product_details_repository.dart';
import '../data/usecase/get_product_details_usecase.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit() : super(ProductDetailsInitial());

  Future<Result> fetchProductDetails(int id) async {
    return await GetProductDetailsUsecase(
      ProductDetailsRepository(),
    ).call(
      params: GetProductDetailsParams(id: id),
    );
  }
}