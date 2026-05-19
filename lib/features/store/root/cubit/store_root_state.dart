part of 'store_root_cubit.dart';

abstract class StoreRootState {}

class StoreRootInitial extends StoreRootState {}

class StoreRootTabChanged extends StoreRootState {
  final int index;

  StoreRootTabChanged(this.index);
}
