import 'package:bloc/bloc.dart';
part 'store_root_state.dart';

class StoreRootCubit extends Cubit<StoreRootState> {
  StoreRootCubit() : super(StoreRootInitial());

  int currentIndex = 0;

  void changeTab(int index) {
    currentIndex = index;
    emit(StoreRootTabChanged(index));
  }
}