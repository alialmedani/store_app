import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class GetProductVariantDetailsParams extends BaseParams {
  final String productVariantId;

  GetProductVariantDetailsParams({required this.productVariantId});
}

class GetProductVariantDetailsUsecase
    extends UseCase<ProductVariantModel, GetProductVariantDetailsParams> {
  final ProductVariantRepository repository;

  GetProductVariantDetailsUsecase(this.repository);

  @override
  Future<Result<ProductVariantModel>> call({
    required GetProductVariantDetailsParams params,
  }) {
    return repository.getProductVariantDetailsRequest(params: params);
  }
}
