import 'package:bloc/bloc.dart';
import 'package:store/features/store/create_product/data/model/create_product_response_model.dart';

import '../../../../core/results/result.dart';
import '../data/repository/create_product_repository.dart';
import '../data/usecase/create_product_with_variants_usecase.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());

  CreateProductWithVariantsParams params = CreateProductWithVariantsParams(
    name: '',
    price: 0,
    description: null,
    imageUrl: null,
    categoryId: null,
    brandId: null,
    variants: [
      CreateProductVariantParams(
        color: '',
        size: '',
        quantity: 0,
        sku: null,
        imageUrl: null,
      ),
    ],
  );

  void setCategory(int? id) {
    params.categoryId = id;
    emit(CreateProductChanged());
  }

  void setBrand(int? id) {
    params.brandId = id;
    emit(CreateProductChanged());
  }

  void addVariant() {
    params.variants.add(
      CreateProductVariantParams(
        color: '',
        size: '',
        quantity: 0,
      ),
    );
    emit(CreateProductChanged());
  }

  void removeVariant(int index) {
    if (params.variants.length == 1) return;
    params.variants.removeAt(index);
    emit(CreateProductChanged());
  }

 Future<Result<dynamic>> createProduct() async {
  return await CreateProductWithVariantsUsecase(
    CreateProductRepository(),
  ).call(params: params);
}
}