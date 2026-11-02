import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class RemoveOrderItemParams extends BaseParams {
  final String orderId;
  final String itemId;

  RemoveOrderItemParams({required this.orderId, required this.itemId});
}

class RemoveOrderItemUsecase
    extends UseCase<OrderModel, RemoveOrderItemParams> {
  final OrderRepository repository;

  RemoveOrderItemUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required RemoveOrderItemParams params}) {
    return repository.removeOrderItemRequest(params: params);
  }
}
