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

import '../usecase/confirm_order_usecase.dart';
import '../usecase/cancel_order_usecase.dart';
import '../usecase/record_order_payment_usecase.dart';
import '../usecase/add_order_item_usecase.dart';
import '../usecase/remove_order_item_usecase.dart';
import '../usecase/delete_order_usecase.dart';

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

  Future<Result<OrderModel>> confirmOrderRequest({
    required ConfirmOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      url: confirmOrderUrl(params.orderId),
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

  Future<Result<OrderModel>> cancelOrderRequest({
    required CancelOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: cancelOrderUrl(params.orderId),
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

  Future<Result<OrderModel>> recordOrderPaymentRequest({
    required RecordOrderPaymentParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: recordOrderPaymentUrl(params.orderId),
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

  Future<Result<OrderModel>> addOrderItemRequest({
    required AddOrderItemParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      data: params.toJson(),
      url: addOrderItemUrl(params.orderId),
      method: HttpMethod.POST,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

  Future<Result<OrderModel>> removeOrderItemRequest({
    required RemoveOrderItemParams params,
  }) async {
    final result = await RemoteDataSource.request<OrderModel>(
      withAuthentication: true,
      url: removeOrderItemUrl(params.orderId, params.itemId),
      method: HttpMethod.DELETE,
      converter: (json) {
        return OrderModel.fromJson(json);
      },
    );
    return call(result: result);
  }

  Future<Result<bool>> deleteOrderRequest({
    required DeleteOrderParams params,
  }) async {
    final result = await RemoteDataSource.request<bool>(
      withAuthentication: true,
      url: deleteOrderUrl(params.orderId),
      method: HttpMethod.DELETE,
      converter: (json) => true,
    );
    return call(result: result);
  }
}
