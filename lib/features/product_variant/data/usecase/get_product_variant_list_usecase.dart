import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class GetProductVariantListParams extends BaseParams {
  final GetListRequest? request;
  final String? productId;

  GetProductVariantListParams({this.request, this.productId});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
      if (productId != null) 'ProductId': productId,
    };
  }
}

class GetProductVariantListUsecase
    extends UseCase<List<ProductVariantModel>, GetProductVariantListParams> {
  final ProductVariantRepository repository;

  GetProductVariantListUsecase(this.repository);

  @override
  Future<Result<List<ProductVariantModel>>> call({
    required GetProductVariantListParams params,
  }) {
    return repository.getProductVariantListRequest(params: params);
  }
}
