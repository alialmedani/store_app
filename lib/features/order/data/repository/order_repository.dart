import '../../../../../core/constant/end_points/api_url.dart';
import '../../../../../core/data_source/remote_data_source.dart';
import '../../../../../core/http/http_method.dart';
import '../../../../../core/repository/core_repository.dart';
import '../../../../../core/results/result.dart';
import '../model/order_model.dart';
import '../usecase/create_order_usecase.dart';
import '../usecase/get_order_details_usecase.dart';
import '../usecase/get_order_list_usecase.dart';
import '../usecase/update_order_item_usecase.dart';
import '../usecase/update_order_usecase.dart';

class OrderRepository extends CoreRepository {
  Future<Result<OrderModel>> createOrderRequest({
    required CreateOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: createOrderUrl,
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<List<OrderModel>>> getOrderListRequest({
    required GetOrderListParams params,
  }) async {
    final result = await RemoteDataSource.request<List<OrderModel>>(
      withAuthentication: true,
      queryParameters: params.toJson(),
      url: getOrderListUrl,
      method: HttpMethod.GET,
      converter: (json) {
        final items = json['items'] as List;
        return items.map((item) => OrderModel.fromJson(item)).toList();
      },
    );

    return paginatedCall(result: result);
  }

  Future<Result<OrderModel>> getOrderDetailsRequest({
    required GetOrderDetailsParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      url: getOrderDetailsUrl(params.orderId),
      method: HttpMethod.GET,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<OrderModel>> updateOrderRequest({
    required UpdateOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: updateOrderUrl(params.orderId),
      method: HttpMethod.PUT,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );

    return call(result: result);
  }

  Future<Result<OrderModel>> updateOrderItemRequest({
    required UpdateOrderItemParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: updateOrderItemUrl(params.orderId, params.itemId),
      method: HttpMethod.PUT,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );

    return call(result: result);
  }
}
