import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/profit_margin_model.dart';
import '../repository/reports_repository.dart';

class GetProfitMarginParams extends BaseParams {
  final String fromDate;
  final String toDate;
  final String? categoryId;
  final String? productId;
  final bool groupByVariant;
  final int? status;

  /// Defaults to TRUE (include deleted) per backend default.
  final bool includeDeleted;

  GetProfitMarginParams({
    required this.fromDate,
    required this.toDate,
    this.categoryId,
    this.productId,
    this.groupByVariant = false,
    this.status,
    this.includeDeleted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      if (categoryId != null) 'CategoryId': categoryId,
      if (productId != null) 'ProductId': productId,
      'GroupByVariant': groupByVariant,
      if (status != null) 'Status': status,
      'IncludeDeleted': includeDeleted,
    };
  }
}

class GetProfitMarginUsecase
    extends UseCase<ProfitMarginModel, GetProfitMarginParams> {
  final ReportsRepository repository;

  GetProfitMarginUsecase(this.repository);

  @override
  Future<Result<ProfitMarginModel>> call({
    required GetProfitMarginParams params,
  }) {
    return repository.getProfitMarginRequest(params: params);
  }
}
