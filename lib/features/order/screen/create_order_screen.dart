import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/order_cubit.dart';
import '../data/usecase/create_order_usecase.dart';
import 'widgets/add_product_dialog.dart';

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
      cubit.setCustomerNameError('Customer name is required');
      isValid = false;
    } else {
      cubit.clearCustomerNameError();
    }

    // Validate phone
    if (_customerPhoneController.text.trim().isEmpty) {
      cubit.setCustomerPhoneError('Phone number is required');
      isValid = false;
    } else {
      cubit.clearCustomerPhoneError();
    }

    // Validate address
    if (_customerAddressController.text.trim().isEmpty) {
      cubit.setCustomerAddressError('Address is required');
      isValid = false;
    } else {
      cubit.clearCustomerAddressError();
    }

    // Validate items
    if (cubit.orderItems.isEmpty) {
      cubit.setItemsError('Please add at least one item to the order');
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
        child: Column(
          children: [
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
                  const Expanded(
                    child: Text(
                      'Create Order',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
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
                            const Text(
                              'Customer Information',
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
                                    const Text(
                                      'Customer Name',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerNameController,
                                      placeholder: const Text(
                                        'Enter customer name',
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
                                          style: const TextStyle(
                                            color: Color(0xFFEF4444),
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
                                    const Text(
                                      'Phone Number',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerPhoneController,
                                      placeholder: const Text(
                                        'Enter phone number',
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
                                          style: const TextStyle(
                                            color: Color(0xFFEF4444),
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
                                    const Text(
                                      'Address',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _customerAddressController,
                                      placeholder: const Text(
                                        'Enter delivery address',
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
                                          style: const TextStyle(
                                            color: Color(0xFFEF4444),
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
                            const Text(
                              'Note (Optional)',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextField(
                              controller: _noteController,
                              placeholder: const Text('Add note'),
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
                                const Text(
                                  'Order Items',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                OutlineButton(
                                  onPressed: () {
                                    _showAddItemDialog(context, cubit);
                                  },
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.add, size: 16),
                                      SizedBox(width: 4),
                                      Text('Add Item'),
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
                                      borderRadius: BorderRadius.circular(12),
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
                                            'No items added yet',
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
                                      style: const TextStyle(
                                        color: Color(0xFFEF4444),
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
                            title: const Text('Success'),
                            content: const Text('Order created successfully!'),
                            actions: [
                              PrimaryButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  Navigator.pop(context, true);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      onError: (error) {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Error'),
                            content: Text(error),
                            actions: [
                              PrimaryButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: PrimaryButton(
                        child: const Text(
                          'Create Order',
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
              ),
            ),
          ],
        ),
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
        color: theme.colorScheme.muted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.border.withValues(alpha: 0.2),
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
                  'Product Variant',
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
                  'Quantity: ${item.quantity}',
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
