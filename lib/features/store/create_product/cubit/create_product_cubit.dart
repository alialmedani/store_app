import 'package:bloc/bloc.dart';

import '../../../../core/results/result.dart';
import '../../lookups/data/model/lookup_model.dart';
import '../../lookups/data/model/size_group_model.dart';
import '../../lookups/data/repository/lookups_repository.dart';
import '../../lookups/data/usecase/get_brands_usecase.dart';
import '../../lookups/data/usecase/get_categories_usecase.dart';
import '../../lookups/data/usecase/get_size_groups_usecase.dart';
import '../data/repository/create_product_repository.dart';
import '../data/usecase/create_product_with_variants_usecase.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());

  List<LookupModel> categories = [];
  List<LookupModel> brands = [];
  List<SizeOptionModel> sizeOptions = [];

  bool isLoadingLookups = false;
  bool isLoadingSizes = false;

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
        sizeOptionId: null,
        quantity: 0,
        sku: null,
        imageUrl: null,
      ),
    ],
  );

  Future<void> loadLookups() async {
    isLoadingLookups = true;
    emit(CreateProductChanged());

    final categoriesResult = await GetCategoriesUsecase(
      LookupsRepository(),
    ).call(params: GetCategoriesParams());

    final brandsResult = await GetBrandsUsecase(
      LookupsRepository(),
    ).call(params: GetBrandsParams());

    categories = categoriesResult.data ?? [];
    brands = brandsResult.data ?? [];

    isLoadingLookups = false;
    emit(CreateProductChanged());
  }

  Future<void> setCategory(int? id) async {
    params.categoryId = id;
    sizeOptions = [];

    for (final variant in params.variants) {
      variant.sizeOptionId = null;
    }

    emit(CreateProductChanged());

    if (id == null) return;

    isLoadingSizes = true;
    emit(CreateProductChanged());

    final result = await GetSizeGroupsUsecase(
      LookupsRepository(),
    ).call(
      params: GetSizeGroupsParams(categoryId: id),
    );

    final groups = result.data ?? [];

    sizeOptions = groups
        .expand((group) => group.sizeOptions)
        .where((size) => size.isActive == true)
        .toList();

    isLoadingSizes = false;
    emit(CreateProductChanged());
  }

  void setBrand(int? id) {
    params.brandId = id;
    emit(CreateProductChanged());
  }

  void setVariantSizeOption(int index, int? sizeOptionId) {
    params.variants[index].sizeOptionId = sizeOptionId;
    emit(CreateProductChanged());
  }

  void addVariant() {
    params.variants.add(
      CreateProductVariantParams(
        color: '',
        sizeOptionId: null,
        quantity: 0,
        sku: null,
        imageUrl: null,
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