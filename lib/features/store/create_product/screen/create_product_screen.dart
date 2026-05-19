import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/create_product_cubit.dart';
import '../data/model/create_product_response_model.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<CreateProductCubit>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateProductCubit, CreateProductState>(
      listener: (context, state) {
        if (state is CreateProductError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        if (state is CreateProductSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product created successfully')),
          );

          Navigator.pop(context, state.data);
        }
      },
      builder: (context, state) {
        final cubit = context.read<CreateProductCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Product'),
          ),
          body: cubit.isLoadingLookups
              ? const Center(child: CircularProgressIndicator())
              : Stepper(
                  currentStep: cubit.currentStep,
                  type: StepperType.vertical,
                  onStepContinue: () async {
                    if (cubit.currentStep == 3) {
                      final result = await cubit.createProduct();

                      if (result.hasDataOnly && context.mounted) {
                        context.read<CreateProductCubit>().emit(
                              CreateProductSuccess(result.data),
                            );
                      } else if (!result.hasDataOnly && context.mounted) {
                        context.read<CreateProductCubit>().emit(
                              CreateProductError(result.error.toString()),
                            );
                      }

                      return;
                    }

                    cubit.nextStep();
                  },
                  onStepCancel: cubit.previousStep,
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed:
                                cubit.isSubmitting ? null : details.onStepContinue,
                            child: cubit.isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    cubit.currentStep == 3
                                        ? 'Create Product'
                                        : 'Next',
                                  ),
                          ),
                          const SizedBox(width: 12),
                          if (cubit.currentStep > 0)
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Back'),
                            ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: const Text('Product Basic Info'),
                      isActive: cubit.currentStep >= 0,
                      content: const _ProductBasicInfoStep(),
                    ),
                    Step(
                      title: const Text('Category & Brand'),
                      isActive: cubit.currentStep >= 1,
                      content: const _CategoryBrandStep(),
                    ),
                    Step(
                      title: const Text('Size System'),
                      isActive: cubit.currentStep >= 2,
                      content: const _SizeSystemStep(),
                    ),
                    Step(
                      title: const Text('Variants'),
                      isActive: cubit.currentStep >= 3,
                      content: const _VariantsStep(),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ProductBasicInfoStep extends StatelessWidget {
  const _ProductBasicInfoStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Product Name',
          ),
          onChanged: cubit.setProductName,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Price',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: cubit.setPrice,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Description',
          ),
          maxLines: 2,
          onChanged: cubit.setDescription,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Main Image URL',
          ),
          onChanged: cubit.setMainImageUrl,
        ),
      ],
    );
  }
}

class _CategoryBrandStep extends StatelessWidget {
  const _CategoryBrandStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Use Existing Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: cubit.params.categoryId,
          decoration: const InputDecoration(labelText: 'Category'),
          items: cubit.categories
              .map(
                (category) => DropdownMenuItem<int>(
                  value: category.id,
                  child: Text(category.name ?? ''),
                ),
              )
              .toList(),
          onChanged: cubit.setCategory,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const Text(
          'Or Create New Category',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'New Category Name'),
          onChanged: (value) {
            cubit.newCategoryName = value;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration:
              const InputDecoration(labelText: 'New Category Description'),
          onChanged: (value) {
            cubit.newCategoryDescription = value;
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: cubit.createNewCategory,
          icon: const Icon(Icons.add),
          label: const Text('Create Category & Use It'),
        ),
        const SizedBox(height: 24),
        const Text(
          'Use Existing Brand',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: cubit.params.brandId,
          decoration: const InputDecoration(labelText: 'Brand'),
          items: cubit.brands
              .map(
                (brand) => DropdownMenuItem<int>(
                  value: brand.id,
                  child: Text(brand.name ?? ''),
                ),
              )
              .toList(),
          onChanged: cubit.setBrand,
        ),
        const SizedBox(height: 16),
        const Divider(),
        const Text(
          'Or Create New Brand',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'New Brand Name'),
          onChanged: (value) {
            cubit.newBrandName = value;
          },
        ),
        const SizedBox(height: 8),
        TextFormField(
          decoration: const InputDecoration(labelText: 'New Brand Description'),
          onChanged: (value) {
            cubit.newBrandDescription = value;
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: cubit.createNewBrand,
          icon: const Icon(Icons.add),
          label: const Text('Create Brand & Use It'),
        ),
      ],
    );
  }
}

class _SizeSystemStep extends StatelessWidget {
  const _SizeSystemStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    if (cubit.params.categoryId == null) {
      return const Text('Please select category first.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cubit.isLoadingSizes)
          const Center(child: CircularProgressIndicator())
        else ...[
          const Text(
            'Use Existing Size Group',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: cubit.selectedSizeGroupId,
            decoration: const InputDecoration(labelText: 'Size Group'),
            items: cubit.sizeGroups
                .map(
                  (group) => DropdownMenuItem<int>(
                    value: group.id,
                    child: Text(group.name ?? ''),
                  ),
                )
                .toList(),
            onChanged: cubit.setSizeGroup,
          ),
          const SizedBox(height: 12),
          if (cubit.sizeOptions.isNotEmpty)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: cubit.sizeOptions
                  .map(
                    (size) => Chip(
                      label: Text(size.name ?? ''),
                    ),
                  )
                  .toList(),
            )
          else
            const Text('No size options loaded.'),
          const SizedBox(height: 16),
          const Divider(),
          const Text(
            'Create New Size Group / Size Options',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Required backend endpoint: create size group and create size options. '
            'Currently this screen only uses existing size groups.',
          ),
        ],
      ],
    );
  }
}

class _VariantsStep extends StatelessWidget {
  const _VariantsStep();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(cubit.params.variants.length, (index) {
          final variant = cubit.params.variants[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'Variant ${index + 1}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () => cubit.removeVariant(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Color'),
                    onChanged: (value) {
                      cubit.setVariantColor(index, value);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: variant.sizeOptionId,
                    decoration: const InputDecoration(labelText: 'Size'),
                    items: cubit.sizeOptions
                        .map(
                          (size) => DropdownMenuItem<int>(
                            value: size.id,
                            child: Text(size.name ?? ''),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      cubit.setVariantSizeOption(index, value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      cubit.setVariantQuantity(index, value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'SKU'),
                    onChanged: (value) {
                      cubit.setVariantSku(index, value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Variant Image URL'),
                    onChanged: (value) {
                      cubit.setVariantImageUrl(index, value);
                    },
                  ),
                ],
              ),
            ),
          );
        }),
        OutlinedButton.icon(
          onPressed: cubit.addVariant,
          icon: const Icon(Icons.add),
          label: const Text('Add Variant'),
        ),
      ],
    );
  }
}