/// Profit / Margin report response (`GET /api/app/report/profit-margin`).
///
/// IMPORTANT business rules (see CLAUDE.md / feature spec):
/// - `costOfGoodsSold`, `grossProfit`, `marginPercent` are HISTORICAL (cost at
///   time of sale). Never recompute them with today's cost.
/// - `hasCostData == false` → that row's margin is understated; show a
///   "cost data incomplete" badge rather than presenting the % as trustworthy.
/// - `currentCostOfGoodsSold` / `hasCostChangedSinceSale` are INFORMATIONAL
///   only (a footnote); never substitute them into the main profit calc. When
///   `currentCostOfGoodsSold` is null, hide the footnote entirely.
class ProfitMarginModel {
  final List<ProfitMarginItem> items;
  final double totalRevenue;
  final double totalCostOfGoodsSold;
  final double totalGrossProfit;
  final double totalMarginPercent;
  final bool hasCompleteCostData;
  final double? totalCurrentCostOfGoodsSold;
  final bool hasAnyCostChangedSinceSale;

  ProfitMarginModel({
    this.items = const [],
    this.totalRevenue = 0,
    this.totalCostOfGoodsSold = 0,
    this.totalGrossProfit = 0,
    this.totalMarginPercent = 0,
    this.hasCompleteCostData = false,
    this.totalCurrentCostOfGoodsSold,
    this.hasAnyCostChangedSinceSale = false,
  });

  factory ProfitMarginModel.fromJson(Map<String, dynamic> json) {
    return ProfitMarginModel(
      items: (json['items'] as List? ?? const [])
          .map((e) => ProfitMarginItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      totalCostOfGoodsSold:
          (json['totalCostOfGoodsSold'] as num?)?.toDouble() ?? 0,
      totalGrossProfit: (json['totalGrossProfit'] as num?)?.toDouble() ?? 0,
      totalMarginPercent:
          (json['totalMarginPercent'] as num?)?.toDouble() ?? 0,
      hasCompleteCostData: json['hasCompleteCostData'] == true,
      totalCurrentCostOfGoodsSold:
          (json['totalCurrentCostOfGoodsSold'] as num?)?.toDouble(),
      hasAnyCostChangedSinceSale: json['hasAnyCostChangedSinceSale'] == true,
    );
  }
}

class ProfitMarginItem {
  final String? productId;

  /// Only present when grouped by variant.
  final String? productVariantId;
  final String? name;
  final String? color;
  final String? size;
  final int quantitySold;
  final double revenue;

  /// Historical cost at time of sale. Frozen.
  final double costOfGoodsSold;
  final double grossProfit;
  final double marginPercent;

  /// When false, cost data for this row is incomplete and the margin is
  /// understated — do not present the % as trustworthy.
  final bool hasCostData;
  final bool isProductDeleted;
  final bool isVariantDeleted;

  /// Informational only. Null when unavailable (hide the footnote then).
  final double? currentCostOfGoodsSold;
  final bool hasCostChangedSinceSale;

  ProfitMarginItem({
    this.productId,
    this.productVariantId,
    this.name,
    this.color,
    this.size,
    this.quantitySold = 0,
    this.revenue = 0,
    this.costOfGoodsSold = 0,
    this.grossProfit = 0,
    this.marginPercent = 0,
    this.hasCostData = false,
    this.isProductDeleted = false,
    this.isVariantDeleted = false,
    this.currentCostOfGoodsSold,
    this.hasCostChangedSinceSale = false,
  });

  factory ProfitMarginItem.fromJson(Map<String, dynamic> json) {
    return ProfitMarginItem(
      productId: json['productId'],
      productVariantId: json['productVariantId'],
      name: json['name'],
      color: json['color'],
      size: json['size'],
      quantitySold: (json['quantitySold'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      costOfGoodsSold: (json['costOfGoodsSold'] as num?)?.toDouble() ?? 0,
      grossProfit: (json['grossProfit'] as num?)?.toDouble() ?? 0,
      marginPercent: (json['marginPercent'] as num?)?.toDouble() ?? 0,
      hasCostData: json['hasCostData'] == true,
      isProductDeleted: json['isProductDeleted'] == true,
      isVariantDeleted: json['isVariantDeleted'] == true,
      currentCostOfGoodsSold:
          (json['currentCostOfGoodsSold'] as num?)?.toDouble(),
      hasCostChangedSinceSale: json['hasCostChangedSinceSale'] == true,
    );
  }
}
