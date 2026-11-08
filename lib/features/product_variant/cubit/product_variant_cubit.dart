import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import '../../../core/constant/enum/enum.dart';
import '../../../core/results/result.dart';
import '../../product/data/model/product_model.dart';
import '../../category/data/repository/category_repository.dart';
import '../../category/data/usecase/get_category_details_usecase.dart';
import '../data/model/product_variant_model.dart';
import '../data/repository/product_variant_repository.dart';
import '../data/usecase/bulk_create_product_variant_usecase.dart';
import '../data/usecase/create_product_variant_usecase.dart';
import '../data/usecase/generate_product_variant_usecase.dart';
import '../data/usecase/get_product_variant_details_usecase.dart';
import '../data/usecase/get_product_variant_list_usecase.dart';
import '../data/usecase/update_product_variant_usecase.dart';

import '../data/usecase/delete_product_variant_usecase.dart';
import '../data/usecase/restore_product_variant_usecase.dart';
import '../data/usecase/get_deleted_product_variant_list_usecase.dart';
part 'product_variant_state.dart';

class ProductVariantCubit extends Cubit<ProductVariantState> {
  ProductVariantCubit() : super(ProductVariantInitial());

  // Params
  CreateProductVariantParams createProductVariantParams =
      CreateProductVariantParams(
        productId: '',
        color: null,
        size: null,
        stockQuantity: 0,
        isActive: true,
      );

  UpdateProductVariantParams updateProductVariantParams =
      UpdateProductVariantParams(
        productVariantId: '',
        color: null,
        size: null,
        isActive: true,
      );

  // UI State Variables
  ProductModel? selectedProduct;
  SizeType? resolvedSizeType;
  bool sizeLoading = false;

  /// Size field is shown only after a product is chosen and its category
  /// type is known, and only if that type uses sizes.
  bool isSizeVisible() =>
      selectedProduct != null && !sizeLoading && isSizeRequired();

  /// The product payload only carries {id, name} for its category, so the
  /// size type is fetched from the category when it is missing.
  static Future<SizeType?> resolveSizeType(ProductModel product) async {
    final direct = product.category?.sizeType;
    if (direct != null) return direct;
    final id = product.category?.id;
    if (id == null) return null;
    final result = await GetCategoryDetailsUsecase(
      CategoryRepository(),
    ).call(params: GetCategoryDetailsParams(categoryId: id));
    return result.data?.sizeType;
  }


  // Validation Error Variables
  String? productError;
  String? colorError;
  String? sizeError;
  String? stockQuantityError;

  // UI State Methods (with emit)
  void selectProduct(ProductModel product) {
    selectedProduct = product;
    createProductVariantParams.productId = product.id ?? '';
    resolvedSizeType = product.category?.sizeType;
    if (!isSizeRequired()) createProductVariantParams.size = '';
    clearProductError();
    sizeLoading = resolvedSizeType == null;
    emit(ProductVariantInitial());
    if (resolvedSizeType == null) {
      resolveSizeType(product).then((type) {
        if (selectedProduct?.id != product.id || isClosed) return;
        resolvedSizeType = type;
        sizeLoading = false;
        if (!isSizeRequired()) createProductVariantParams.size = '';
        emit(ProductVariantInitial());
      });
    }
  }

  // Check if color is required based on product category sizeType
  bool isColorRequired() {
    final sizeType = resolvedSizeType ?? selectedProduct?.category?.sizeType;
    // Color not required only for 'none' type (accessories)
    return sizeType != SizeType.none;
  }

  // Check if size is required based on product category sizeType
  bool isSizeRequired() {
    final sizeType = resolvedSizeType ?? selectedProduct?.category?.sizeType;
    // Size not required for 'none' and 'oneSize' types
    return sizeType != SizeType.none && sizeType != SizeType.oneSize;
  }

  void toggleIsActive(bool value) {
    createProductVariantParams.isActive = value;
    emit(ProductVariantInitial());
  }

  void toggleUpdateIsActive(bool value) {
    updateProductVariantParams.isActive = value;
    emit(ProductVariantInitial());
  }

  void setProductError(String error) {
    productError = error;
    emit(ProductVariantValidationError());
  }

  void clearProductError() {
    productError = null;
    emit(ProductVariantValidationError());
  }

  void setColorError(String error) {
    colorError = error;
    emit(ProductVariantValidationError());
  }

  void clearColorError() {
    colorError = null;
    emit(ProductVariantValidationError());
  }

  void setSizeError(String error) {
    sizeError = error;
    emit(ProductVariantValidationError());
  }

  void clearSizeError() {
    sizeError = null;
    emit(ProductVariantValidationError());
  }

  void setStockQuantityError(String error) {
    stockQuantityError = error;
    emit(ProductVariantValidationError());
  }

  void clearStockQuantityError() {
    stockQuantityError = null;
    emit(ProductVariantValidationError());
  }

  void clearAllErrors() {
    productError = null;
    colorError = null;
    sizeError = null;
    stockQuantityError = null;
    emit(ProductVariantValidationError());
  }

  // API Methods (NO emit - boilerplate handles state)
  Future<Result<ProductVariantModel>> createProductVariant() async {
    return await CreateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: createProductVariantParams);
  }

  Future<Result<List<ProductVariantModel>>> bulkCreateProductVariant(
    BulkCreateProductVariantParams params,
  ) async {
    return await BulkCreateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: params);
  }

  Future<Result<List<ProductVariantModel>>> generateProductVariant(
    GenerateProductVariantParams params,
  ) async {
    return await GenerateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: params);
  }

  Future<Result<List<ProductVariantModel>>> fetchProductVariantList(
    data, {
    String? productId,
  }) async {
    return await GetProductVariantListUsecase(ProductVariantRepository()).call(
      params: GetProductVariantListParams(request: data, productId: productId),
    );
  }

  Future<Result<ProductVariantModel>> getProductVariantDetails(
    String productVariantId,
  ) async {
    return await GetProductVariantDetailsUsecase(
      ProductVariantRepository(),
    ).call(
      params: GetProductVariantDetailsParams(
        productVariantId: productVariantId,
      ),
    );
  }

  Future<Result<ProductVariantModel>> updateProductVariant() async {
    return await UpdateProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: updateProductVariantParams);
  }

  Future<Result<bool>> deleteProductVariant(String id) async {
    return await DeleteProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: DeleteProductVariantParams(id: id));
  }

  Future<Result<bool>> restoreProductVariant(String id) async {
    return await RestoreProductVariantUsecase(
      ProductVariantRepository(),
    ).call(params: RestoreProductVariantParams(id: id));
  }

  Future<Result<List<ProductVariantModel>>> fetchDeletedProductVariantList(data) async {
    return await GetDeletedProductVariantListUsecase(
      ProductVariantRepository(),
    ).call(params: GetProductVariantListParams(request: data));
  }
}
