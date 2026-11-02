import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/product_variant_repository.dart';
import '../model/product_variant_model.dart';
import 'get_product_variant_list_usecase.dart';

class GetDeletedProductVariantListUsecase
    extends UseCase<List<ProductVariantModel>, GetProductVariantListParams> {
  final ProductVariantRepository repository;

  GetDeletedProductVariantListUsecase(this.repository);

  @override
  Future<Result<List<ProductVariantModel>>> call({required GetProductVariantListParams params}) {
    return repository.getDeletedProductVariantListRequest(params: params);
  }
}
