import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class CreateProductVariantParams extends BaseParams {
  String productId;
  String color;
  String size;
  int stockQuantity;
  bool isActive;

  CreateProductVariantParams({
    required this.productId,
    required this.color,
    required this.size,
    required this.stockQuantity,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'color': color,
      'size': size,
      'stockQuantity': stockQuantity,
      'isActive': isActive,
    };
  }
}

class CreateProductVariantUsecase
    extends UseCase<ProductVariantModel, CreateProductVariantParams> {
  final ProductVariantRepository repository;

  CreateProductVariantUsecase(this.repository);

  @override
  Future<Result<ProductVariantModel>> call({
    required CreateProductVariantParams params,
  }) {
    return repository.createProductVariantRequest(params: params);
  }
}
