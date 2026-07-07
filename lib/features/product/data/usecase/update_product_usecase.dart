import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class UpdateProductParams extends BaseParams {
  String productId;
  String name;
  String description;
  double price;
  bool isActive;
  int targetAudience;
  String categoryId;

  UpdateProductParams({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
    required this.targetAudience,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'isActive': isActive,
      'targetAudience': targetAudience,
      'categoryId': categoryId,
    };
  }
}

class UpdateProductUsecase extends UseCase<ProductModel, UpdateProductParams> {
  final ProductRepository repository;

  UpdateProductUsecase(this.repository);

  @override
  Future<Result<ProductModel>> call({required UpdateProductParams params}) {
    return repository.updateProductRequest(params: params);
  }
}
