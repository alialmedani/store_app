import 'package:flutter/widgets.dart' as fw;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/ui/kit/app_kit.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/order_cubit.dart';
import '../data/model/order_model.dart';
import '../../../core/ui/shadcn/widget/design_system/design_system.dart';
import 'package:easy_localization/easy_localization.dart';

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
    cubit.updateOrderParams.customerAddress =
        widget.order.customerAddress ?? '';
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
      cubit.setCustomerNameError('customer_name_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearCustomerNameError();
    }

    if (_customerPhoneController.text.trim().isEmpty) {
      cubit.setCustomerPhoneError('phone_number_is_required'.tr());
      isValid = false;
    } else {
      cubit.clearCustomerPhoneError();
    }

    if (_customerAddressController.text.trim().isEmpty) {
      cubit.setCustomerAddressError('address_is_required'.tr());
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
        child: ScrollAwayHeader(header: fw.Column(children: [
            AppHeader(title: 'update_order'.tr()),
          ]), body: SingleChildScrollView(
                padding: const fw.EdgeInsets.all(
                  AppDesignTokens.screenPaddingHorizontal,
                ),
                child: AppCard(
                  elevated: true,
                  padding: const fw.EdgeInsets.all(
                    AppDesignTokens.cardPaddingLarge,
                  ),
                  child: fw.Column(
                      crossAxisAlignment: fw.CrossAxisAlignment.stretch,
                      children: [
                        // Order Number (Read-only)
                        fw.Column(
                          crossAxisAlignment: fw.CrossAxisAlignment.start,
                          children: [
                            Text(
                              'order_number'.tr(),
                              style: const TextStyle(
                                fontSize: AppDesignTokens.bodyFontSize,
                                fontWeight: AppDesignTokens.semiBold,
                              ),
                            ),
                            const fw.SizedBox(height: AppDesignTokens.smallGap),
                            Container(
                              width: double.infinity,
                              padding: const fw.EdgeInsets.all(AppDesignTokens.itemGap),
                              decoration: fw.BoxDecoration(
                                color: theme.colorScheme.muted.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: fw.BorderRadius.circular(AppDesignTokens.badgeRadius),
                                border: Border.all(
                                  color: theme.colorScheme.border,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.order.orderNumber ?? 'N/A',
                                style: TextStyle(
                                  fontSize: AppDesignTokens.bodyFontSize,
                                  color: theme.colorScheme.mutedForeground,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const fw.SizedBox(height: AppDesignTokens.cardGap),

                        // Customer Name Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'customer_name_2'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
                                  ),
                                ),
                                const fw.SizedBox(height: AppDesignTokens.smallGap),
                                TextField(
                                  controller: _customerNameController,
                                  placeholder: Text(
                                    'enter_customer_name'.tr(),
                                  ),
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerName =
                                        value;
                                    cubit.clearCustomerNameError();
                                  },
                                ),
                                if (cubit.customerNameError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: AppDesignTokens.tinyGap),
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
                        const fw.SizedBox(height: AppDesignTokens.cardGap),

                        // Customer Phone Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'phone_number_2'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
                                  ),
                                ),
                                const fw.SizedBox(height: AppDesignTokens.smallGap),
                                TextField(
                                  controller: _customerPhoneController,
                                  placeholder: Text('enter_phone_number'.tr()),
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerPhone =
                                        value;
                                    cubit.clearCustomerPhoneError();
                                  },
                                ),
                                if (cubit.customerPhoneError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: AppDesignTokens.tinyGap),
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
                        const fw.SizedBox(height: AppDesignTokens.cardGap),

                        // Customer Address Field
                        BlocBuilder<OrderCubit, OrderState>(
                          builder: (context, state) {
                            return fw.Column(
                              crossAxisAlignment: fw.CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'delivery_address'.tr(),
                                  style: const TextStyle(
                                    fontSize: AppDesignTokens.bodyFontSize,
                                    fontWeight: AppDesignTokens.semiBold,
                                  ),
                                ),
                                const fw.SizedBox(height: AppDesignTokens.smallGap),
                                TextField(
                                  controller: _customerAddressController,
                                  placeholder: Text(
                                    'enter_delivery_address'.tr(),
                                  ),
                                  maxLines: 3,
                                  onChanged: (value) {
                                    cubit.updateOrderParams.customerAddress =
                                        value;
                                    cubit.clearCustomerAddressError();
                                  },
                                ),
                                if (cubit.customerAddressError != null)
                                  Padding(
                                    padding: const fw.EdgeInsets.only(top: AppDesignTokens.tinyGap),
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
                        const fw.SizedBox(height: AppDesignTokens.cardGap),

                        // Note Field
                        Text(
                          'note_optional'.tr(),
                          style: const TextStyle(
                            fontSize: AppDesignTokens.bodyFontSize,
                            fontWeight: AppDesignTokens.semiBold,
                          ),
                        ),
                        const fw.SizedBox(height: AppDesignTokens.smallGap),
                        TextField(
                          controller: _noteController,
                          placeholder: Text(
                            'add_special_instructions_or_notes'.tr(),
                          ),
                          maxLines: 3,
                          onChanged: (value) {
                            cubit.updateOrderParams.note = value;
                          },
                        ),
                        const fw.SizedBox(height: AppDesignTokens.sectionGap),

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
                                title: Text('success'.tr()),
                                content: Text(
                                  'order_updated_successfully'.tr(),
                                ),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () {
                                      fw.Navigator.pop(ctx);
                                      fw.Navigator.pop(
                                        context,
                                        true,
                                      ); // Return true to indicate success
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
                                content: Text('failed_to_update_order'.tr(args: ['$error'])),
                                actions: [
                                  PrimaryButton(
                                    onPressed: () => fw.Navigator.pop(ctx),
                                    child: Text('ok'.tr()),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: PrimaryButton(
                            child: Text('update_order'.tr()),
                          ),
                        ),
                      ],
                    ),
                ),
              )),
      ),
    );
  }
}
