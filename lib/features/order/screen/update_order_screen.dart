import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/order_cubit.dart';
import '../data/model/order_model.dart';

/// Update Order Screen - Form to update existing order (customer information)
/// Uses CreateModel widget for state management
/// Uses shadcn_flutter components
class UpdateOrderScreen extends fw.StatefulWidget {
  final OrderModel order;

  const UpdateOrderScreen({super.key, required this.order});

  @override
  fw.State<UpdateOrderScreen> createState() => _UpdateOrderScreenState();
}

class _UpdateOrderScreenState extends fw.State<UpdateOrderScreen> {
  final _customerNameController = fw.TextEditingController();
  final _customerAddressController = fw.TextEditingController();
  final _customerPhoneController = fw.TextEditingController();
  final _noteController = fw.TextEditingController();

  @override
  void initState() {
    super.initState();
    final cubit = context.read<OrderCubit>();

    // Initialize params with existing order data
    cubit.updateOrderParams.orderId = widget.order.id ?? '';
    cubit.updateOrderParams.customerName = widget.order.customerName ?? '';
    cubit.updateOrderParams.customerAddress = widget.order.customerAddress ?? '';
    cubit.updateOrderParams.customerPhone = widget.order.customerPhone ?? '';
    cubit.updateOrderParams.note = widget.order.note ?? '';

    // Initialize text controllers
    _customerNameController.text = widget.order.customerName ?? '';
    _customerAddressController.text = widget.order.customerAddress ?? '';
    _customerPhoneController.text = widget.order.customerPhone ?? '';
    _noteController.text = widget.order.note ?? '';
  }

  bool _validateFields(OrderCubit cubit) {
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

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerAddressController.dispose();
    _customerPhoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final theme = Theme.of(context);

    return Scaffold(
      child: SafeArea(
        child: fw.Column(
          children: [
            // App Bar
            Padding(
              padding: const fw.EdgeInsets.all(16),
              child: fw.Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => fw.Navigator.of(context).pop(),
                    variance: ButtonVariance.ghost,
                  ),
                  const fw.SizedBox(width: 8),
                  const fw.Expanded(
                    child: Text(
                      'Update Order',
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
            fw.Expanded(
              child: SingleChildScrollView(
                padding: const fw.EdgeInsets.all(16),
                child: Card(
                  child: Padding(
                    padding: const fw.EdgeInsets.all(24),
                    child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                      children: [
                        // Order Number (Read-only)
                        fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Order Number',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const fw.SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(12),
                              decoration: fw.BoxDecoration(
                                color: theme.colorScheme.muted.withOpacity(0.3),
                                borderRadius: fw.BorderRadius.circular(8),
                                border: Border.all(
                                  color: theme.colorScheme.border,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.order.orderNumber ?? 'N/A',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const fw.SizedBox(height: 16),

                        // Customer Name Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Customer Name *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _customerNameController,
                                  placeholder: const Text('Enter customer name'),
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerName = value;
                                    cubit.clearCustomerNameError();
                                  },
                                ),
                                if (cubit.customerNameError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
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
                        const fw.SizedBox(height: 20),

                        // Customer Phone Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Phone Number *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _customerPhoneController,
                                  placeholder: const Text('Enter phone number'),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerPhone = value;
                                    cubit.clearCustomerPhoneError();
                                  },
                                ),
                                if (cubit.customerPhoneError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
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
                        const fw.SizedBox(height: 20),

                        // Customer Address Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Delivery Address *',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const fw.SizedBox(height: 8),
                                TextField(
                                  controller: _customerAddressController,
                                  placeholder: const Text('Enter delivery address'),
                                  maxLines: 3,
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerAddress = value;
                                    cubit.clearCustomerAddressError();
                                  },
                                ),
                                if (cubit.customerAddressError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: 4),
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
                        const fw.SizedBox(height: 20),

                        // Note Field
                        const Text(
                          'Note (Optional)',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                        const fw.SizedBox(height: 8),
                        TextField(
                          controller: _noteController,
                          placeholder: const Text('Add special instructions or notes'),
                          maxLines: 3,
                          onChanged: (value) {
                            cubit.updateOrderParams.note = value;
                          },
                        ),
                        const fw.SizedBox(height: 32),

                        // Submit Button
                        CreateModel<OrderModel>(
                          withValidation: true,
                          onTap: () {
                            return _validateFields(cubit);
                          },
                          useCaseCallBack: (data) {
                            return cubit.updateOrder();
                          },
                          onSuccess: (orderModel) {
                            // Show success dialog
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Success'),
                                content: const Text(
                                  'Order updated successfully!',
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () {
                                      fw.Navigator.pop(ctx);
                                      fw.Navigator.pop(context, true); // Return true to indicate success
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
                                content: Text(
                                  'Failed to update order: $error',
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () => fw.Navigator.pop(ctx),
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: const Text('Update Order'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
