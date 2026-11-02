import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class ConfirmOrderParams extends BaseParams {
  final String orderId;

  ConfirmOrderParams({required this.orderId});
}

class ConfirmOrderUsecase extends UseCase<OrderModel, ConfirmOrderParams> {
  final OrderRepository repository;

  ConfirmOrderUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required ConfirmOrderParams params}) {
    return repository.confirmOrderRequest(params: params);
  }
}
