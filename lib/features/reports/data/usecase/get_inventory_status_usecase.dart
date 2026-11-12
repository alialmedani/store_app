import 'package:store/core/params/base_params.dart';
import 'package:store/core/results/result.dart';
import 'package:store/core/usecase/usecase.dart';
import '../model/inventory_status_model.dart';
import '../repository/reports_repository.dart';

class GetInventoryStatusParams extends BaseParams {
  final String? categoryId;
  final bool lowStockOnly;
  final int lowStockThreshold;

  GetInventoryStatusParams({
    this.categoryId,
    this.lowStockOnly = false,
    this.lowStockThreshold = 5,
  });

  Map<String, dynamic> toJson() {
    return {
      if (categoryId != null) 'CategoryId': categoryId,
      'LowStockOnly': lowStockOnly,
      'LowStockThreshold': lowStockThreshold,
    };
  }
}

class GetInventoryStatusUsecase
    extends UseCase<InventoryStatusModel, GetInventoryStatusParams> {
  final ReportsRepository repository;

  GetInventoryStatusUsecase(this.repository);

  @override
  Future<Result<InventoryStatusModel>> call({
    required GetInventoryStatusParams params,
  }) {
    return repository.getInventoryStatusRequest(params: params);
  }
}
