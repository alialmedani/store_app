/// One row of the Stock Movement Audit report
/// (`GET /api/app/report/stock-movements`, paged).
///
/// `reason` and `sourceType` are nested `{id,name}` lookups (same shape used
/// elsewhere in the app). `reason` is actually the StockMovementType lookup
/// (id = StockMovementType int, name = raw C# enum name).
class StockMovementReportModel {
  final String? id;
  final DateTime? date;
  final String? productVariantId;
  final String? productVariantName;
  final int oldQuantity;
  final int change;
  final int newQuantity;
  final ReportLookup? reason;
  final ReportLookup? sourceType;
  final String? referenceId;
  final String? note;
  final bool isProductDeleted;
  final bool isVariantDeleted;

  StockMovementReportModel({
    this.id,
    this.date,
    this.productVariantId,
    this.productVariantName,
    this.oldQuantity = 0,
    this.change = 0,
    this.newQuantity = 0,
    this.reason,
    this.sourceType,
    this.referenceId,
    this.note,
    this.isProductDeleted = false,
    this.isVariantDeleted = false,
  });

  factory StockMovementReportModel.fromJson(Map<String, dynamic> json) {
    return StockMovementReportModel(
      id: json['id'],
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      productVariantId: json['productVariantId'],
      productVariantName: json['productVariantName'],
      oldQuantity: (json['oldQuantity'] as num?)?.toInt() ?? 0,
      change: (json['change'] as num?)?.toInt() ?? 0,
      newQuantity: (json['newQuantity'] as num?)?.toInt() ?? 0,
      reason: json['reason'] is Map
          ? ReportLookup.fromJson(json['reason'])
          : null,
      sourceType: json['sourceType'] is Map
          ? ReportLookup.fromJson(json['sourceType'])
          : null,
      referenceId: json['referenceId'],
      note: json['note'],
      isProductDeleted: json['isProductDeleted'] == true,
      isVariantDeleted: json['isVariantDeleted'] == true,
    );
  }
}

/// Nested `{id,name}` lookup used by report rows.
class ReportLookup {
  final int? id;
  final String? name;

  ReportLookup({this.id, this.name});

  factory ReportLookup.fromJson(Map<String, dynamic> json) {
    return ReportLookup(id: (json['id'] as num?)?.toInt(), name: json['name']);
  }
}
