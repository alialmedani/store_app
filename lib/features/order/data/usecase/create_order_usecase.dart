import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class CreateOrderParams extends BaseParams {
  String customerName;
  String customerAddress;
  String customerPhone;
  String note;
  List<OrderItemParams> items;

  CreateOrderParams({
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.note,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerName': customerName,
      'customerAddress': customerAddress,
      'customerPhone': customerPhone,
      'note': note,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItemParams {
  String productVariantId;
  int quantity;

  OrderItemParams({required this.productVariantId, required this.quantity});

  Map<String, dynamic> toJson() {
    return {'productVariantId': productVariantId, 'quantity': quantity};
  }
}

class CreateOrderUsecase extends UseCase<OrderModel, CreateOrderParams> {
  final OrderRepository repository;

  CreateOrderUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required CreateOrderParams params}) {
    return repository.createOrderRequest(params: params);
  }
}
