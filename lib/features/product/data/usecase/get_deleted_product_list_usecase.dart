import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_repository.dart';
import '../model/product_model.dart';
import 'get_product_list_usecase.dart';

class GetDeletedProductListUsecase
    extends UseCase<List<ProductModel>, GetProductListParams> {
  final ProductRepository repository;

  GetDeletedProductListUsecase(this.repository);

  @override
  Future<Result<List<ProductModel>>> call({required GetProductListParams params}) {
    return repository.getDeletedProductListRequest(params: params);
  }
}
