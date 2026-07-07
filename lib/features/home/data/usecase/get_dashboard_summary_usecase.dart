import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/dashboard_summary_model.dart';
import '../repository/home_repository.dart';

class GetDashboardSummaryParams extends BaseParams {
  GetDashboardSummaryParams();

  Map<String, dynamic> toJson() {
    return {};
  }
}

class GetDashboardSummaryUsecase
    extends UseCase<DashboardSummaryModel, GetDashboardSummaryParams> {
  final HomeRepository repository;

  GetDashboardSummaryUsecase(this.repository);

  @override
  Future<Result<DashboardSummaryModel>> call({
    required GetDashboardSummaryParams params,
  }) {
    return repository.getDashboardSummaryRequest(params: params);
  }
}
