import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/results/result.dart';
import '../data/model/inventory_model.dart';
import '../data/repository/inventory_repository.dart';
import '../data/usecase/adjust_stock_usecase.dart';
import '../data/usecase/get_inventory_details_usecase.dart';
import '../data/usecase/get_inventory_list_usecase.dart';

part 'inventory_state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  InventoryCubit() : super(InventoryInitial());

  // Params
  GetInventoryListParams getInventoryListParams = GetInventoryListParams();
  AdjustStockParams adjustStockParams = AdjustStockParams(
    productVariantId: '',
    movementType: 0,
    quantity: 0,
  );

  // UI State Variables (Filters)
  String? selectedCategoryId;
  String? selectedProductId;
  String? selectedProductVariantId;
  int? selectedMovementType;
  int? selectedSourceType;
  String? selectedReferenceId;
  DateTime? fromDate;
  DateTime? toDate;

  // Validation Error Variables
  String? productVariantIdError;
  String? movementTypeError;
  String? quantityError;

  // UI State Methods (with emit)
  void setCategory(String? categoryId) {
    selectedCategoryId = categoryId;
    getInventoryListParams.categoryId = categoryId;
    emit(InventoryFilterUpdated());
  }

  void setProduct(String? productId) {
    selectedProductId = productId;
    getInventoryListParams.productId = productId;
    emit(InventoryFilterUpdated());
  }

  void setProductVariant(String? productVariantId) {
    selectedProductVariantId = productVariantId;
    getInventoryListParams.productVariantId = productVariantId;
    emit(InventoryFilterUpdated());
  }

  void setMovementType(int? movementType) {
    selectedMovementType = movementType;
    getInventoryListParams.movementType = movementType;
    emit(InventoryFilterUpdated());
  }

  void setSourceType(int? sourceType) {
    selectedSourceType = sourceType;
    getInventoryListParams.sourceType = sourceType;
    emit(InventoryFilterUpdated());
  }

  void setReferenceId(String? referenceId) {
    selectedReferenceId = referenceId;
    getInventoryListParams.referenceId = referenceId;
    emit(InventoryFilterUpdated());
  }

  void setDateRange(DateTime? from, DateTime? to) {
    fromDate = from;
    toDate = to;
    getInventoryListParams.fromDate = from?.toIso8601String();
    getInventoryListParams.toDate = to?.toIso8601String();
    emit(InventoryFilterUpdated());
  }

  void clearFilters() {
    selectedCategoryId = null;
    selectedProductId = null;
    selectedProductVariantId = null;
    selectedMovementType = null;
    selectedSourceType = null;
    selectedReferenceId = null;
    fromDate = null;
    toDate = null;
    getInventoryListParams = GetInventoryListParams();
    emit(InventoryFilterUpdated());
  }

  void setProductVariantIdError(String error) {
    productVariantIdError = error;
    emit(InventoryInitial());
  }

  void clearProductVariantIdError() {
    productVariantIdError = null;
    emit(InventoryInitial());
  }

  void setMovementTypeError(String error) {
    movementTypeError = error;
    emit(InventoryInitial());
  }

  void clearMovementTypeError() {
    movementTypeError = null;
    emit(InventoryInitial());
  }

  void setQuantityError(String error) {
    quantityError = error;
    emit(InventoryInitial());
  }

  void clearQuantityError() {
    quantityError = null;
    emit(InventoryInitial());
  }

  void clearAllErrors() {
    productVariantIdError = null;
    movementTypeError = null;
    quantityError = null;
    emit(InventoryInitial());
  }

  // API Methods (NO emit - boilerplate handles state)

  Future<Result<List<InventoryModel>>> fetchInventoryList(data) async {
    return await GetInventoryListUsecase(
      InventoryRepository(),
    ).call(params: GetInventoryListParams(request: data));
  }

  Future<Result<InventoryModel>> getInventoryDetails(String inventoryId) async {
    return await GetInventoryDetailsUsecase(
      InventoryRepository(),
    ).call(params: GetInventoryDetailsParams(inventoryId: inventoryId));
  }

  Future<Result<InventoryModel>> adjustStock() async {
    return await AdjustStockUsecase(
      InventoryRepository(),
    ).call(params: adjustStockParams);
  }
}
