import 'package:bloc/bloc.dart';

import '../../../../core/results/result.dart';
import '../data/model/brand_model.dart';
import '../data/repository/brand_repository.dart';
import '../data/usecase/brand_usecase.dart';

part 'brands_state.dart';

class BrandsCubit extends Cubit<BrandsState> {
  BrandsCubit() : super(BrandsInitial());

  int refreshKey = 0;

  CreateBrandParams createParams = CreateBrandParams(
    name: '',
    description: null,
  );

  UpdateBrandParams? updateParams;

  Future<Result> fetchBrands() async {
    return await GetBrandsUsecase(
      BrandRepository(),
    ).call(params: GetBrandsParams());
  }

  Future<Result> fetchBrandById(int id) async {
    return await GetBrandByIdUsecase(
      BrandRepository(),
    ).call(params: GetBrandByIdParams(id: id));
  }

  Future<Result<dynamic>> createBrand() async {
    return await CreateBrandUsecase(
      BrandRepository(),
    ).call(params: createParams);
  }

  Future<Result<dynamic>> updateBrand() async {
    return await UpdateBrandUsecase(
      BrandRepository(),
    ).call(params: updateParams!);
  }

  Future<Result<dynamic>> deleteBrand(int id) async {
    return await DeleteBrandUsecase(
      BrandRepository(),
    ).call(params: BrandActionParams(id: id));
  }

  Future<Result<dynamic>> activateBrand(int id) async {
    return await ActivateBrandUsecase(
      BrandRepository(),
    ).call(params: BrandActionParams(id: id));
  }

  Future<Result<dynamic>> deactivateBrand(int id) async {
    return await DeactivateBrandUsecase(
      BrandRepository(),
    ).call(params: BrandActionParams(id: id));
  }

  void refreshBrands() {
    refreshKey++;
    emit(BrandsChanged());
  }

  void resetCreateParams() {
    createParams = CreateBrandParams(
      name: '',
      description: null,
    );
  }

  void setUpdateParams(BrandModel brand) {
    updateParams = UpdateBrandParams(
      id: brand.id!,
      name: brand.name ?? '',
      description: brand.description,
    );
  }
}