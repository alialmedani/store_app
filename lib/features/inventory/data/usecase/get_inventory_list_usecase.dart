import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/inventory_model.dart';
import '../repository/inventory_repository.dart';

class GetInventoryListParams extends BaseParams {
  final GetListRequest? request;
  String? categoryId;
  String? productId;
  String? productVariantId;
  int? movementType;
  int? sourceType;
  String? referenceId;
  String? fromDate;
  String? toDate;
  String? filter;
  String? sorting;

  GetInventoryListParams({
    this.request,
    this.categoryId,
    this.productId,
    this.productVariantId,
    this.movementType,
    this.sourceType,
    this.referenceId,
    this.fromDate,
    this.toDate,
    this.filter,
    this.sorting,
  });

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
      if (categoryId != null) 'CategoryId': categoryId,
      if (productId != null) 'ProductId': productId,
      if (productVariantId != null) 'ProductVariantId': productVariantId,
      if (movementType != null) 'MovementType': movementType,
      if (sourceType != null) 'SourceType': sourceType,
      if (referenceId != null) 'ReferenceId': referenceId,
      if (fromDate != null) 'FromDate': fromDate,
      if (toDate != null) 'ToDate': toDate,
      if (filter != null) 'Filter': filter,
      if (sorting != null) 'Sorting': sorting,
    };
  }
}

class GetInventoryListUsecase
    extends UseCase<List<InventoryModel>, GetInventoryListParams> {
  final InventoryRepository repository;

  GetInventoryListUsecase(this.repository);

  @override
  Future<Result<List<InventoryModel>>> call({
    required GetInventoryListParams params,
  }) {
    return repository.getInventoryListRequest(params: params);
  }
}
