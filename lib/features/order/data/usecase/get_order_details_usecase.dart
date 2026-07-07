import 'package:store/core/params/base_params.dart';
import 'package:store/core/usecase/usecase.dart';

import '../../../../../core/results/result.dart';
 import '../model/order_model.dart';
import '../repository/order_repository.dart';

class GetOrderDetailsParams extends BaseParams {
  final String orderId;

  GetOrderDetailsParams({required this.orderId});

  Map<String, dynamic> toJson() {
    return {'orderId': orderId};
  }
}

class GetOrderDetailsUsecase
    extends UseCase<OrderModel, GetOrderDetailsParams> {
  final OrderRepository repository;

  GetOrderDetailsUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required GetOrderDetailsParams params}) {
    return repository.getOrderDetailsRequest(params: params);
  }
}
