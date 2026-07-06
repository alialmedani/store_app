import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../core/results/result.dart';
import '../data/model/order_model.dart';
import '../data/repository/order_repository.dart';
import '../data/usecase/create_order_usecase.dart';
import '../data/usecase/get_order_list_usecase.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  // Params
  CreateOrderParams createOrderParams = CreateOrderParams(
    customerName: '',
    customerAddress: '',
    customerPhone: '',
    note: '',
    items: [],
  );

  // UI State Variables
  List<OrderItemParams> orderItems = [];

  // Validation Error Variables
  String? customerNameError;
  String? customerPhoneError;
  String? customerAddressError;
  String? itemsError;

  // UI State Methods (with emit)

  void setCustomerNameError(String error) {
    customerNameError = error;
    emit(OrderValidationError());
  }

  void clearCustomerNameError() {
    customerNameError = null;
    emit(OrderValidationError());
  }

  void setCustomerPhoneError(String error) {
    customerPhoneError = error;
    emit(OrderValidationError());
  }

  void clearCustomerPhoneError() {
    customerPhoneError = null;
    emit(OrderValidationError());
  }

  void setCustomerAddressError(String error) {
    customerAddressError = error;
    emit(OrderValidationError());
  }

  void clearCustomerAddressError() {
    customerAddressError = null;
    emit(OrderValidationError());
  }

  void setItemsError(String error) {
    itemsError = error;
    emit(OrderValidationError());
  }

  void clearItemsError() {
    itemsError = null;
    emit(OrderValidationError());
  }

  void clearAllErrors() {
    customerNameError = null;
    customerPhoneError = null;
    customerAddressError = null;
    itemsError = null;
    emit(OrderValidationError());
  }

  void addOrderItem({required String productVariantId, required int quantity}) {
    final item = OrderItemParams(
      productVariantId: productVariantId,
      quantity: quantity,
    );
    orderItems.add(item);
    createOrderParams.items = orderItems;
    clearItemsError();
    emit(UpdateOrderParams());
  }

  void removeOrderItem(int index) {
    if (index >= 0 && index < orderItems.length) {
      orderItems.removeAt(index);
      createOrderParams.items = orderItems;
      emit(UpdateOrderParams());
    }
  }

  void updateOrderItemQuantity(int index, int quantity) {
    if (index >= 0 && index < orderItems.length) {
      orderItems[index].quantity = quantity;
      createOrderParams.items = orderItems;
      emit(UpdateOrderParams());
    }
  }

  void clearAllItems() {
    orderItems.clear();
    createOrderParams.items = orderItems;
    emit(UpdateOrderParams());
  }

  // API Methods (NO emit - boilerplate handles state)

  Future<Result<OrderModel>> createOrder() async {
    return await CreateOrderUsecase(
      OrderRepository(),
    ).call(params: createOrderParams);
  }

  Future<Result<List<OrderModel>>> fetchOrderList(data) async {
    return await GetOrderListUsecase(
      OrderRepository(),
    ).call(params: GetOrderListParams(request: data));
  }
}
