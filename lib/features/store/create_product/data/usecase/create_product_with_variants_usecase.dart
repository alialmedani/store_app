import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/create_product_response_model.dart';
import '../repository/create_product_repository.dart';

class CreateProductVariantParams {
  String color;
  int? sizeOptionId;
  int quantity;
  String? sku;
  String? imageUrl;
  bool isActive;

  CreateProductVariantParams({
    required this.color,
    this.sizeOptionId,
    required this.quantity,
    this.sku,
    this.imageUrl,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'color': color,
      'sizeOptionId': sizeOptionId,
      'quantity': quantity,
      if (sku != null && sku!.trim().isNotEmpty) 'sku': sku,
      if (imageUrl != null && imageUrl!.trim().isNotEmpty)
        'imageUrl': imageUrl,
      'isActive': isActive,
    };
  }
}

class CreateProductWithVariantsParams extends BaseParams {
  String name;
  double price;
  String? description;
  String? imageUrl;
  int? categoryId;
  int? brandId;
  List<CreateProductVariantParams> variants;

  CreateProductWithVariantsParams({
    required this.name,
    required this.price,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.brandId,
    required this.variants,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      if (description != null && description!.trim().isNotEmpty)
        'description': description,
      if (imageUrl != null && imageUrl!.trim().isNotEmpty)
        'imageUrl': imageUrl,
      'categoryId': categoryId,
      'brandId': brandId,
      'variants': variants.map((e) => e.toJson()).toList(),
    };
  }
}

class CreateProductWithVariantsUsecase
    extends UseCase<CreateProductResponseModel, CreateProductWithVariantsParams> {
  final CreateProductRepository repository;

  CreateProductWithVariantsUsecase(this.repository);

  @override
  Future<Result<CreateProductResponseModel>> call({
    required CreateProductWithVariantsParams params,
  }) {
    return repository.createProductWithVariantsRequest(params: params);
  }
}