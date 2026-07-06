import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_variant_model.dart';
import '../repository/product_variant_repository.dart';

class UpdateProductVariantUsecase
    extends UseCase<ProductVariantModel, UpdateProductVariantParams> {
  final ProductVariantRepository repository;

  UpdateProductVariantUsecase(this.repository);

  @override
  Future<Result<ProductVariantModel>> call({
    required UpdateProductVariantParams params,
  }) {
    return repository.updateProductVariantRequest(params: params);
  }
}

class UpdateProductVariantParams extends BaseParams {
  String productVariantId;
  String? color;
  String? size;
  bool isActive;

  UpdateProductVariantParams({
    required this.productVariantId,
    this.color,
    this.size,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      if (color != null) 'color': color,
      if (size != null) 'size': size,
      'isActive': isActive,
    };
  }
}
