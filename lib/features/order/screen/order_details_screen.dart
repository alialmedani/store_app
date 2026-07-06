import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../cubit/order_cubit.dart';
import '../data/model/order_model.dart';

/// Order Details Screen - Shows full details of a single order
/// Uses GetModel widget from boilerplate to handle loading/success/error states
class OrderDetailsScreen extends fw.StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => OrderCubit(),
      child: Scaffold(
        child: SafeArea(
          child: fw.Column(
            children: [
              // App Bar
              fw.Container(
                padding: const fw.EdgeInsets.fromLTRB(16, 16, 20, 20),
                decoration: fw.BoxDecoration(
                  color: theme.colorScheme.background,
                  border: fw.Border(
                    bottom: fw.BorderSide(
                      color: theme.colorScheme.border.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: fw.Row(
                  children: [
                    fw.Container(
                      decoration: fw.BoxDecoration(
                        color: theme.colorScheme.muted.withOpacity(0.3),
                        borderRadius: fw.BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20),
                        onPressed: () => fw.Navigator.pop(context),
                        variance: ButtonVariance.ghost,
                      ),
                    ),
                    const fw.SizedBox(width: 12),
                    const fw.Expanded(
                      child: Text(
                        'Order Details',
                        style: fw.TextStyle(
                          fontSize: 24,
                          fontWeight: fw.FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              fw.Expanded(
                child: GetModel<OrderModel>(
                  useCaseCallBack: () =>
                      context.read<OrderCubit>().getOrderDetails(orderId),
                  modelBuilder: (order) {
                    return fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(20),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Order Number Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Order Number',
                                    style: fw.TextStyle(
                                      fontSize: 12,
                                      fontWeight: fw.FontWeight.w600,
                                      color: theme.colorScheme.mutedForeground,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 8),
                                  Text(
                                    order.orderNumber ?? 'N/A',
                                    style: fw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: fw.FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Customer Information Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CUSTOMER INFORMATION',
                                    style: fw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: fw.FontWeight.w700,
                                      color: theme.colorScheme.mutedForeground,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 16),
                                  _InfoRow(
                                    icon: Icons.person_outline,
                                    label: 'Name',
                                    value: order.customerName ?? 'N/A',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _InfoRow(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone',
                                    value: order.customerPhone ?? 'N/A',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _InfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: 'Address',
                                    value: order.customerAddress ?? 'N/A',
                                    theme: theme,
                                  ),
                                  if (order.note != null &&
                                      order.note!.isNotEmpty) ...[
                                    const fw.SizedBox(height: 12),
                                    _InfoRow(
                                      icon: Icons.note_outlined,
                                      label: 'Note',
                                      value: order.note!,
                                      theme: theme,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Status Information Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'STATUS',
                                    style: fw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: fw.FontWeight.w700,
                                      color: theme.colorScheme.mutedForeground,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 16),
                                  fw.Row(
                                    children: [
                                      if (order.status != null)
                                        fw.Expanded(
                                          child: fw.Container(
                                            padding:
                                                const fw.EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                            decoration: fw.BoxDecoration(
                                              color: theme.colorScheme.primary
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  fw.BorderRadius.circular(12),
                                            ),
                                            child: fw.Column(
                                              crossAxisAlignment:
                                                  fw.CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Order Status',
                                                  style: fw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        fw.FontWeight.w600,
                                                    color: theme
                                                        .colorScheme
                                                        .mutedForeground,
                                                  ),
                                                ),
                                                const fw.SizedBox(height: 4),
                                                Text(
                                                  order.status!.name ?? 'N/A',
                                                  style: fw.TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        fw.FontWeight.w700,
                                                    color: theme
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      const fw.SizedBox(width: 12),
                                      if (order.paymentStatus != null)
                                        fw.Expanded(
                                          child: fw.Container(
                                            padding:
                                                const fw.EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 12,
                                                ),
                                            decoration: fw.BoxDecoration(
                                              color: theme.colorScheme.secondary
                                                  .withOpacity(0.12),
                                              borderRadius:
                                                  fw.BorderRadius.circular(12),
                                            ),
                                            child: fw.Column(
                                              crossAxisAlignment:
                                                  fw.CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Payment',
                                                  style: fw.TextStyle(
                                                    fontSize: 10,
                                                    fontWeight:
                                                        fw.FontWeight.w600,
                                                    color: theme
                                                        .colorScheme
                                                        .mutedForeground,
                                                  ),
                                                ),
                                                const fw.SizedBox(height: 4),
                                                Text(
                                                  order.paymentStatus!.name ??
                                                      'N/A',
                                                  style: fw.TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        fw.FontWeight.w700,
                                                    color: theme
                                                        .colorScheme
                                                        .secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Payment Summary Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'PAYMENT SUMMARY',
                                    style: fw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: fw.FontWeight.w700,
                                      color: theme.colorScheme.mutedForeground,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 16),
                                  _PaymentRow(
                                    label: 'Total Amount',
                                    value:
                                        '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _PaymentRow(
                                    label: 'Paid Amount',
                                    value:
                                        '\$${order.paidAmount?.toStringAsFixed(2) ?? '0.00'}',
                                    theme: theme,
                                    valueColor: theme.colorScheme.primary,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  fw.Container(
                                    padding: const fw.EdgeInsets.only(top: 12),
                                    decoration: fw.BoxDecoration(
                                      border: fw.Border(
                                        top: fw.BorderSide(
                                          color: theme.colorScheme.border
                                              .withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: _PaymentRow(
                                      label: 'Remaining Amount',
                                      value:
                                          '\$${order.remainingAmount?.toStringAsFixed(2) ?? '0.00'}',
                                      theme: theme,
                                      isLarge: true,
                                      valueColor:
                                          (order.remainingAmount ?? 0) > 0
                                          ? theme.colorScheme.destructive
                                          : theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Dates Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'DATES',
                                    style: fw.TextStyle(
                                      fontSize: 11,
                                      fontWeight: fw.FontWeight.w700,
                                      color: theme.colorScheme.mutedForeground,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  const fw.SizedBox(height: 16),
                                  if (order.creationTime != null)
                                    _DateRow(
                                      label: 'Created',
                                      date: order.creationTime!,
                                      theme: theme,
                                    ),
                                  if (order.lastModificationTime != null) ...[
                                    const fw.SizedBox(height: 12),
                                    _DateRow(
                                      label: 'Last Modified',
                                      date: order.lastModificationTime!,
                                      theme: theme,
                                    ),
                                  ],
                                  if (order.cancellationTime != null) ...[
                                    const fw.SizedBox(height: 12),
                                    _DateRow(
                                      label: 'Cancelled',
                                      date: order.cancellationTime!,
                                      theme: theme,
                                      isDestructive: true,
                                    ),
                                    if (order.cancellationReason != null &&
                                        order
                                            .cancellationReason!
                                            .isNotEmpty) ...[
                                      const fw.SizedBox(height: 8),
                                      Text(
                                        'Reason: ${order.cancellationReason}',
                                        style: fw.TextStyle(
                                          fontSize: 13,
                                          color:
                                              theme.colorScheme.mutedForeground,
                                          fontStyle: fw.FontStyle.italic,
                                        ),
                                      ),
                                    ],
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Info Row Widget - For customer information
class _InfoRow extends fw.StatelessWidget {
  final fw.IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      crossAxisAlignment: fw.CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.mutedForeground),
        const fw.SizedBox(width: 12),
        fw.Expanded(
          child: fw.Column(
            crossAxisAlignment: fw.CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: fw.TextStyle(
                  fontSize: 11,
                  fontWeight: fw.FontWeight.w600,
                  color: theme.colorScheme.mutedForeground,
                ),
              ),
              const fw.SizedBox(height: 4),
              Text(
                value,
                style: fw.TextStyle(
                  fontSize: 14,
                  fontWeight: fw.FontWeight.w500,
                  color: theme.colorScheme.foreground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Payment Row Widget - For payment summary
class _PaymentRow extends fw.StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;
  final bool isLarge;
  final fw.Color? valueColor;

  const _PaymentRow({
    required this.label,
    required this.value,
    required this.theme,
    this.isLarge = false,
    this.valueColor,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: fw.TextStyle(
            fontSize: isLarge ? 14 : 13,
            fontWeight: isLarge ? fw.FontWeight.w700 : fw.FontWeight.w500,
            color: theme.colorScheme.foreground,
          ),
        ),
        Text(
          value,
          style: fw.TextStyle(
            fontSize: isLarge ? 18 : 15,
            fontWeight: fw.FontWeight.w700,
            color: valueColor ?? theme.colorScheme.foreground,
          ),
        ),
      ],
    );
  }
}

/// Date Row Widget - For dates section
class _DateRow extends fw.StatelessWidget {
  final String label;
  final DateTime date;
  final ThemeData theme;
  final bool isDestructive;

  const _DateRow({
    required this.label,
    required this.date,
    required this.theme,
    this.isDestructive = false,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Row(
      mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w500,
            color: isDestructive
                ? theme.colorScheme.destructive
                : theme.colorScheme.foreground,
          ),
        ),
        Text(
          _formatDateTime(date),
          style: fw.TextStyle(
            fontSize: 13,
            fontWeight: fw.FontWeight.w600,
            color: theme.colorScheme.mutedForeground,
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime date) {
    final year = date.year;
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$year-$month-$day $hour:$minute';
  }
}
