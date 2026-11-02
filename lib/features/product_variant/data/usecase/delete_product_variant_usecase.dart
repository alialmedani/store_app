import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_variant_repository.dart';

class DeleteProductVariantParams extends BaseParams {
  final String id;

  DeleteProductVariantParams({required this.id});
}

class DeleteProductVariantUsecase extends UseCase<bool, DeleteProductVariantParams> {
  final ProductVariantRepository repository;

  DeleteProductVariantUsecase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteProductVariantParams params}) {
    return repository.deleteProductVariantRequest(params: params);
  }
}
