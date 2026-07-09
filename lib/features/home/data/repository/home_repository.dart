import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/dashboard_summary_model.dart';
import '../usecase/get_dashboard_summary_usecase.dart';

class HomeRepository extends CoreRepository {
  Future<Result<DashboardSummaryModel>> getDashboardSummaryRequest({
    required GetDashboardSummaryParams params,
  }) async {
    final result = await RemoteDataSource.request<DashboardSummaryModel>(
      withAuthentication: true,
      url: getDashboardSummaryUrl,
      method: HttpMethod.GET,
      converter: (json) {
        return DashboardSummaryModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
