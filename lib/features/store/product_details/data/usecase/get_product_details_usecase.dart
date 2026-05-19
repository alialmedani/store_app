import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

import '../model/product_details_model.dart';
import '../repository/product_details_repository.dart';

class GetProductDetailsParams extends BaseParams {
  final int id;

  GetProductDetailsParams({
    required this.id,
  });
}

class GetProductDetailsUsecase
    extends UseCase<ProductDetailsModel, GetProductDetailsParams> {
  final ProductDetailsRepository repository;

  GetProductDetailsUsecase(this.repository);

  @override
  Future<Result<ProductDetailsModel>> call({
    required GetProductDetailsParams params,
  }) {
    return repository.getProductDetailsRequest(params: params);
  }
}