import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repository/order_repository.dart';

class DeleteOrderParams extends BaseParams {
  final String orderId;

  DeleteOrderParams({required this.orderId});
}

class DeleteOrderUsecase extends UseCase<bool, DeleteOrderParams> {
  final OrderRepository repository;

  DeleteOrderUsecase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteOrderParams params}) {
    return repository.deleteOrderRequest(params: params);
  }
}
