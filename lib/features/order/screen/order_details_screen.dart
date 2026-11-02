import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../core/boilerplate/get_model/cubits/get_model_cubit.dart';
import '../../../core/boilerplate/get_model/widgets/get_model.dart';
import '../cubit/order_cubit.dart';
import '../data/model/order_model.dart';
import 'widgets/order_sections.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:store/core/ui/shadcn/widget/design_system/design_system.dart';

/// Order Details Screen - Shows full details of a single order
/// Uses GetModel widget from boilerplate to handle loading/success/error states
class OrderDetailsScreen extends fw.StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  fw.State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends fw.State<OrderDetailsScreen> {
  GetModelCubit? _detailsCubit;

  /// Re-fetch the order after an action (confirm, pay, cancel, items...)
  void _reload() {
    _detailsCubit?.getModel();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final orderId = widget.orderId;
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => OrderCubit(),
      child: Scaffold(
        child: SafeArea(
          child: ScrollAwayHeader(header: fw.Column(children: [
              AppHeader(title: 'order_details'.tr(),
              )]), body: GetModel<OrderModel>(
                  onCubitCreated: (cubit) => _detailsCubit = cubit,
                  useCaseCallBack: () =>
                      context.read<OrderCubit>().getOrderDetails(orderId),
                  modelBuilder: (order) {
                    return fw.SingleChildScrollView(
                      padding: const fw.EdgeInsets.all(20),
                      child: fw.Column(
                        crossAxisAlignment: fw.CrossAxisAlignment.start,
                        children: [
                          // Order number hero
                          fw.Container(
                            width: double.infinity,
                            padding: const fw.EdgeInsets.all(20),
                            decoration: fw.BoxDecoration(
                              gradient: AppDesignTokens.primaryGradient,
                              borderRadius: fw.BorderRadius.circular(
                                AppDesignTokens.cardRadius + 4,
                              ),
                              boxShadow: AppDesignTokens.glowShadow,
                            ),
                            child: fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'order_number'.tr(),
                                  style: fw.TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: fw.FontWeight.w600,
                                    color: const fw.Color(0xFFFFFFFF)
                                        .withValues(alpha: 0.78),
                                  ),
                                ),
                                const fw.SizedBox(height: 6),
                                Text(
                                  order.orderNumber ?? 'N/A',
                                  style: const fw.TextStyle(
                                    fontSize: 24,
                                    fontWeight: fw.FontWeight.w800,
                                    letterSpacing: -0.3,
                                    color: fw.Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
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
                                  AppSectionTitle('customer_information_2'.tr()),
                                  const fw.SizedBox(height: 16),
                                  _InfoRow(
                                    icon: Icons.person_outline,
                                    label: 'name'.tr(),
                                    value: order.customerName ?? 'N/A',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _InfoRow(
                                    icon: Icons.phone_outlined,
                                    label: 'phone'.tr(),
                                    value: order.customerPhone ?? 'N/A',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _InfoRow(
                                    icon: Icons.location_on_outlined,
                                    label: 'address'.tr(),
                                    value: order.customerAddress ?? 'N/A',
                                    theme: theme,
                                  ),
                                  if (order.note != null &&
                                      order.note!.isNotEmpty) ...[
                                    const fw.SizedBox(height: 12),
                                    _InfoRow(
                                      icon: Icons.note_outlined,
                                      label: 'note'.tr(),
                                      value: order.note!,
                                      theme: theme,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const fw.SizedBox(height: 16),

                          // Items (editable while the order is a draft)
                          OrderItemsSection(
                            order: order,
                            theme: theme,
                            onChanged: _reload,
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
                                  AppSectionTitle('status_2'.tr()),
                                  const fw.SizedBox(height: 16),
                                  fw.IntrinsicHeight(
                                    child: fw.Row(
                                      crossAxisAlignment:
                                          fw.CrossAxisAlignment.stretch,
                                      children: [
                                        if (order.status != null)
                                          fw.Expanded(
                                            child: AppStatTile(
                                              label: 'order_status'.tr(),
                                              value: order.status!.name ?? 'N/A',
                                              icon: Icons.local_shipping_rounded,
                                              highlight: true,
                                            ),
                                          ),
                                        if (order.status != null &&
                                            order.paymentStatus != null)
                                          const fw.SizedBox(width: 12),
                                        if (order.paymentStatus != null)
                                          fw.Expanded(
                                            child: AppStatTile(
                                              label: 'payment'.tr(),
                                              value:
                                                  order.paymentStatus!.name ??
                                                  'N/A',
                                              icon: Icons.payments_rounded,
                                            ),
                                          ),
                                      ],
                                    ),
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
                                  AppSectionTitle('payment_summary'.tr()),
                                  const fw.SizedBox(height: 16),
                                  _PaymentRow(
                                    label: 'total_amount'.tr(),
                                    value:
                                        '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                                    theme: theme,
                                  ),
                                  const fw.SizedBox(height: 12),
                                  _PaymentRow(
                                    label: 'paid_amount'.tr(),
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
                                              .withValues(alpha: 0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: _PaymentRow(
                                      label: 'remaining_amount'.tr(),
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

                          // Payments history
                          OrderPaymentsSection(order: order, theme: theme),

                          // Status based actions
                          OrderActionsSection(
                            order: order,
                            theme: theme,
                            onChanged: _reload,
                            onDeleted: () {
                              if (mounted) fw.Navigator.pop(context, true);
                            },
                          ),

                          // Dates Card
                          Card(
                            child: fw.Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(20),
                              child: fw.Column(
                                crossAxisAlignment: fw.CrossAxisAlignment.start,
                                children: [
                                  AppSectionTitle('dates'.tr()),
                                  const fw.SizedBox(height: 16),
                                  if (order.creationTime != null)
                                    _DateRow(
                                      label: 'created'.tr(),
                                      date: order.creationTime!,
                                      theme: theme,
                                    ),
                                  if (order.lastModificationTime != null) ...[
                                    const fw.SizedBox(height: 12),
                                    _DateRow(
                                      label: 'last_modified'.tr(),
                                      date: order.lastModificationTime!,
                                      theme: theme,
                                    ),
                                  ],
                                  if (order.cancellationTime != null) ...[
                                    const fw.SizedBox(height: 12),
                                    _DateRow(
                                      label: 'cancelled'.tr(),
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
                                        'reason'.tr(args: ['${order.cancellationReason}']),
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
                )),
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
        fw.Container(
          width: 34,
          height: 34,
          decoration: fw.BoxDecoration(
            color: AppDesignTokens.primaryColor.withValues(alpha: 0.14),
            borderRadius: fw.BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 18, color: AppDesignTokens.primaryColor),
        ),
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
