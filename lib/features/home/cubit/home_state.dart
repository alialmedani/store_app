part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeRefreshChanged extends HomeState {
  final int refreshKey;

  HomeRefreshChanged(this.refreshKey);
}