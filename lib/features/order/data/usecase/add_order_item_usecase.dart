import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class AddOrderItemParams extends BaseParams {
  final String orderId;
  final String productVariantId;
  final int quantity;

  AddOrderItemParams({
    required this.orderId,
    required this.productVariantId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {'productVariantId': productVariantId, 'quantity': quantity};
  }
}

class AddOrderItemUsecase extends UseCase<OrderModel, AddOrderItemParams> {
  final OrderRepository repository;

  AddOrderItemUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required AddOrderItemParams params}) {
    return repository.addOrderItemRequest(params: params);
  }
}
