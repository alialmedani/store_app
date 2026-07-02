part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class UpdateCategoryParams extends CategoryState {}

final class CategoryValidationError extends CategoryState {}
