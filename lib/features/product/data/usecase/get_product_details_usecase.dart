import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class GetProductDetailsParams extends BaseParams {
  final String productId;

  GetProductDetailsParams({required this.productId});
}

class GetProductDetailsUsecase
    extends UseCase<ProductModel, GetProductDetailsParams> {
  final ProductRepository repository;

  GetProductDetailsUsecase(this.repository);

  @override
  Future<Result<ProductModel>> call({
    required GetProductDetailsParams params,
  }) {
    return repository.getProductDetailsRequest(params: params);
  }
}
