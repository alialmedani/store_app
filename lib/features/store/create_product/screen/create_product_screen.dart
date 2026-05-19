import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/create_product_cubit.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<CreateProductCubit>().init());
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
          appBar: AppBar(title: const Text('Create Product')),
          body: cubit.isLoadingLookups
              ? const Center(child: CircularProgressIndicator())
              : Stepper(
                  currentStep: cubit.currentStep,
                  type: StepperType.vertical,
                  onStepContinue: () {
                    if (cubit.currentStep == 3) {
                      cubit.submit();
                    } else {
                      cubit.nextStep();
                    }
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
                  steps: const [
                    Step(
                      title: Text('Product Basic Info'),
                      content: _ProductBasicInfoStep(),
                    ),
                    Step(
                      title: Text('Category & Brand'),
                      content: _CategoryBrandStep(),
                    ),
                    Step(
                      title: Text('Size System'),
                      content: _SizeSystemStep(),
                    ),
                    Step(
                      title: Text('Variants'),
                      content: _VariantsStep(),
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
          decoration: const InputDecoration(labelText: 'Product Name'),
          onChanged: cubit.setProductName,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Price'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: cubit.setPrice,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Description'),
          maxLines: 2,
          onChanged: cubit.setDescription,
        ),
        const SizedBox(height: 12),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Main Image URL'),
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
        const Text('Use Existing Category'),
        const SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: cubit.params.categoryId,
          decoration: const InputDecoration(labelText: 'Category'),
          items: cubit.categories
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(e.name ?? ''),
                ),
              )
              .toList(),
          onChanged: cubit.setCategory,
        ),
        const Divider(height: 32),
        const Text('Create New Category'),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Category Name'),
          onChanged: (value) => cubit.newCategoryName = value,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Category Description'),
          onChanged: (value) => cubit.newCategoryDescription = value,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: cubit.isCreatingCategory ? null : cubit.createNewCategory,
          child: Text(
            cubit.isCreatingCategory ? 'Creating...' : 'Create Category & Use',
          ),
        ),
        const SizedBox(height: 24),
        const Text('Use Existing Brand'),
        DropdownButtonFormField<int>(
          value: cubit.params.brandId,
          decoration: const InputDecoration(labelText: 'Brand'),
          items: cubit.brands
              .map(
                (e) => DropdownMenuItem<int>(
                  value: e.id,
                  child: Text(e.name ?? ''),
                ),
              )
              .toList(),
          onChanged: cubit.setBrand,
        ),
        const Divider(height: 32),
        const Text('Create New Brand'),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Brand Name'),
          onChanged: (value) => cubit.newBrandName = value,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Brand Description'),
          onChanged: (value) => cubit.newBrandDescription = value,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: cubit.isCreatingBrand ? null : cubit.createNewBrand,
          child: Text(
            cubit.isCreatingBrand ? 'Creating...' : 'Create Brand & Use',
          ),
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
      return const Text('Select category first.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (cubit.isLoadingSizes)
          const Center(child: CircularProgressIndicator())
        else ...[
          const Text('Use Existing Size Group'),
          DropdownButtonFormField<int>(
            value: cubit.selectedSizeGroupId,
            decoration: const InputDecoration(labelText: 'Size Group'),
            items: cubit.sizeGroups
                .map(
                  (e) => DropdownMenuItem<int>(
                    value: e.id,
                    child: Text(e.name ?? ''),
                  ),
                )
                .toList(),
            onChanged: cubit.setSizeGroup,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: cubit.sizeOptions
                .map((e) => Chip(label: Text(e.name ?? '')))
                .toList(),
          ),
          const Divider(height: 32),
          const Text('Create New Size Group'),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Size Group Name'),
            onChanged: (value) => cubit.newSizeGroupName = value,
          ),
          TextFormField(
            decoration:
                const InputDecoration(labelText: 'Size Group Description'),
            onChanged: (value) => cubit.newSizeGroupDescription = value,
          ),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Size Options',
              hintText: 'S,M,L,XL',
            ),
            onChanged: (value) => cubit.newSizeOptionsText = value,
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed:
                cubit.isCreatingSizeGroup ? null : cubit.createNewSizeGroup,
            child: Text(
              cubit.isCreatingSizeGroup
                  ? 'Creating...'
                  : 'Create Size Group & Use',
            ),
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
                      Text('Variant ${index + 1}'),
                      const Spacer(),
                      IconButton(
                        onPressed: () => cubit.removeVariant(index),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Color'),
                    onChanged: (value) => cubit.setVariantColor(index, value),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: variant.sizeOptionId,
                    decoration: const InputDecoration(labelText: 'Size'),
                    items: cubit.sizeOptions
                        .map(
                          (e) => DropdownMenuItem<int>(
                            value: e.id,
                            child: Text(e.name ?? ''),
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
                    onChanged: (value) => cubit.setVariantSku(index, value),
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