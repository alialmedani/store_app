import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_repository.dart';

class RestoreProductParams extends BaseParams {
  final String id;

  RestoreProductParams({required this.id});
}

class RestoreProductUsecase extends UseCase<bool, RestoreProductParams> {
  final ProductRepository repository;

  RestoreProductUsecase(this.repository);

  @override
  Future<Result<bool>> call({required RestoreProductParams params}) {
    return repository.restoreProductRequest(params: params);
  }
}
