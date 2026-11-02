import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_variant_repository.dart';

class RestoreProductVariantParams extends BaseParams {
  final String id;

  RestoreProductVariantParams({required this.id});
}

class RestoreProductVariantUsecase extends UseCase<bool, RestoreProductVariantParams> {
  final ProductVariantRepository repository;

  RestoreProductVariantUsecase(this.repository);

  @override
  Future<Result<bool>> call({required RestoreProductVariantParams params}) {
    return repository.restoreProductVariantRequest(params: params);
  }
}
