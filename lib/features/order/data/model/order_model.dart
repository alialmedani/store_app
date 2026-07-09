class OrderModel {
  final String? id;
  final String? orderNumber;
  final String? customerName;
  final String? customerAddress;
  final String? customerPhone;
  final String? note;
  final double? totalAmount;
  final double? paidAmount;
  final double? remainingAmount;
  final String? cancellationReason;
  final DateTime? cancellationTime;
  final DateTime? creationTime;
  final String? creatorId;
  final DateTime? lastModificationTime;
  final String? lastModifierId;
  final bool? isDeleted;
  final String? deleterId;
  final DateTime? deletionTime;

  // Nested objects
  final OrderStatusModel? status;
  final PaymentStatusModel? paymentStatus;

  OrderModel({
    this.id,
    this.orderNumber,
    this.customerName,
    this.customerAddress,
    this.customerPhone,
    this.note,
    this.totalAmount,
    this.paidAmount,
    this.remainingAmount,
    this.cancellationReason,
    this.cancellationTime,
    this.creationTime,
    this.creatorId,
    this.lastModificationTime,
    this.lastModifierId,
    this.isDeleted,
    this.deleterId,
    this.deletionTime,
    this.status,
    this.paymentStatus,
  });

  /// From JSON - Parse API response
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['orderNumber'],
      customerName: json['customerName'],
      customerAddress: json['customerAddress'],
      customerPhone: json['customerPhone'],
      note: json['note'],
      totalAmount: json['totalAmount'] != null
          ? (json['totalAmount'] as num).toDouble()
          : null,
      paidAmount: json['paidAmount'] != null
          ? (json['paidAmount'] as num).toDouble()
          : null,
      remainingAmount: json['remainingAmount'] != null
          ? (json['remainingAmount'] as num).toDouble()
          : null,
      cancellationReason: json['cancellationReason'],
      cancellationTime: json['cancellationTime'] != null
          ? DateTime.parse(json['cancellationTime'])
          : null,
      creationTime: json['creationTime'] != null
          ? DateTime.parse(json['creationTime'])
          : null,
      creatorId: json['creatorId'],
      lastModificationTime: json['lastModificationTime'] != null
          ? DateTime.parse(json['lastModificationTime'])
          : null,
      lastModifierId: json['lastModifierId'],
      isDeleted: json['isDeleted'],
      deleterId: json['deleterId'],
      deletionTime: json['deletionTime'] != null
          ? DateTime.parse(json['deletionTime'])
          : null,
      status: json['status'] != null
          ? OrderStatusModel.fromJson(json['status'])
          : null,
      paymentStatus: json['paymentStatus'] != null
          ? PaymentStatusModel.fromJson(json['paymentStatus'])
          : null,
    );
  }

  /// To JSON - Send to API (for POST/PUT requests if needed)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (orderNumber != null) 'orderNumber': orderNumber,
      if (customerName != null) 'customerName': customerName,
      if (customerAddress != null) 'customerAddress': customerAddress,
      if (customerPhone != null) 'customerPhone': customerPhone,
      if (note != null) 'note': note,
    };
  }
}

/// Order Status nested model
class OrderStatusModel {
  final int? id;
  final String? name;

  OrderStatusModel({this.id, this.name});

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, if (name != null) 'name': name};
  }
}

/// Payment Status nested model
class PaymentStatusModel {
  final int? id;
  final String? name;

  PaymentStatusModel({this.id, this.name});

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, if (name != null) 'name': name};
  }
}
