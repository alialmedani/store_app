import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/results/result.dart';
import '../data/repository/home_repository.dart';
import '../data/usecase/get_dashboard_summary_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  Future<Result> getDashboardSummary() async {
    return await GetDashboardSummaryUsecase(
      HomeRepository(),
    ).call(params: GetDashboardSummaryParams());
  }
}
