import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/inventory_model.dart';
import '../repository/inventory_repository.dart';

class AdjustStockParams extends BaseParams {
  String productVariantId;
  int movementType;
  int quantity;
  String? referenceId;
  String? note;

  AdjustStockParams({
    required this.productVariantId,
    required this.movementType,
    required this.quantity,
    this.referenceId,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'productVariantId': productVariantId,
      'movementType': movementType,
      'quantity': quantity,
      if (referenceId != null) 'referenceId': referenceId,
      if (note != null) 'note': note,
    };
  }
}

class AdjustStockUsecase extends UseCase<InventoryModel, AdjustStockParams> {
  final InventoryRepository repository;

  AdjustStockUsecase(this.repository);

  @override
  Future<Result<InventoryModel>> call({
    required AdjustStockParams params,
  }) {
    return repository.adjustStockRequest(params: params);
  }
}
