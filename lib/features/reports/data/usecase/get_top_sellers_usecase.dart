import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/top_sellers_model.dart';
import '../repository/reports_repository.dart';

class GetTopSellersParams extends BaseParams {
  final String fromDate;
  final String toDate;
  final bool groupByVariant;
  final int top;

  /// 1 = Top, 2 = Bottom.
  final int direction;
  final int? status;

  /// Defaults to TRUE (include discontinued/deleted) per backend default.
  final bool includeDeleted;

  GetTopSellersParams({
    required this.fromDate,
    required this.toDate,
    this.groupByVariant = false,
    this.top = 10,
    this.direction = 1,
    this.status,
    this.includeDeleted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      'GroupByVariant': groupByVariant,
      'Top': top,
      'Direction': direction,
      if (status != null) 'Status': status,
      'IncludeDeleted': includeDeleted,
    };
  }
}

class GetTopSellersUsecase
    extends UseCase<TopSellersModel, GetTopSellersParams> {
  final ReportsRepository repository;

  GetTopSellersUsecase(this.repository);

  @override
  Future<Result<TopSellersModel>> call({required GetTopSellersParams params}) {
    return repository.getTopSellersRequest(params: params);
  }
}
