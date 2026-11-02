import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class CancelOrderParams extends BaseParams {
  final String orderId;
  final String reason;

  CancelOrderParams({required this.orderId, required this.reason});

  Map<String, dynamic> toJson() {
    return {'cancellationReason': reason};
  }
}

class CancelOrderUsecase extends UseCase<OrderModel, CancelOrderParams> {
  final OrderRepository repository;

  CancelOrderUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required CancelOrderParams params}) {
    return repository.cancelOrderRequest(params: params);
  }
}
