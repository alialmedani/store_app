import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../cubit/create_product_cubit.dart';
import '../data/model/create_product_response_model.dart';

class CreateProductScreen extends StatefulWidget {
  const CreateProductScreen({super.key});

  @override
  State<CreateProductScreen> createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<CreateProductCubit>().loadLookups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateProductCubit, CreateProductState>(
      builder: (context, state) {
        final cubit = context.read<CreateProductCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Product'),
          ),
          body: cubit.isLoadingLookups
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Product Name',
                        ),
                        onChanged: (value) {
                          cubit.params.name = value;
                        },
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Product name is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (value) {
                          cubit.params.price = double.tryParse(value) ?? 0;
                        },
                        validator: (value) {
                          final price = double.tryParse(value ?? '');

                          if (price == null || price <= 0) {
                            return 'Price is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 2,
                        onChanged: (value) {
                          cubit.params.description = value;
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Main Image URL',
                        ),
                        onChanged: (value) {
                          cubit.params.imageUrl = value;
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<int>(
                        value: cubit.params.categoryId,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                        items: cubit.categories
                            .map(
                              (category) => DropdownMenuItem<int>(
                                value: category.id,
                                child: Text(category.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          cubit.setCategory(value);
                        },
                        validator: (value) {
                          if (value == null || value <= 0) {
                            return 'Category is required';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<int>(
                        value: cubit.params.brandId,
                        decoration: const InputDecoration(
                          labelText: 'Brand',
                        ),
                        items: cubit.brands
                            .map(
                              (brand) => DropdownMenuItem<int>(
                                value: brand.id,
                                child: Text(brand.name ?? ''),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          cubit.setBrand(value);
                        },
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Text(
                            'Variants',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (cubit.isLoadingSizes)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      ...List.generate(
                        cubit.params.variants.length,
                        (index) {
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
                                        onPressed: () {
                                          cubit.removeVariant(index);
                                        },
                                        icon: const Icon(Icons.delete),
                                      ),
                                    ],
                                  ),

                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Color',
                                    ),
                                    onChanged: (value) {
                                      variant.color = value;
                                    },
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return 'Color is required';
                                      }

                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  DropdownButtonFormField<int>(
                                    value: variant.sizeOptionId,
                                    decoration: const InputDecoration(
                                      labelText: 'Size',
                                    ),
                                    items: cubit.sizeOptions
                                        .map(
                                          (size) => DropdownMenuItem<int>(
                                            value: size.id,
                                            child: Text(size.name ?? ''),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: cubit.params.categoryId == null
                                        ? null
                                        : (value) {
                                            cubit.setVariantSizeOption(
                                              index,
                                              value,
                                            );
                                          },
                                    validator: (value) {
                                      if (value == null || value <= 0) {
                                        return 'Size is required';
                                      }

                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Quantity',
                                    ),
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      variant.quantity =
                                          int.tryParse(value) ?? 0;
                                    },
                                    validator: (value) {
                                      final quantity =
                                          int.tryParse(value ?? '');

                                      if (quantity == null || quantity < 0) {
                                        return 'Quantity is required';
                                      }

                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'SKU',
                                    ),
                                    onChanged: (value) {
                                      variant.sku = value;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Variant Image URL',
                                    ),
                                    onChanged: (value) {
                                      variant.imageUrl = value;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                      OutlinedButton.icon(
                        onPressed: () {
                          cubit.addVariant();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Variant'),
                      ),

                      const SizedBox(height: 24),

              ElevatedButton(
  onPressed: () async {
    final isValid = _formKey.currentState?.validate() ?? false;

    debugPrint('CREATE PRODUCT VALIDATION: $isValid');
    debugPrint('PRODUCT BODY: ${cubit.params.toJson()}');

    if (!isValid) return;

    final result = await cubit.createProduct();

    debugPrint('CREATE PRODUCT RESULT DATA: ${result.data}');
    debugPrint('CREATE PRODUCT RESULT ERROR: ${result.error}');

    if (!context.mounted) return;

    if (result.hasDataOnly) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product created successfully')),
      );

      Navigator.pop(context, result.data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error.toString())),
      );
    }
  },
  child: const Text('Create Product'),
)      ],
                  ),
                ),
        );
      },
    );
  }
}