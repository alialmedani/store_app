import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/create_model/widgets/create_model.dart';
import '../../lookups/cubit/lookups_cubit.dart';
import '../../lookups/data/model/lookup_model.dart';
import '../cubit/create_product_cubit.dart';
import '../data/model/create_product_response_model.dart';

class CreateProductScreen extends StatelessWidget {
  const CreateProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CreateProductCubit()),
        BlocProvider(create: (_) => LookupsCubit()),
      ],
      child: const _CreateProductView(),
    );
  }
}

class _CreateProductView extends StatefulWidget {
  const _CreateProductView();

  @override
  State<_CreateProductView> createState() => _CreateProductViewState();
}

class _CreateProductViewState extends State<_CreateProductView> {
  final _formKey = GlobalKey<FormState>();

  List<LookupModel> categories = [];
  List<LookupModel> brands = [];

  @override
  void initState() {
    super.initState();
    _loadLookups();
  }

  Future<void> _loadLookups() async {
    final lookupsCubit = context.read<LookupsCubit>();

    final categoriesResult = await lookupsCubit.fetchCategories();
    final brandsResult = await lookupsCubit.fetchBrands();

    setState(() {
      categories = categoriesResult.data ?? [];
      brands = brandsResult.data ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CreateProductCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Product')),
      body: BlocBuilder<CreateProductCubit, CreateProductState>(
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  onChanged: (value) => cubit.params.name = value,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Product name is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (value) {
                    cubit.params.price = double.tryParse(value) ?? 0;
                  },
                  validator: (value) {
                    if ((double.tryParse(value ?? '') ?? 0) <= 0) {
                      return 'Price is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                  onChanged: (value) => cubit.params.description = value,
                ),

                const SizedBox(height: 12),

                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Main Image URL',
                  ),
                  onChanged: (value) => cubit.params.imageUrl = value,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: cubit.params.categoryId,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: categories
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: cubit.setCategory,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<int>(
                  value: cubit.params.brandId,
                  decoration: const InputDecoration(labelText: 'Brand'),
                  items: brands
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.id,
                          child: Text(e.name ?? ''),
                        ),
                      )
                      .toList(),
                  onChanged: cubit.setBrand,
                ),

                const SizedBox(height: 24),

                const Text(
                  'Variants',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

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
                            decoration: const InputDecoration(
                              labelText: 'Color',
                            ),
                            onChanged: (value) => variant.color = value,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Color is required';
                              }
                              return null;
                            },
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Size',
                            ),
                            onChanged: (value) => variant.size = value,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Size is required';
                              }
                              return null;
                            },
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Quantity',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              variant.quantity = int.tryParse(value) ?? 0;
                            },
                            validator: (value) {
                              if ((int.tryParse(value ?? '') ?? -1) < 0) {
                                return 'Quantity is required';
                              }
                              return null;
                            },
                          ),

                          TextFormField(
                            decoration: const InputDecoration(labelText: 'SKU'),
                            onChanged: (value) => variant.sku = value,
                          ),

                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Variant Image URL',
                            ),
                            onChanged: (value) => variant.imageUrl = value,
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

                const SizedBox(height: 24),

                CreateModel<CreateProductResponseModel>(
                  withValidation: true,
                  onTap: () async {
                    return _formKey.currentState?.validate() ?? false;
                  },
                  useCaseCallBack: (_) {
                    return cubit.createProduct();
                  },
                  onSuccess: (product) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Product created successfully'),
                      ),
                    );
                    Navigator.pop(context, product);
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(error.toString())));
                  },
                  child: Container(
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Create Product',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
