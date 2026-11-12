import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../core/boilerplate/pagination/models/get_list_request.dart';
import '../../../core/results/result.dart';
import '../../product_variant/data/model/product_variant_model.dart';
import '../../product_variant/data/repository/product_variant_repository.dart';
import '../../product_variant/data/usecase/get_product_variant_list_usecase.dart';

part 'add_product_dialog_state.dart';

/// A single line the user has staged into the tray but not yet committed to
/// the order. Collapse-merged by [variantId] (staging the same variant twice
/// just bumps [quantity]).
class StagedEntry {
  final String variantId;
  final String label;
  int quantity;

  StagedEntry({
    required this.variantId,
    required this.label,
    required this.quantity,
  });
}

/// UI-only state for the "catalog + tray" add-product sheet.
///
/// Holds the active category filter, which product row is expanded, the
/// in-progress colour/size/quantity selection for that row, a per-product
/// cache of fetched variants, and the staged tray. Variant fetching goes
/// through [fetchVariantsCached] which returns `Future<Result<...>>` and never
/// emits Loading/Success/Error (CLAUDE.md rule 3); only UI state is emitted.
class AddProductDialogCubit extends Cubit<AddProductDialogState> {
  AddProductDialogCubit() : super(AddProductDialogInitial());

  /// null => "all" (no category filter).
  String? selectedCategoryId;

  /// Committed free-text search (backend-supported product `Filter`).
  String searchQuery = '';

  /// True while the staged tray is being committed to the order (guards
  /// against a double-tap firing the per-entry network calls twice).
  bool committing = false;

  /// The product whose variants are expanded in place. null => none expanded.
  String? expandedProductId;
  bool variantsLoading = false;
  String? variantsError;

  /// In-progress selection inside the currently expanded product.
  String? selectedColor;
  String? selectedSize;
  int stagingQuantity = 1;

  /// Staged (uncommitted) tray lines + its expanded/collapsed UI toggle.
  final List<StagedEntry> staged = [];
  bool trayExpanded = false;

  final Map<String, List<ProductVariantModel>> _variantCache = {};

  int get stagedQuantityTotal =>
      staged.fold(0, (sum, e) => sum + e.quantity);

  List<ProductVariantModel>? variantsFor(String productId) =>
      _variantCache[productId];

  // --------------------------------------------------------------------------
  // Category filter
  // --------------------------------------------------------------------------
  void selectCategory(String? categoryId) {
    if (selectedCategoryId == categoryId) return;
    selectedCategoryId = categoryId;
    _collapseExpansion();
    emit(AddProductDialogChanged());
  }

  void setSearch(String query) {
    final trimmed = query.trim();
    if (searchQuery == trimmed) return;
    searchQuery = trimmed;
    _collapseExpansion();
    emit(AddProductDialogChanged());
  }

  void setCommitting(bool value) {
    committing = value;
    emit(AddProductDialogChanged());
  }

  // --------------------------------------------------------------------------
  // Expand / collapse a product row (lazy, cached variant fetch)
  // --------------------------------------------------------------------------
  Future<void> toggleExpand(String productId) async {
    if (expandedProductId == productId) {
      _collapseExpansion();
      emit(AddProductDialogChanged());
      return;
    }

    expandedProductId = productId;
    selectedColor = null;
    selectedSize = null;
    stagingQuantity = 1;
    variantsError = null;

    if (_variantCache.containsKey(productId)) {
      variantsLoading = false;
      emit(AddProductDialogChanged());
      return;
    }

    variantsLoading = true;
    emit(AddProductDialogChanged());

    final result = await fetchVariantsCached(productId);
    // Ignore if the user collapsed / expanded something else meanwhile.
    if (isClosed || expandedProductId != productId) return;

    variantsLoading = false;
    if (result.hasDataOnly) {
      variantsError = null;
    } else {
      variantsError = result.error;
    }
    emit(AddProductDialogChanged());
  }

  void _collapseExpansion() {
    expandedProductId = null;
    selectedColor = null;
    selectedSize = null;
    stagingQuantity = 1;
    variantsLoading = false;
    variantsError = null;
  }

