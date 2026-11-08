import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';
import '../model/order_model.dart';
import '../repository/order_repository.dart';

class RecordOrderPaymentParams extends BaseParams {
  final String orderId;
  final double amount;

  /// 1 = Cash, 2 = Card, 3 = BankTransfer, 4 = Other
  final int paymentMethod;
  final String? referenceNumber;
  final String? note;

  RecordOrderPaymentParams({
    required this.orderId,
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'paymentMethod': paymentMethod,
      if (referenceNumber != null && referenceNumber!.trim().isNotEmpty)
        'referenceNumber': referenceNumber!.trim(),
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    };
  }
}

class RecordOrderPaymentUsecase
    extends UseCase<OrderModel, RecordOrderPaymentParams> {
  final OrderRepository repository;

  RecordOrderPaymentUsecase(this.repository);

  @override
  Future<Result<OrderModel>> call({required RecordOrderPaymentParams params}) {
    return repository.recordOrderPaymentRequest(params: params);
  }
}
