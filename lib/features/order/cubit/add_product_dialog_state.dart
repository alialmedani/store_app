part of 'add_product_dialog_cubit.dart';

@immutable
sealed class AddProductDialogState {}

final class AddProductDialogInitial extends AddProductDialogState {}

/// Single marker emitted whenever any UI-only state of the picker changes
/// (active category filter, expanded product, colour/size selection, staging
/// quantity, the staged tray). Per CLAUDE.md rule 3 this is UI state only -
/// the catalog data itself is loaded by PaginationList / the cached-fetch
/// wrapper, never by emitting Loading/Success/Error here.
final class AddProductDialogChanged extends AddProductDialogState {}
