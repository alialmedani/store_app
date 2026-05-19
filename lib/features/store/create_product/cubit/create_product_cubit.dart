import 'package:bloc/bloc.dart';

import '../../brands/data/repository/brand_repository.dart';
import '../../brands/data/usecase/brand_usecase.dart';
import '../../categories/data/repository/category_repository.dart';
import '../../categories/data/usecase/category_usecase.dart';
import '../../lookups/data/model/lookup_model.dart';
import '../../lookups/data/model/size_group_model.dart';
import '../../lookups/data/repository/lookups_repository.dart';
import '../../lookups/data/usecase/create_size_group_usecase.dart';
import '../../lookups/data/usecase/get_brands_usecase.dart' as lookup_brands;
import '../../lookups/data/usecase/get_categories_usecase.dart'
    as lookup_categories;
import '../../lookups/data/usecase/get_size_groups_usecase.dart';
import '../data/repository/create_product_repository.dart';
import '../data/usecase/create_product_with_variants_usecase.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());

  int currentStep = 0;

  bool isLoadingLookups = false;
  bool isLoadingSizes = false;
  bool isCreatingCategory = false;
  bool isCreatingBrand = false;
  bool isCreatingSizeGroup = false;
  bool isSubmitting = false;

  List<LookupModel> categories = [];
  List<LookupModel> brands = [];
  List<SizeGroupModel> sizeGroups = [];
  List<SizeOptionModel> sizeOptions = [];

  int? selectedSizeGroupId;

  String newCategoryName = '';
  String? newCategoryDescription;

  String newBrandName = '';
  String? newBrandDescription;

  String newSizeGroupName = '';
  String? newSizeGroupDescription;
  String newSizeOptionsText = '';

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

  Future<void> init() async {
    await loadCategoriesAndBrands();
  }

  Future<void> loadCategoriesAndBrands() async {
    isLoadingLookups = true;
    emit(CreateProductChanged());

    final categoriesResult = await lookup_categories.GetCategoriesUsecase(
      LookupsRepository(),
    ).call(params: lookup_categories.GetCategoriesParams());

    final brandsResult = await lookup_brands.GetBrandsUsecase(
      LookupsRepository(),
    ).call(params: lookup_brands.GetBrandsParams());

    categories = categoriesResult.data ?? [];
    brands = brandsResult.data ?? [];

    isLoadingLookups = false;
    emit(CreateProductChanged());
  }

  void setProductName(String value) => params.name = value;

  void setPrice(String value) {
    params.price = double.tryParse(value) ?? 0;
  }

  void setDescription(String value) => params.description = value;

  void setMainImageUrl(String value) => params.imageUrl = value;

  Future<void> setCategory(int? id) async {
    params.categoryId = id;
    selectedSizeGroupId = null;
    sizeGroups = [];
    sizeOptions = [];

    for (final variant in params.variants) {
      variant.sizeOptionId = null;
    }

    emit(CreateProductChanged());

    if (id != null) {
      await loadSizeGroupsByCategory(id);
    }
  }

  void setBrand(int? id) {
    params.brandId = id;
    emit(CreateProductChanged());
  }

  Future<void> createNewCategory() async {
    if (newCategoryName.trim().isEmpty) {
      emit(CreateProductError('Category name is required'));
      return;
    }

    isCreatingCategory = true;
    emit(CreateProductChanged());

    final result = await CreateCategoryUsecase(CategoryRepository()).call(
      params: CreateCategoryParams(
        name: newCategoryName.trim(),
        description: newCategoryDescription,
      ),
    );

    isCreatingCategory = false;

    if (result.hasDataOnly && result.data?.id != null) {
      await loadCategoriesAndBrands();
      await setCategory(result.data!.id);

      currentStep = 2;

      emit(CreateProductChanged());
    } else {
      emit(CreateProductError(result.error.toString()));
    }
  }

  Future<void> createNewBrand() async {
    if (newBrandName.trim().isEmpty) {
      emit(CreateProductError('Brand name is required'));
      return;
    }

    isCreatingBrand = true;
    emit(CreateProductChanged());

    final result = await CreateBrandUsecase(BrandRepository()).call(
      params: CreateBrandParams(
        name: newBrandName.trim(),
        description: newBrandDescription,
      ),
    );

    isCreatingBrand = false;

    if (result.hasDataOnly && result.data?.id != null) {
      await loadCategoriesAndBrands();
      setBrand(result.data!.id);
      emit(CreateProductChanged());
    } else {
      emit(CreateProductError(result.error.toString()));
    }
  }

  Future<void> loadSizeGroupsByCategory(int categoryId) async {
    isLoadingSizes = true;
    emit(CreateProductChanged());

    final result = await GetSizeGroupsUsecase(LookupsRepository()).call(
      params: GetSizeGroupsParams(categoryId: categoryId),
    );

    sizeGroups = result.data ?? [];

    isLoadingSizes = false;
    emit(CreateProductChanged());
  }

  void setSizeGroup(int? id) {
    selectedSizeGroupId = id;

    SizeGroupModel? selectedGroup;

    for (final group in sizeGroups) {
      if (group.id == id) {
        selectedGroup = group;
        break;
      }
    }

    sizeOptions = selectedGroup?.sizeOptions
            .where((size) => size.isActive == true)
            .toList() ??
        [];

    for (final variant in params.variants) {
      variant.sizeOptionId = null;
    }

    emit(CreateProductChanged());
  }

  Future<void> createNewSizeGroup() async {
    if (params.categoryId == null) {
      emit(CreateProductError('Select category first'));
      return;
    }

    if (newSizeGroupName.trim().isEmpty) {
      emit(CreateProductError('Size group name is required'));
      return;
    }

    final options = newSizeOptionsText
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (options.isEmpty) {
      emit(CreateProductError('Size options are required'));
      return;
    }

    isCreatingSizeGroup = true;
    emit(CreateProductChanged());

    final result = await CreateSizeGroupUsecase(LookupsRepository()).call(
      params: CreateSizeGroupParams(
        categoryId: params.categoryId!,
        name: newSizeGroupName.trim(),
        description: newSizeGroupDescription,
        sizeOptions: List.generate(
          options.length,
          (index) => CreateSizeOptionParams(
            name: options[index],
            sortOrder: index + 1,
          ),
        ),
      ),
    );

    isCreatingSizeGroup = false;

    if (result.hasDataOnly && result.data?.id != null) {
      await loadSizeGroupsByCategory(params.categoryId!);
      setSizeGroup(result.data!.id);

      currentStep = 3;

      emit(CreateProductChanged());
    } else {
      emit(CreateProductError(result.error.toString()));
    }
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

  void setVariantColor(int index, String value) {
    params.variants[index].color = value;
  }

  void setVariantSizeOption(int index, int? value) {
    params.variants[index].sizeOptionId = value;
    emit(CreateProductChanged());
  }

  void setVariantQuantity(int index, String value) {
    params.variants[index].quantity = int.tryParse(value) ?? 0;
  }

  void setVariantSku(int index, String value) {
    params.variants[index].sku = value;
  }

  void setVariantImageUrl(int index, String value) {
    params.variants[index].imageUrl = value;
  }

  bool validateStep1() {
    if (params.name.trim().isEmpty) {
      emit(CreateProductError('Product name is required'));
      return false;
    }

    if (params.price <= 0) {
      emit(CreateProductError('Price must be greater than 0'));
      return false;
    }

    return true;
  }

  bool validateStep2() {
    if (params.categoryId == null) {
      emit(CreateProductError('Category is required'));
      return false;
    }

    return true;
  }

  bool validateStep3() {
    if (selectedSizeGroupId == null) {
      emit(CreateProductError('Size group is required'));
      return false;
    }

    if (sizeOptions.isEmpty) {
      emit(CreateProductError('Selected size group has no size options'));
      return false;
    }

    return true;
  }

  bool validateStep4() {
    final seen = <String>{};

    for (final variant in params.variants) {
      if (variant.color.trim().isEmpty) {
        emit(CreateProductError('Variant color is required'));
        return false;
      }

      if (variant.sizeOptionId == null) {
        emit(CreateProductError('Variant size is required'));
        return false;
      }

      if (variant.quantity < 0) {
        emit(CreateProductError('Variant quantity is required'));
        return false;
      }

      final key =
          '${variant.color.trim().toLowerCase()}-${variant.sizeOptionId}';

      if (seen.contains(key)) {
        emit(CreateProductError('Duplicate color + size is not allowed'));
        return false;
      }

      seen.add(key);
    }

    return true;
  }

  void nextStep() {
    final canContinue = switch (currentStep) {
      0 => validateStep1(),
      1 => validateStep2(),
      2 => validateStep3(),
      3 => validateStep4(),
      _ => false,
    };

    if (!canContinue) return;

    if (currentStep < 3) {
      currentStep++;
      emit(CreateProductChanged());
    }
  }

  void previousStep() {
    if (currentStep == 0) return;

    currentStep--;
    emit(CreateProductChanged());
  }

  Future<void> submit() async {
    if (!validateStep1() ||
        !validateStep2() ||
        !validateStep3() ||
        !validateStep4()) {
      return;
    }

    isSubmitting = true;
    emit(CreateProductChanged());

    final result = await CreateProductWithVariantsUsecase(
      CreateProductRepository(),
    ).call(params: params);

    isSubmitting = false;

    if (result.hasDataOnly) {
      emit(CreateProductSuccess(result.data));
    } else {
      emit(CreateProductError(result.error.toString()));
    }
  }
}