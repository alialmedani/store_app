/// Sales Summary report response (`GET /api/app/report/sales-summary`).
///
/// NOTE: `status` and `paymentMethod` here are RAW INTEGER enum values
/// (unlike most of the app where they come as `{id,name}`). Map them to
/// labels in the UI via the shared enum-label helpers.
class SalesSummaryModel {
  final double totalRevenue;
  final double totalCollected;
  final int totalOrders;
  final List<SalesSummaryBucket> buckets;
  final List<SalesSummaryStatusBreakdown> byStatus;
  final List<SalesSummaryPaymentMethodBreakdown> byPaymentMethod;

  SalesSummaryModel({
    this.totalRevenue = 0,
    this.totalCollected = 0,
    this.totalOrders = 0,
    this.buckets = const [],
    this.byStatus = const [],
    this.byPaymentMethod = const [],
  });

  factory SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    return SalesSummaryModel(
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
      totalCollected: (json['totalCollected'] as num?)?.toDouble() ?? 0,
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      buckets: (json['buckets'] as List? ?? const [])
          .map((e) =>
              SalesSummaryBucket.fromJson(e as Map<String, dynamic>))
          .toList(),
      byStatus: (json['byStatus'] as List? ?? const [])
          .map((e) =>
              SalesSummaryStatusBreakdown.fromJson(e as Map<String, dynamic>))
          .toList(),
      byPaymentMethod: (json['byPaymentMethod'] as List? ?? const [])
          .map((e) => SalesSummaryPaymentMethodBreakdown.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class SalesSummaryBucket {
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final double revenue;
  final int orderCount;

  SalesSummaryBucket({
    this.periodStart,
    this.periodEnd,
    this.revenue = 0,
    this.orderCount = 0,
  });

  factory SalesSummaryBucket.fromJson(Map<String, dynamic> json) {
    return SalesSummaryBucket(
      periodStart: json['periodStart'] != null
          ? DateTime.tryParse(json['periodStart'])
          : null,
      periodEnd: json['periodEnd'] != null
          ? DateTime.tryParse(json['periodEnd'])
          : null,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
      orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
    );
  }
}

class SalesSummaryStatusBreakdown {
  /// Raw OrderStatus int (1=Draft, 2=Confirmed, 3=Cancelled).
  final int? status;
  final int orderCount;
  final double revenue;

  SalesSummaryStatusBreakdown({
    this.status,
    this.orderCount = 0,
    this.revenue = 0,
  });

  factory SalesSummaryStatusBreakdown.fromJson(Map<String, dynamic> json) {
    return SalesSummaryStatusBreakdown(
      status: (json['status'] as num?)?.toInt(),
      orderCount: (json['orderCount'] as num?)?.toInt() ?? 0,
      revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
    );
  }
}

class SalesSummaryPaymentMethodBreakdown {
  /// Raw PaymentMethod int (1=Cash, 2=Card, 3=BankTransfer, 4=Other).
  final int? paymentMethod;
  final double amount;
  final int paymentCount;

  SalesSummaryPaymentMethodBreakdown({
    this.paymentMethod,
    this.amount = 0,
    this.paymentCount = 0,
  });

  factory SalesSummaryPaymentMethodBreakdown.fromJson(
      Map<String, dynamic> json) {
    return SalesSummaryPaymentMethodBreakdown(
      paymentMethod: (json['paymentMethod'] as num?)?.toInt(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      paymentCount: (json['paymentCount'] as num?)?.toInt() ?? 0,
    );
  }
}
