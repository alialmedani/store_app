import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_repository.dart';

class DeleteProductParams extends BaseParams {
  final String id;

  DeleteProductParams({required this.id});
}

class DeleteProductUsecase extends UseCase<bool, DeleteProductParams> {
  final ProductRepository repository;

  DeleteProductUsecase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteProductParams params}) {
    return repository.deleteProductRequest(params: params);
  }
}
