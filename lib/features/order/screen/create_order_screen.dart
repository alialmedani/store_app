import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/order_cubit.dart';
import '../data/usecase/create_order_usecase.dart';
import 'widgets/add_product_dialog.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

/// Create Order Screen - Form to create new order
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class CreateOrderScreen extends StatefulWidget {
  const CreateOrderScreen({super.key});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  final _customerNameController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _noteController = TextEditingController();

  bool _validateFields(OrderCubit cubit) {
    bool isValid = true;

    // Validate customer name
    if (_customerNameController.text.trim().isEmpty) {
      cubit.setCustomerNameError('customer_name_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearCustomerNameError();
    }

    // Validate phone
    if (_customerPhoneController.text.trim().isEmpty) {
      cubit.setCustomerPhoneError('phone_number_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearCustomerPhoneError();
    }

    // Validate address
    if (_customerAddressController.text.trim().isEmpty) {
      cubit.setCustomerAddressError('address_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearCustomerAddressError();
    }

    // Validate items
    if (cubit.orderItems.isEmpty) {
      cubit.setItemsError('please_add_at_least_one_item_to_the_or'.tr());
      isValid = false;
    } else {
      cubit.clearItemsError();
    }

    return isValid;
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _customerPhoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();

    return Scaffold(
      child: SafeArea(
        child: ScrollAwayHeader(header: Column(children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    variance: ButtonVariance.ghost,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'create_order'.tr(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Customer Information Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'customer_information'.tr(),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Customer Name Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'customer_name'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerNameController,
                                      placeholder: Text(
                                        'enter_customer_name'.tr(),
                                      ),
                                      onChanged: (value) {
                                        cubit.createOrderParams.customerName =
                                            value;
                                        cubit.clearCustomerNameError();
                                      },
                                    ),
                                    if (cubit.customerNameError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          cubit.customerNameError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Customer Phone Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'phone_number'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerPhoneController,
                                      placeholder: Text(
                                        'enter_phone_number'.tr(),
                                      ),
                                      keyboardType: TextInputType.phone,
                                      onChanged: (value) {
                                        cubit.createOrderParams.customerPhone =
                                            value;
                                        cubit.clearCustomerPhoneError();
                                      },
                                    ),
                                    if (cubit.customerPhoneError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          cubit.customerPhoneError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Customer Address Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'address'.tr(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerAddressController,
                                      placeholder: Text(
                                        'enter_delivery_address'.tr(),
                                      ),
                                      maxLines: 2,
                                      onChanged: (value) {
                                        cubit
                                                .createOrderParams
                                                .customerAddress =
                                            value;
                                        cubit.clearCustomerAddressError();
                                      },
                                    ),
                                    if (cubit.customerAddressError != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          cubit.customerAddressError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),

                            // Note Field
                            Text(
                              'note_optional'.tr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              placeholder: Text('add_note'.tr()),
                              maxLines: 2,
                              onChanged: (value) {
                                cubit.createOrderParams.note = value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Order Items Card
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'order_items'.tr(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                OutlineButton(
                                  onPressed: () {
                                    _showAddItemDialog(context, cubit);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 16),
                                      SizedBox(width: 4),
                                      Text('add_item'.tr()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Order Items List
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                if (cubit.orderItems.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).colorScheme.muted
                                          .withValues(alpha: 0.3),
                                      borderRadius: BorderRadius.circular(AppDesignTokens.iconBoxRadius),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.shopping_cart_outlined,
                                            size: 48,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.mutedForeground,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'no_items_added_yet'.tr(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.mutedForeground,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }

                                return Column(
                                  children: [
                                    for (
                                      int i = 0;
                                      i < cubit.orderItems.length;
                                      i++
                                    )
                                      _OrderItemTile(
                                        item: cubit.orderItems[i],
                                        index: i,
                                        onRemove: () {
                                          cubit.removeOrderItem(i);
                                        },
                                      ),
                                  ],
                                );
                              },
                            ),

                            // Items Error
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                if (cubit.itemsError != null) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      cubit.itemsError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: 12,
                                      ),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    CreateModel(
                      withValidation: true,
                      onTap: () {
                        return _validateFields(cubit);
                      },
                      useCaseCallBack: (data) {
                        return cubit.createOrder();
                      },
                      onSuccess: (order) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('success'.tr()),
                            content: Text('order_created_successfully'.tr()),
                            actions: [
                              PrimaryButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context, true);
                                },
                                child: Text('ok'.tr()),
                              ),
                            ],
                          ),
                        );
                      },
                      onError: (error) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text('error_2'.tr()),
                            content: Text(error),
                            actions: [
                              PrimaryButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text('ok'.tr()),
                              ),
                            ],
                          ),
                        );
                      },
                      child: PrimaryButton(
                        child: Text(
                          'create_order'.tr(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              )),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, OrderCubit cubit) {
    showDialog(
      context: context,
      builder: (ctx) => AddProductDialog(
        onItemAdded: (productVariantId, quantity) {
          cubit.addOrderItem(
            productVariantId: productVariantId,
            quantity: quantity,
          );
        },
      ),
    );
  }
}

/// Order Item Tile Widget
class _OrderItemTile extends StatelessWidget {
  final OrderItemParams item;
  final int index;
  final VoidCallback onRemove;

  const _OrderItemTile({
    required this.item,
    required this.index,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppDesignTokens.mutedSurfaceColor.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(AppDesignTokens.inputRadius),
        border: Border.all(
          color: AppDesignTokens.borderColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'product_variant'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.productVariantId,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'quantity'.tr(args: ['${item.quantity}']),
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.foreground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: onRemove,
            variance: ButtonVariance.ghost,
          ),
        ],
      ),
    );
  }
}
