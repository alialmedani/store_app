import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../../../../core/ui/shadcn/widget/design_system/design_system.dart';
import '../cubit/order_cubit.dart';
import '../data/model/order_model.dart';
import 'create_order_screen.dart';
import 'order_details_screen.dart';
import 'update_order_screen.dart';

/// Order List Screen - Shows all orders with pagination
/// Uses PaginationList widget from boilerplate
class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            AppHeader(
              title: 'Orders',
              onBack: () => fw.Navigator.pop(context),
              action: fw.GestureDetector(
                onTap: () {
                  fw.Navigator.push(
                    context,
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const CreateOrderScreen(),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                child: fw.Container(
                  width: AppDesignTokens.headerActionButtonSize,
                  height: AppDesignTokens.headerActionButtonSize,
                  decoration: fw.BoxDecoration(
                    color: AppDesignTokens.mutedSurfaceColor,
                    borderRadius: fw.BorderRadius.circular(12),
                  ),
                  child: fw.Center(
                    child: fw.Icon(
                      Icons.add,
                      size: 20,
                      color: Theme.of(context).colorScheme.foreground,
                    ),
                  ),
                ),
              ),
            ),
            fw.Expanded(
              child: PaginationList<OrderModel>(
                withPagination: true,
                withRefresh: true,
                repositoryCallBack: (data) {
                  return context.read<OrderCubit>().fetchOrderList(data);
                },
                listBuilder: (list) {
                  return fw.ListView.builder(
                    padding: const fw.EdgeInsets.fromLTRB(
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                      AppDesignTokens.screenPaddingHorizontal,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final order = list[index];
                      return fw.Padding(
                        padding: const fw.EdgeInsets.only(
                          bottom: AppDesignTokens.cardGap,
                        ),
                        child: _OrderCard(order: order),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Order Card Widget
class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      onTap: () {
        if (order.id != null) {
          fw.Navigator.of(context).push(
            fw.PageRouteBuilder(
              pageBuilder: (_, __, ___) =>
                  OrderDetailsScreen(orderId: order.id!),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
      child: fw.Column(
        crossAxisAlignment: fw.CrossAxisAlignment.start,
        children: [
          // Order Number, Date, and Edit Button
          fw.Row(
            mainAxisAlignment: fw.MainAxisAlignment.spaceBetween,
            children: [
              fw.Expanded(
                child: Text(
                  order.orderNumber ?? 'N/A',
                  style: const fw.TextStyle(
                    fontSize: AppDesignTokens.cardTitleFontSize,
                    fontWeight: AppDesignTokens.bold,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
              if (order.creationTime != null)
                Text(
                  DateFormat('MMM d, y').format(order.creationTime!),
                  style: fw.TextStyle(
                    fontSize: AppDesignTokens.captionFontSize,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
              const fw.SizedBox(width: 8),
              IconButton(
                icon: const fw.Icon(Icons.edit, size: 16),
                onPressed: () async {
                  await fw.Navigator.of(context).push(
                    fw.PageRouteBuilder(
                      pageBuilder: (_, __, ___) => BlocProvider(
                        create: (_) => OrderCubit(),
                        child: UpdateOrderScreen(order: order),
                      ),
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                    ),
                  );
                },
                variance: ButtonVariance.ghost,
              ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Customer Name
          fw.Row(
            children: [
              fw.Icon(
                Icons.person_outline,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
              const fw.SizedBox(width: 8),
              fw.Expanded(
                child: Text(
                  order.customerName ?? 'N/A',
                  style: const fw.TextStyle(
                    fontSize: AppDesignTokens.bodyFontSize,
                  ),
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: 8),

          // Phone
          fw.Row(
            children: [
              fw.Icon(
                Icons.phone_outlined,
                size: 16,
                color: theme.colorScheme.mutedForeground,
              ),
              const fw.SizedBox(width: 8),
              Text(
                order.customerPhone ?? 'N/A',
                style: const fw.TextStyle(
                  fontSize: AppDesignTokens.bodyFontSize,
                ),
              ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Status and Payment Status
          fw.Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (order.status != null)
                StatusBadge(
                  text: order.status!.name ?? 'N/A',
                  type: StatusBadgeType.info,
                ),
              if (order.paymentStatus != null)
                StatusBadge(
                  text: order.paymentStatus!.name ?? 'N/A',
                  type: order.paymentStatus!.name?.toLowerCase() == 'paid'
                      ? StatusBadgeType.success
                      : StatusBadgeType.warning,
                ),
            ],
          ),
          const fw.SizedBox(height: AppDesignTokens.itemGap),

          // Total Amount
          fw.Container(
            padding: const fw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: fw.BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: fw.BorderRadius.circular(8),
            ),
            child: fw.Row(
              mainAxisSize: fw.MainAxisSize.min,
              children: [
                Text(
                  'Total: ',
                  style: fw.TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                Text(
                  '\$${order.totalAmount?.toStringAsFixed(2) ?? '0.00'}',
                  style: fw.TextStyle(
                    fontSize: 16,
                    fontWeight: AppDesignTokens.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
