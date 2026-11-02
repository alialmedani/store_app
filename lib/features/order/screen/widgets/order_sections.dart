import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/ui/dialogs/action_helpers.dart';
import '../../../../core/ui/dialogs/dialogs.dart';
import '../../cubit/order_cubit.dart';
import '../../data/model/order_model.dart';
import '../../data/usecase/record_order_payment_usecase.dart';
import 'add_product_dialog.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

String _money(double value) => '\$${value.toStringAsFixed(2)}';

fw.Widget _sectionTitle(String text, ThemeData theme) => AppSectionTitle(text);

/// Items card: lists order lines. When the order is a draft the lines can be
/// edited / removed and new items can be added.
class OrderItemsSection extends fw.StatelessWidget {
  final OrderModel order;
  final ThemeData theme;
  final fw.VoidCallback onChanged;

  const OrderItemsSection({
    super.key,
    required this.order,
    required this.theme,
    required this.onChanged,
  });

  bool get _isDraft => order.status?.id == 1;

  @override
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final orderId = order.id ?? '';

    return Card(
      child: fw.Container(
        width: double.infinity,
        padding: const fw.EdgeInsets.all(20),
        child: fw.Column(
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            fw.Row(
              children: [
                fw.Expanded(child: _sectionTitle('items'.tr(), theme)),
                if (_isDraft)
                  OutlineButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AddProductDialog(
                          onItemAdded: (variantId, quantity) async {
                            final ok = await runRemoteAction(
                              () => cubit.addOrderItemToOrder(
                                orderId,
                                variantId,
                                quantity,
                              ),
                              successMessage: 'item_added'.tr(),
                            );
                            if (ok) onChanged();
                          },
                        ),
                      );
                    },
                    child: Text('add_item_2'.tr()),
                  ),
              ],
            ),
            const fw.SizedBox(height: 16),
            if (order.items.isEmpty)
              Text(
                'no_items_in_this_order'.tr(),
                style: fw.TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.mutedForeground,
                ),
              )
            else
              ...order.items.map(
                (item) => fw.Padding(
                  padding: const fw.EdgeInsets.only(bottom: 12),
                  child: _ItemRow(
                    item: item,
                    theme: theme,
                    canEdit: _isDraft,
                    onEdit: () => _showQuantityDialog(
                      context,
                      cubit,
                      orderId,
                      item,
                    ),
                    onRemove: () => showConfirmDialog(
                      context,
                      title: 'remove_item'.tr(),
                      message: 'remove_item_confirm'.tr(args: ['${item.productName ?? 'this_item'.tr()}']),
                      confirmLabel: 'remove'.tr(),
                      destructive: true,
                      onConfirm: () async {
                        final ok = await runRemoteAction(
                          () => cubit.removeOrderItemFromOrder(
                            orderId,
                            item.id ?? '',
                          ),
                          successMessage: 'item_removed'.tr(),
                        );
                        if (ok) onChanged();
                      },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(
    fw.BuildContext context,
    OrderCubit cubit,
    String orderId,
    OrderItemModel item,
  ) {
    final controller = fw.TextEditingController(text: '${item.quantity}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('change_quantity'.tr()),
        content: fw.Column(
          mainAxisSize: fw.MainAxisSize.min,
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            Text(
              '${item.productName ?? ''} (${item.color ?? ''} / ${item.size ?? ''})',
            ),
            const fw.SizedBox(height: 12),
            TextField(
              controller: controller,
              placeholder: Text('quantity_2'.tr()),
              keyboardType: const fw.TextInputType.numberWithOptions(
                decimal: false,
              ),
            ),
          ],
        ),
        actions: [
          OutlineButton(
            onPressed: () => fw.Navigator.pop(ctx),
            child: Text('cancel'.tr()),
          ),
          PrimaryButton(
            onPressed: () async {
              final quantity = int.tryParse(controller.text.trim()) ?? 0;
              if (quantity <= 0) {
                Dialogs.showSnackBar(
                  message: 'quantity_must_be_greater_than_0'.tr(),
                  typeSnackBar: AnimatedSnackBarType.error,
                );
                return;
              }
              fw.Navigator.pop(ctx);
              final ok = await runRemoteAction(
                () => cubit.changeOrderItemQuantity(
                  orderId,
                  item.id ?? '',
                  quantity,
                ),
                successMessage: 'quantity_updated'.tr(),
              );
              if (ok) onChanged();
            },
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends fw.StatelessWidget {
  final OrderItemModel item;
  final ThemeData theme;
  final bool canEdit;
  final fw.VoidCallback onEdit;
  final fw.VoidCallback onRemove;

  const _ItemRow({
    required this.item,
    required this.theme,
    required this.canEdit,
    required this.onEdit,
    required this.onRemove,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        fw.Expanded(
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              Text(
                item.productName ?? 'N/A',
                style: const fw.TextStyle(
                  fontSize: 14,
                  fontWeight: fw.FontWeight.w600,
                ),
              ),
              const fw.SizedBox(height: 2),
              Text(
                '${item.color ?? ''} / ${item.size ?? ''}',
                style: fw.TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              const fw.SizedBox(height: 2),
              Text(
                '${item.quantity} x ${_money(item.unitPrice)} = '
                '${_money(item.lineTotal)}',
                style: const fw.TextStyle(
                  fontSize: 13,
                  fontWeight: fw.FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        if (canEdit) ...[
          IconButton(
            icon: const Icon(Icons.edit, size: 18),
            onPressed: onEdit,
            variance: ButtonVariance.ghost,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18),
            onPressed: onRemove,
            variance: ButtonVariance.ghost,
          ),
        ],
      ],
    );
  }
}

/// Payments card: list of recorded payments (hidden when there are none).
class OrderPaymentsSection extends fw.StatelessWidget {
  final OrderModel order;
  final ThemeData theme;

  const OrderPaymentsSection({
    super.key,
    required this.order,
    required this.theme,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    if (order.payments.isEmpty) return const fw.SizedBox.shrink();

    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: 16),
      child: Card(
        child: fw.Container(
          width: double.infinity,
          padding: const fw.EdgeInsets.all(20),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              _sectionTitle('payments'.tr(), theme),
              const fw.SizedBox(height: 16),
              ...order.payments.map(
                (payment) => fw.Padding(
                  padding: const fw.EdgeInsets.only(bottom: 12),
                  child: fw.Row(
                    crossAxisAlignment: fw.CrossAxisAlignment.start,
                    children: [
                      fw.Expanded(
                        child: fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment.paymentMethodName ?? 'payment'.tr(),
                              style: const fw.TextStyle(
                                fontSize: 14,
                                fontWeight: fw.FontWeight.w600,
                              ),
                            ),
                            if (payment.paymentDate != null)
                              Text(
                                _formatDate(payment.paymentDate!),
                                style: fw.TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            if (payment.referenceNumber != null &&
                                payment.referenceNumber!.isNotEmpty)
                              Text(
                                'ref'.tr(args: ['${payment.referenceNumber}']),
                                style: fw.TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            if (payment.note != null &&
                                payment.note!.isNotEmpty)
                              Text(
                                payment.note!,
                                style: fw.TextStyle(
                                  fontSize: 12,
                                  fontStyle: fw.FontStyle.italic,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Text(
                        _money(payment.amount),
                        style: const fw.TextStyle(
                          fontSize: 15,
                          fontWeight: fw.FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.year}-$month-$day $hour:$minute';
  }
}

/// Actions card: confirm / pay / cancel / delete depending on the status.
class OrderActionsSection extends fw.StatelessWidget {
  final OrderModel order;
  final ThemeData theme;
  final fw.VoidCallback onChanged;

  /// Called after the order was deleted (screen should close).
  final fw.VoidCallback onDeleted;

  const OrderActionsSection({
    super.key,
    required this.order,
    required this.theme,
    required this.onChanged,
    required this.onDeleted,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final orderId = order.id ?? '';
    final statusId = order.status?.id;
    final remaining = order.remainingAmount ?? 0;
    final paid = order.paidAmount ?? 0;

    final buttons = <fw.Widget>[];

    if (statusId == 1) {
      buttons.add(
        PrimaryButton(
          onPressed: () => showConfirmDialog(
            context,
            title: 'confirm_order'.tr(),
            message: 'confirm_order_message'.tr(),
            confirmLabel: 'confirm'.tr(),
            onConfirm: () async {
              final ok = await runRemoteAction(
                () => cubit.confirmOrder(orderId),
                successMessage: 'order_confirmed'.tr(),
              );
              if (ok) onChanged();
            },
          ),
          child: Text('confirm_order'.tr()),
        ),
      );
      buttons.add(
        DestructiveButton(
          onPressed: () => showConfirmDialog(
            context,
            title: 'delete_order'.tr(),
            message: 'delete_this_draft_order_permanently'.tr(),
            confirmLabel: 'delete'.tr(),
            destructive: true,
            onConfirm: () async {
              final ok = await runRemoteAction(
                () => cubit.deleteOrder(orderId),
                successMessage: 'order_deleted'.tr(),
              );
              if (ok) onDeleted();
            },
          ),
          child: Text('delete_order'.tr()),
        ),
      );
    } else if (statusId == 2) {
      if (remaining > 0) {
        buttons.add(
          PrimaryButton(
            onPressed: () => _showPaymentDialog(
              context,
              cubit,
              orderId,
              remaining,
            ),
            child: Text('record_payment'.tr()),
          ),
        );
      }
      if (paid <= 0) {
        buttons.add(
          DestructiveButton(
            onPressed: () => _showCancelDialog(context, cubit, orderId),
            child: Text('cancel_order'.tr()),
          ),
        );
      }
    }

    if (buttons.isEmpty) return const fw.SizedBox.shrink();

    return fw.Padding(
      padding: const fw.EdgeInsets.only(bottom: 16),
      child: Card(
        child: fw.Container(
          width: double.infinity,
          padding: const fw.EdgeInsets.all(20),
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.stretch,
            children: [
              _sectionTitle('actions'.tr(), theme),
              const fw.SizedBox(height: 16),
              for (var i = 0; i < buttons.length; i++) ...[
                if (i > 0) const fw.SizedBox(height: 12),
                buttons[i],
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(
    fw.BuildContext context,
    OrderCubit cubit,
    String orderId,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => _CancelOrderDialog(
        onSubmit: (reason) async {
          final ok = await runRemoteAction(
            () => cubit.cancelOrder(orderId, reason),
            successMessage: 'order_cancelled'.tr(),
          );
          if (ok) onChanged();
        },
      ),
    );
  }

  void _showPaymentDialog(
    fw.BuildContext context,
    OrderCubit cubit,
    String orderId,
    double remaining,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => _RecordPaymentDialog(
        remaining: remaining,
        onSubmit: (params) async {
          final ok = await runRemoteAction(
            () => cubit.recordOrderPayment(
              RecordOrderPaymentParams(
                orderId: orderId,
                amount: params.amount,
                paymentMethod: params.paymentMethod,
                referenceNumber: params.referenceNumber,
                note: params.note,
              ),
            ),
            successMessage: 'payment_recorded'.tr(),
          );
          if (ok) onChanged();
        },
      ),
    );
  }
}

class _CancelOrderDialog extends fw.StatefulWidget {
  final Future<void> Function(String reason) onSubmit;

  const _CancelOrderDialog({required this.onSubmit});

  @override
  fw.State<_CancelOrderDialog> createState() => _CancelOrderDialogState();
}

class _CancelOrderDialogState extends fw.State<_CancelOrderDialog> {
  final _reasonController = fw.TextEditingController();
  String? _error;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return AlertDialog(
      title: Text('cancel_order'.tr()),
      content: fw.Column(
        mainAxisSize: fw.MainAxisSize.min,
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          Text('stock_will_be_returned_please_enter_a'.tr()),
          const fw.SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            placeholder: Text('cancellation_reason'.tr()),
            maxLines: 3,
            onChanged: (_) {
              if (_error != null) setState(() => _error = null);
            },
          ),
          if (_error != null)
            fw.Padding(
              padding: const fw.EdgeInsets.only(top: 4),
              child: Text(
                _error!,
                style: fw.TextStyle(
                  color: AppDesignTokens.dangerColor,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
      actions: [
        OutlineButton(
          onPressed: () => fw.Navigator.pop(context),
          child: Text('back'.tr()),
        ),
        DestructiveButton(
          onPressed: () {
            final reason = _reasonController.text.trim();
            if (reason.isEmpty) {
              setState(() => _error = 'reason_is_required'.tr());
              return;
            }
            fw.Navigator.pop(context);
            widget.onSubmit(reason);
          },
          child: Text('cancel_order'.tr()),
        ),
      ],
    );
  }
}

class _PaymentInput {
  final double amount;
  final int paymentMethod;
  final String? referenceNumber;
  final String? note;

  _PaymentInput({
    required this.amount,
    required this.paymentMethod,
    this.referenceNumber,
    this.note,
  });
}

class _RecordPaymentDialog extends fw.StatefulWidget {
  final double remaining;
  final Future<void> Function(_PaymentInput input) onSubmit;

  const _RecordPaymentDialog({required this.remaining, required this.onSubmit});

  @override
  fw.State<_RecordPaymentDialog> createState() => _RecordPaymentDialogState();
}

class _RecordPaymentDialogState extends fw.State<_RecordPaymentDialog> {
  static Map<int, String> get _methods => <int, String>{
    1: 'cash'.tr(),
    2: 'card'.tr(),
    3: 'bank_transfer'.tr(),
    4: 'other'.tr(),
  };

  late final fw.TextEditingController _amountController;
  final _referenceController = fw.TextEditingController();
  final _noteController = fw.TextEditingController();
  int _method = 1;
  String? _error;

  @override
  void initState() {
    super.initState();
    _amountController = fw.TextEditingController(
      text: widget.remaining.toStringAsFixed(2),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'enter_a_valid_amount'.tr());
      return;
    }
    if (amount > widget.remaining) {
      setState(
        () => _error = 'amount_exceeds_remaining'.tr(args: ['${_money(widget.remaining)}']),
      );
      return;
    }
    // The API accepts at most two decimal places
    final rounded = double.parse(amount.toStringAsFixed(2));
    fw.Navigator.pop(context);
    widget.onSubmit(
      _PaymentInput(
        amount: rounded,
        paymentMethod: _method,
        referenceNumber: _referenceController.text,
        note: _noteController.text,
      ),
    );
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return AlertDialog(
      title: Text('record_payment'.tr()),
      content: fw.SingleChildScrollView(
        child: fw.Column(
          mainAxisSize: fw.MainAxisSize.min,
          crossAxisAlignment: fw.CrossAxisAlignment.start,
          children: [
            Text('remaining'.tr(args: ['${_money(widget.remaining)}'])),
            const fw.SizedBox(height: 12),
            Text(
              'amount'.tr(),
              style: fw.TextStyle(fontWeight: fw.FontWeight.w600),
            ),
            const fw.SizedBox(height: 6),
            TextField(
              controller: _amountController,
              placeholder: Text('amount'.tr()),
              keyboardType: const fw.TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) {
                if (_error != null) setState(() => _error = null);
              },
            ),
            if (_error != null)
              fw.Padding(
                padding: const fw.EdgeInsets.only(top: 4),
                child: Text(
                  _error!,
                  style: fw.TextStyle(
                    color: AppDesignTokens.dangerColor,
                    fontSize: 12,
                  ),
                ),
              ),
            const fw.SizedBox(height: 12),
            Text(
              'payment_method'.tr(),
              style: fw.TextStyle(fontWeight: fw.FontWeight.w600),
            ),
            const fw.SizedBox(height: 6),
            fw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _methods.entries.map((entry) {
                final selected = _method == entry.key;
                void select() => setState(() => _method = entry.key);
                return selected
                    ? PrimaryButton(
                        onPressed: select,
                        child: Text(entry.value),
                      )
                    : OutlineButton(
                        onPressed: select,
                        child: Text(entry.value),
                      );
              }).toList(),
            ),
            const fw.SizedBox(height: 12),
            Text(
              'reference_number_optional'.tr(),
              style: fw.TextStyle(fontWeight: fw.FontWeight.w600),
            ),
            const fw.SizedBox(height: 6),
            TextField(
              controller: _referenceController,
              placeholder: Text('reference_number'.tr()),
            ),
            const fw.SizedBox(height: 12),
            Text(
              'note_optional_2'.tr(),
              style: fw.TextStyle(fontWeight: fw.FontWeight.w600),
            ),
            const fw.SizedBox(height: 6),
            TextField(
              controller: _noteController,
              placeholder: Text('note'.tr()),
              maxLines: 2,
            ),
          ],
        ),
      ),
      actions: [
        OutlineButton(
          onPressed: () => fw.Navigator.pop(context),
          child: Text('back'.tr()),
        ),
        PrimaryButton(onPressed: _submit, child: Text('record'.tr())),
      ],
    );
  }
}