  /// Cached-fetch wrapper. Returns the cached list without a network call when
  /// a product's variants were already loaded; otherwise fetches once and
  /// caches on success. API method: returns `Future<Result<...>>`, no emit.
  Future<Result<List<ProductVariantModel>>> fetchVariantsCached(
    String productId,
  ) async {
    final cached = _variantCache[productId];
    if (cached != null) return Result(data: cached);

    final result = await GetProductVariantListUsecase(
      ProductVariantRepository(),
    ).call(
      params: GetProductVariantListParams(
        request: GetListRequest(skip: 0, take: 1000),
        productId: productId,
      ),
    );

    if (result.hasDataOnly) {
      _variantCache[productId] = result.data ?? const [];
    }
    return result;
  }

  // --------------------------------------------------------------------------
  // Colour / size / quantity selection inside the expanded product
  // --------------------------------------------------------------------------

  /// Distinct non-empty colours for the expanded product (empty => no colour
  /// dimension, so the colour row is skipped entirely).
  List<String> get availableColors {
    final list = _variantCache[expandedProductId] ?? const [];
    final seen = <String>[];
    for (final v in list) {
      final c = v.color;
      if (c != null && c.isNotEmpty && !seen.contains(c)) seen.add(c);
    }
    return seen;
  }

  /// Distinct sizes available for the current colour selection (or across all
  /// variants when there is no colour dimension). Empty => no size dimension.
  List<String> get availableSizes {
    final list = _variantCache[expandedProductId] ?? const [];
    final hasColor = availableColors.isNotEmpty;
    final seen = <String>[];
    for (final v in list) {
      if (hasColor && v.color != selectedColor) continue;
      final s = v.size;
      if (s != null && s.isNotEmpty && !seen.contains(s)) seen.add(s);
    }
    return seen;
  }

  /// The variant matching a (colour, size) within the expanded product, or
  /// null when the chosen combination is ambiguous / incomplete.
  ProductVariantModel? variantForSize(String size) {
    final list = _variantCache[expandedProductId] ?? const [];
    final hasColor = availableColors.isNotEmpty;
    final matches = list.where((v) {
      final colorOk = !hasColor || v.color == selectedColor;
      return colorOk && v.size == size;
    });
    return matches.isEmpty ? null : matches.first;
  }

  /// The single variant the current selection resolves to, if any.
  ///
  /// When a product has exactly one variant total there is no real colour/size
  /// choice, so that one variant is returned directly (the UI skips swatches
  /// and shows the stepper straight away).
  ProductVariantModel? get resolvedVariant {
    final list = _variantCache[expandedProductId] ?? const [];
    if (list.isEmpty) return null;
    if (list.length == 1) return list.first;

    final hasColor = availableColors.isNotEmpty;
    final hasSize = availableSizes.isNotEmpty ||
        list.any((v) => (v.size ?? '').isNotEmpty);

    final matches = list.where((v) {
      final colorOk = !hasColor || v.color == selectedColor;
      final sizeOk = !hasSize || v.size == selectedSize;
      return colorOk && sizeOk;
    }).toList();
    return matches.length == 1 ? matches.first : null;
  }

  void selectColor(String color) {
    selectedColor = color;
    selectedSize = null;
    stagingQuantity = 1;
    emit(AddProductDialogChanged());
  }

  void selectSize(String size) {
    selectedSize = size;
    stagingQuantity = 1;
    emit(AddProductDialogChanged());
  }

  void changeStagingQuantity(int delta) {
    final next = stagingQuantity + delta;
    if (next < 1) return;
    final stock = resolvedVariant?.stockQuantity;
    if (stock != null && next > stock) return;
    stagingQuantity = next;
    emit(AddProductDialogChanged());
  }

  // --------------------------------------------------------------------------
  // Tray
  // --------------------------------------------------------------------------

  /// Stage the currently resolved variant into the tray, then collapse the row.
  void stageResolved(String label) {
    final variant = resolvedVariant;
    final id = variant?.id;
    if (id == null) return;

    final index = staged.indexWhere((e) => e.variantId == id);
    if (index >= 0) {
      staged[index].quantity += stagingQuantity;
    } else {
      staged.add(
        StagedEntry(variantId: id, label: label, quantity: stagingQuantity),
      );
    }
    _collapseExpansion();
    emit(AddProductDialogChanged());
  }

  void removeStaged(String variantId) {
    staged.removeWhere((e) => e.variantId == variantId);
    if (staged.isEmpty) trayExpanded = false;
    emit(AddProductDialogChanged());
  }

  void toggleTray() {
    if (staged.isEmpty) return;
    trayExpanded = !trayExpanded;
    emit(AddProductDialogChanged());
  }
}
