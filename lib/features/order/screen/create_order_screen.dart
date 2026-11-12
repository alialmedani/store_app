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
            AppHeader(title: 'create_order'.tr()),
          ]), body: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  AppDesignTokens.screenPaddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Customer Information Card
                    AppCard(
                      elevated: true,
                      padding: const EdgeInsets.all(
                        AppDesignTokens.cardPaddingLarge,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'customer_information'.tr(),
                              style: const TextStyle(
                                fontSize: AppDesignTokens.cardTitleFontSize,
                                fontWeight: AppDesignTokens.bold,
                              ),
                            ),
                            const SizedBox(height: AppDesignTokens.cardGap),

                            // Customer Name Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'customer_name'.tr(),
                                      style: const TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                      ),
                                    ),
                                    const SizedBox(height: AppDesignTokens.smallGap),
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
                                        padding: const EdgeInsets.only(top: AppDesignTokens.tinyGap),
                                        child: Text(
                                          cubit.customerNameError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: AppDesignTokens.captionFontSize,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: AppDesignTokens.cardGap),

                            // Customer Phone Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'phone_number'.tr(),
                                      style: const TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                      ),
                                    ),
                                    const SizedBox(height: AppDesignTokens.smallGap),
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
                                        padding: const EdgeInsets.only(top: AppDesignTokens.tinyGap),
                                        child: Text(
                                          cubit.customerPhoneError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: AppDesignTokens.captionFontSize,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: AppDesignTokens.cardGap),

                            // Customer Address Field
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'address'.tr(),
                                      style: const TextStyle(
                                        fontSize: AppDesignTokens.bodyFontSize,
                                        fontWeight: AppDesignTokens.semiBold,
                                      ),
                                    ),
                                    const SizedBox(height: AppDesignTokens.smallGap),
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
                                        padding: const EdgeInsets.only(top: AppDesignTokens.tinyGap),
                                        child: Text(
                                          cubit.customerAddressError!,
                                          style: TextStyle(
                                            color: AppDesignTokens.dangerColor,
                                            fontSize: AppDesignTokens.captionFontSize,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: AppDesignTokens.cardGap),

                            // Note Field
                            Text(
                              'note_optional'.tr(),
                              style: const TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize,
                                fontWeight: AppDesignTokens.semiBold,
                              ),
                            ),
                            const SizedBox(height: AppDesignTokens.smallGap),
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
                    const SizedBox(height: AppDesignTokens.cardGap),

                    // Order Items Card
                    AppCard(
                      elevated: true,
                      padding: const EdgeInsets.all(
                        AppDesignTokens.cardPaddingLarge,
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'order_items'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.cardTitleFontSize,
                                    fontWeight: AppDesignTokens.bold,
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
                                      SizedBox(width: AppDesignTokens.tinyGap),
                                      Text('add_item'.tr()),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppDesignTokens.cardGap),

                            // Order Items List
                            BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                if (cubit.orderItems.isEmpty) {
                                  return Container(
                                    padding: const EdgeInsets.all(
                                      AppDesignTokens.cardPaddingLarge,
                                    ),
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
                                          const SizedBox(height: AppDesignTokens.itemGap),
                                          Text(
                                            'no_items_added_yet'.tr(),
                                            style: TextStyle(
                                              fontSize: AppDesignTokens.bodyFontSize,
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
                                    padding: const EdgeInsets.only(top: AppDesignTokens.smallGap),
                                    child: Text(
                                      cubit.itemsError!,
                                      style: TextStyle(
                                        color: AppDesignTokens.dangerColor,
                                        fontSize: AppDesignTokens.captionFontSize,
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
                    const SizedBox(height: AppDesignTokens.sectionGap),

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
                        child: Text('create_order'.tr()),
                      ),
                    ),
                    const SizedBox(height: AppDesignTokens.cardGap),
                  ],
                ),
              )),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, OrderCubit cubit) {
    AddProductDialog.show(
      context,
      onItemAdded: (productVariantId, quantity) async {
        cubit.addOrderItem(
          productVariantId: productVariantId,
          quantity: quantity,
        );
      },
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
      margin: const EdgeInsets.only(bottom: AppDesignTokens.smallGap),
      padding: const EdgeInsets.all(AppDesignTokens.itemGap),
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
                    fontSize: AppDesignTokens.captionFontSize,
                    color: theme.colorScheme.mutedForeground,
                  ),
                ),
                const SizedBox(height: AppDesignTokens.tinyGap),
                Text(
                  item.productVariantId,
                  style: const TextStyle(
                    fontSize: AppDesignTokens.bodyFontSize,
                    fontWeight: AppDesignTokens.semiBold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppDesignTokens.smallGap),
                Text(
                  'quantity'.tr(args: ['${item.quantity}']),
                  style: TextStyle(
                    fontSize: AppDesignTokens.bodyFontSize,
                    color: theme.colorScheme.foreground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDesignTokens.itemGap),
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
