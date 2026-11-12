import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/category_performance_model.dart';
import '../repository/reports_repository.dart';

class GetCategoryPerformanceParams extends BaseParams {
  final String fromDate;
  final String toDate;
  final int? status;
  final int? paymentStatus;

  /// Defaults to TRUE (include deleted categories) per backend default.
  final bool includeDeleted;

  GetCategoryPerformanceParams({
    required this.fromDate,
    required this.toDate,
    this.status,
    this.paymentStatus,
    this.includeDeleted = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      if (status != null) 'Status': status,
      if (paymentStatus != null) 'PaymentStatus': paymentStatus,
      'IncludeDeleted': includeDeleted,
    };
  }
}

class GetCategoryPerformanceUsecase
    extends UseCase<CategoryPerformanceModel, GetCategoryPerformanceParams> {
  final ReportsRepository repository;

  GetCategoryPerformanceUsecase(this.repository);

  @override
  Future<Result<CategoryPerformanceModel>> call({
    required GetCategoryPerformanceParams params,
  }) {
    return repository.getCategoryPerformanceRequest(params: params);
  }
}
