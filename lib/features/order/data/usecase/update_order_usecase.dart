import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class UpdateOrderParams extends BaseParams {
  String orderId;
  String customerName;
  String customerAddress;
  String customerPhone;
  String note;

  UpdateOrderParams({
    required this.orderId,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'note': note,
    };
  }
}

class UpdateOrderUsecase extends UseCase<OrderModel, UpdateOrderParams> {
  final OrderRepository repository;

  UpdateOrderUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required UpdateOrderParams params}) {
    return repository.updateOrderRequest(params: params);
  }
}
