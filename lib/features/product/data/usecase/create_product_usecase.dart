import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/product_model.dart';
import '../repository/product_repository.dart';

class CreateProductParams extends BaseParams {
  String name;
  String description;
  double price;
  bool isActive;
  int targetAudience;
  String categoryId;
  String imageUrl;

  CreateProductParams({
    required this.name,
    required this.description,
    required this.price,
    required this.isActive,
    required this.targetAudience,
    required this.categoryId,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'isActive': isActive,
      'targetAudience': targetAudience,
      'categoryId': categoryId,
      'imageUrl': imageUrl,
    };
  }
}

class CreateProductUsecase extends UseCase<ProductModel, CreateProductParams> {
  final ProductRepository repository;

  CreateProductUsecase(this.repository);

  @override
  Future<Result<ProductModel>> call({required CreateProductParams params}) {
    return repository.createProductRequest(params: params);
  }
}
