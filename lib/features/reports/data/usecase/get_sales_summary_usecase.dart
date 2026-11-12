import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/sales_summary_model.dart';
import '../repository/reports_repository.dart';

class GetSalesSummaryParams extends BaseParams {
  final String fromDate;
  final String toDate;
  final int groupBy;
  final int? status;
  final int? paymentStatus;

  GetSalesSummaryParams({
    required this.fromDate,
    required this.toDate,
    this.groupBy = 1,
    this.status,
    this.paymentStatus,
  });

  Map<String, dynamic> toJson() {
    return {
      'FromDate': fromDate,
      'ToDate': toDate,
      'GroupBy': groupBy,
      if (status != null) 'Status': status,
      if (paymentStatus != null) 'PaymentStatus': paymentStatus,
    };
  }
}

class GetSalesSummaryUsecase
    extends UseCase<SalesSummaryModel, GetSalesSummaryParams> {
  final ReportsRepository repository;

  GetSalesSummaryUsecase(this.repository);

  @override
  Future<Result<SalesSummaryModel>> call({
    required GetSalesSummaryParams params,
  }) {
    return repository.getSalesSummaryRequest(params: params);
  }
}
