import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class VariantItem {
  String color;
  String size;
  int stockQuantity;
  bool isActive;

  VariantItem({
    required this.color,
    required this.size,
    required this.stockQuantity,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'size': size,
      'stockQuantity': stockQuantity,
      'isActive': isActive,
    };
  }
}

class BulkCreateProductVariantParams extends BaseParams {
  String productId;
  List<VariantItem> variants;

  BulkCreateProductVariantParams({
    required this.productId,
    required this.variants,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'variants': variants.map((v) => v.toJson()).toList(),
    };
  }
}

class BulkCreateProductVariantUsecase
    extends UseCase<List<ProductVariantModel>, BulkCreateProductVariantParams> {
  final ProductVariantRepository repository;

  BulkCreateProductVariantUsecase(this.repository);

  @override
  Future<Result<List<ProductVariantModel>>> call({
    required BulkCreateProductVariantParams params,
  }) {
    return repository.bulkCreateProductVariantRequest(params: params);
  }
}
