import '../../../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class GetOrderListParams extends BaseParams {
  final GetListRequest? request;

  GetOrderListParams({this.request});

  Map<String, dynamic> toJson() {
    return {
      if (request != null) ...{
        'SkipCount': request!.skip,
        'MaxResultCount': request!.take,
      },
    };
  }
}

class GetOrderListUsecase
    extends UseCase<List<OrderModel>, GetOrderListParams> {
  final OrderRepository repository;

  GetOrderListUsecase(this.repository);

  @override
  Future<Result<List<OrderModel>>> call({
    required GetOrderListParams params,
  }) {
    return repository.getOrderListRequest(params: params);
  }
}
