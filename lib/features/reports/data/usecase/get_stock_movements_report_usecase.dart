import 'package:store/core/boilerplate/pagination/models/get_list_request.dart';
import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/stock_movement_report_model.dart';
import '../repository/reports_repository.dart';

class GetStockMovementsReportParams extends BaseParams {
  final GetListRequest? request;
  final String? fromDate;
  final String? toDate;
  final String? productVariantId;
  final int? movementType;

  /// Defaults to TRUE (include deleted) per backend default.
  final bool includeDeleted;
  final String? sorting;

  GetStockMovementsReportParams({
    this.request,
    this.fromDate,
    this.toDate,
    this.productVariantId,
    this.movementType,
    this.includeDeleted = true,
    this.sorting,
  });

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
      if (fromDate != null) 'FromDate': fromDate,
      if (toDate != null) 'ToDate': toDate,
      if (productVariantId != null) 'ProductVariantId': productVariantId,
      if (movementType != null) 'MovementType': movementType,
      'IncludeDeleted': includeDeleted,
      if (sorting != null) 'Sorting': sorting,
    };
  }
}

class GetStockMovementsReportUsecase extends UseCase<
    List<StockMovementReportModel>, GetStockMovementsReportParams> {
  final ReportsRepository repository;

  GetStockMovementsReportUsecase(this.repository);

  @override
  Future<Result<List<StockMovementReportModel>>> call({
    required GetStockMovementsReportParams params,
  }) {
    return repository.getStockMovementsRequest(params: params);
  }
}
