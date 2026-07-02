import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../../core/constant/enum/enum.dart';
import '../../../core/ui/widgets/custom_button.dart';
import '../../../core/ui/widgets/custom_text_form_field.dart';
import '../cubit/category_cubit.dart';
import '../data/model/category_model.dart';

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  late CategoryCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = CategoryCubit();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: AppBar(title: const Text('Create Category')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // Name Field
                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Category Name',
                  hintText: 'e.g., T-Shirts, Jeans, Shoes',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _cubit.createCategoryParams.name = value;
                  },
                ),
                const SizedBox(height: 16),

                // Description Field
                CustomTextFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'e.g., Cotton T-Shirts collection',
                  maxLines: 3,
                  onChanged: (value) {
                    _cubit.createCategoryParams.description = value;
                  },
                ),
                const SizedBox(height: 24),

                // Size Type Selector
                const Text(
                  'Size Type',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.none,
                          'None',
                          'For accessories',
                        ),
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.clothing,
                          'Clothing',
                          'S, M, L, XL or 38, 40, 42, 44',
                        ),
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.shoes,
                          'Shoes',
                          'US, EU, UK sizing',
                        ),
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.oneSize,
                          'One Size',
                          'One size fits all',
                        ),
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.kidsAge,
                          'Kids Age',
                          '2Y, 3Y, 4Y, 5Y',
                        ),
                        _buildSizeTypeOption(
                          _cubit,
                          SizeType.custom,
                          'Custom',
                          'Custom size definition',
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Active Toggle
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return SwitchListTile(
                      title: const Text('Active'),
                      subtitle: const Text('Show this category in the store'),
                      value: _cubit.createCategoryParams.isActive,
                      onChanged: (value) {
                        setState(() {
                          _cubit.toggleActive(value);
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Submit Button with CreateModel wrapper
                CreateModel<CategoryModel>(
                  useCaseCallBack: (data) => _cubit.createCategory(),

                  onSuccess: (data) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Category "${data.name}" created successfully!',
                        ),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $error')));
                  },
                  withValidation: true,
                  onTap: () => _formKey.currentState?.validate() ?? false,
                  child: CustomButton(text: 'Create Category'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeTypeOption(
    CategoryCubit cubit,
    SizeType type,
    String title,
    String subtitle,
  ) {
    final isSelected = cubit.createCategoryParams.sizeType == type;

    return RadioListTile<SizeType>(
      title: Text(title),
      subtitle: Text(subtitle),
      value: type,
      groupValue: cubit.createCategoryParams.sizeType,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            cubit.selectSizeType(value);
          });
        }
      },
      selected: isSelected,
    );
  }
}
