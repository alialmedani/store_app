import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/inventory_model.dart';
import '../repository/inventory_repository.dart';

class GetInventoryDetailsParams extends BaseParams {
  final String inventoryId;

  GetInventoryDetailsParams({required this.inventoryId});

  Map<String, dynamic> toJson() {
    return {'id': inventoryId};
  }
}

class GetInventoryDetailsUsecase
    extends UseCase<InventoryModel, GetInventoryDetailsParams> {
  final InventoryRepository repository;

  GetInventoryDetailsUsecase(this.repository);

  @override
  Future<Result<InventoryModel>> call({
    required GetInventoryDetailsParams params,
  }) {
    return repository.getInventoryDetailsRequest(params: params);
  }
}
