import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/order_cubit.dart';
import '../data/usecase/create_order_usecase.dart';
import 'add_product_screen.dart';

/// Create Order Screen - 2-Step Wizard
/// Step 1: Customer Information
/// Step 2: Product Selection
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

  int _currentStep = 1; // 1 = customer info, 2 = product selection

  bool _validateStep1(OrderCubit cubit) {
    bool isValid = true;

    if (_customerNameController.text.trim().isEmpty) {
      cubit.setCustomerNameError('Customer name is required');
      isValid = false;
    } else {
      cubit.clearCustomerNameError();
    }

    if (_customerPhoneController.text.trim().isEmpty) {
      cubit.setCustomerPhoneError('Phone number is required');
      isValid = false;
    } else {
      cubit.clearCustomerPhoneError();
    }

    if (_customerAddressController.text.trim().isEmpty) {
      cubit.setCustomerAddressError('Address is required');
      isValid = false;
    } else {
      cubit.clearCustomerAddressError();
    }

    return isValid;
  }

  bool _validateStep2(OrderCubit cubit) {
    if (cubit.orderItems.isEmpty) {
      cubit.setItemsError('Please add at least one item to the order');
      return false;
    } else {
      cubit.clearItemsError();
      return true;
    }
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
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: Column(
          children: [
            // App Bar with Step Indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.border.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (_currentStep == 2) {
                            setState(() => _currentStep = 1);
                          } else {
                            Navigator.pop(context);
                          }
                        },
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
                  const SizedBox(height: 16),

                  // Step Indicator
                  Row(
                    children: [
                      Expanded(
                        child: _StepIndicator(
                          number: 1,
                          label: 'Customer Info',
                          isActive: _currentStep == 1,
                          isCompleted: _currentStep > 1,
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 2,
                        color: _currentStep > 1
                            ? theme.colorScheme.primary
                            : theme.colorScheme.border.withOpacity(0.3),
                      ),
                      Expanded(
                        child: _StepIndicator(
                          number: 2,
                          label: 'Products',
                          isActive: _currentStep == 2,
                          isCompleted: false,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(
              child: _currentStep == 1
                  ? _buildStep1(context, cubit)
                  : _buildStep2(context, cubit),
            ),

            // Bottom Actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.border.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: _currentStep == 1
                  ? _buildStep1Actions(context, cubit)
                  : _buildStep2Actions(context, cubit),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Customer Information
  Widget _buildStep1(BuildContext context, OrderCubit cubit) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Customer Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),

              // Customer Name Field
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Name *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customerNameController,
                        placeholder: const Text('Enter customer name'),
                        onChanged: (value) {
                          cubit.createOrderParams.customerName = value;
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
              const SizedBox(height: 20),

              // Customer Phone Field
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phone Number *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customerPhoneController,
                        placeholder: const Text('Enter phone number'),
                        keyboardType: TextInputType.phone,
                        onChanged: (value) {
                          cubit.createOrderParams.customerPhone = value;
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
              const SizedBox(height: 20),

              // Customer Address Field
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Address *',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _customerAddressController,
                        placeholder: const Text('Enter delivery address'),
                        maxLines: 3,
                        onChanged: (value) {
                          cubit.createOrderParams.customerAddress = value;
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
              const SizedBox(height: 20),

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
                placeholder: const Text('Add special instructions or notes'),
                maxLines: 3,
                onChanged: (value) {
                  cubit.createOrderParams.note = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep1Actions(BuildContext context, OrderCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: PrimaryButton(
            onPressed: () {
              if (_validateStep1(cubit)) {
                setState(() => _currentStep = 2);
              }
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Next: Add Products'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Product Selection
  Widget _buildStep2(BuildContext context, OrderCubit cubit) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
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
                      fontSize: 18,
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
                        Text('Add Product'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Order Items List
              BlocBuilder<OrderCubit, OrderState>(
                builder: (context, state) {
                  if (cubit.orderItems.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.muted.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 64,
                              color: theme.colorScheme.mutedForeground,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items added yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap "Add Product" to start',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: [
                      for (int i = 0; i < cubit.orderItems.length; i++)
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
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        cubit.itemsError!,
                        style: const TextStyle(
                          color: Color(0xFFEF4444),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
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
    );
  }

  Widget _buildStep2Actions(BuildContext context, OrderCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: OutlineButton(
            onPressed: () => setState(() => _currentStep = 1),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, size: 18),
                SizedBox(width: 8),
                Text('Back'),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: CreateModel(
            withValidation: true,
            onTap: () {
              return _validateStep2(cubit);
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
        ),
      ],
    );
  }

  void _showAddItemDialog(BuildContext context, OrderCubit cubit) async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AddProductScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      cubit.addOrderItem(
        productVariantId: result['productVariantId'] as String,
        quantity: result['quantity'] as int,
      );
    }
  }
}

/// Step Indicator Widget
class _StepIndicator extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StepIndicator({
    required this.number,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isCompleted || isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.muted.withOpacity(0.3),
            shape: BoxShape.circle,
            border: isActive
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 3,
                  )
                : null,
          ),
          child: Center(
            child: isCompleted
                ? Icon(
                    Icons.check,
                    size: 20,
                    color: theme.colorScheme.primaryForeground,
                  )
                : Text(
                    '$number',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? theme.colorScheme.primaryForeground
                          : theme.colorScheme.mutedForeground,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
            color: isActive
                ? theme.colorScheme.foreground
                : theme.colorScheme.mutedForeground,
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.muted.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.border.withOpacity(0.2),
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
