import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class GenerateProductVariantParams extends BaseParams {
  String productId;
  List<String> colors;
  List<String> sizes;
  int defaultStockQuantity;
  bool skipExisting;
  bool isActive;

  GenerateProductVariantParams({
    required this.productId,
    required this.colors,
    required this.sizes,
    required this.defaultStockQuantity,
    this.skipExisting = false,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'colors': colors,
      'sizes': sizes,
      'defaultStockQuantity': defaultStockQuantity,
      'skipExisting': skipExisting,
      'isActive': isActive,
    };
  }
}

class GenerateProductVariantUsecase
    extends UseCase<List<ProductVariantModel>, GenerateProductVariantParams> {
  final ProductVariantRepository repository;

  GenerateProductVariantUsecase(this.repository);

  @override
  Future<Result<List<ProductVariantModel>>> call({
    required GenerateProductVariantParams params,
  }) {
    return repository.generateProductVariantRequest(params: params);
  }
}
