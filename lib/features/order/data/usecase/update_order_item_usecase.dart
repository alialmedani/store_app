import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class UpdateOrderItemParams extends BaseParams {
  String orderId;
  String itemId;
  int quantity;

  UpdateOrderItemParams({
    required this.orderId,
    required this.itemId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }
}

class UpdateOrderItemUsecase extends UseCase<OrderModel, UpdateOrderItemParams> {
  final OrderRepository repository;

  UpdateOrderItemUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required UpdateOrderItemParams params}) {
    return repository.updateOrderItemRequest(params: params);
  }
}
