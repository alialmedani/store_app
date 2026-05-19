import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/brands_cubit.dart';
import '../data/model/brand_model.dart';

class BrandsScreen extends StatelessWidget {
  const BrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BrandsCubit, BrandsState>(
      builder: (context, state) {
        final cubit = context.read<BrandsCubit>();

        return Scaffold(
          appBar: AppBar(title: const Text('Brands')),
          body: PaginationList<BrandModel>(
            key: ValueKey(cubit.refreshKey),
            withPagination: false,
            repositoryCallBack: (data) {
              return cubit.fetchBrands();
            },
            listBuilder: (brands) {
              if (brands.isEmpty) {
                return const Center(child: Text('No brands found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: brands.length,
                itemBuilder: (context, index) {
                  final brand = brands[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandDetailsScreen(
                              brandId: brand.id!,
                            ),
                          ),
                        );

                        if (result == true && context.mounted) {
                          context.read<BrandsCubit>().refreshBrands();
                        }
                      },
                      leading: CircleAvatar(
                        child: Text(brand.name?.substring(0, 1) ?? '?'),
                      ),
                      title: Text(brand.name ?? 'No name'),
                      subtitle: Text(brand.description ?? 'No description'),
                      trailing: brand.isActive == true
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : const Icon(Icons.cancel, color: Colors.red),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateBrandScreen(),
                ),
              );

              if (result != null && context.mounted) {
                context.read<BrandsCubit>().refreshBrands();
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class BrandDetailsScreen extends StatelessWidget {
  final int brandId;

  const BrandDetailsScreen({
    super.key,
    required this.brandId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand Details'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await context.read<BrandsCubit>().fetchBrandById(
                    brandId,
                  );

              if (!context.mounted || !result.hasDataOnly) return;

              final editResult = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditBrandScreen(
                    brand: result.data as BrandModel,
                  ),
                ),
              );

              if (editResult == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: FutureBuilder(
        future: context.read<BrandsCubit>().fetchBrandById(brandId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final result = snapshot.data;

          if (result == null || !result.hasDataOnly) {
            return Center(
              child: Text(result?.error.toString() ?? 'Failed to load brand'),
            );
          }

          final brand = result.data as BrandModel;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  title: const Text('Name'),
                  subtitle: Text(brand.name ?? ''),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Description'),
                  subtitle: Text(brand.description ?? 'No description'),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Status'),
                  subtitle: Text(brand.isActive == true ? 'Active' : 'Inactive'),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  final result = brand.isActive == true
                      ? await context.read<BrandsCubit>().deactivateBrand(
                            brand.id!,
                          )
                      : await context.read<BrandsCubit>().activateBrand(
                            brand.id!,
                          );

                  if (!context.mounted) return;

                  if (result.hasDataOnly) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.error.toString())),
                    );
                  }
                },
                icon: Icon(
                  brand.isActive == true ? Icons.pause : Icons.play_arrow,
                ),
                label: Text(
                  brand.isActive == true ? 'Deactivate' : 'Activate',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Brand'),
                      content: const Text('Are you sure you want to delete this brand?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm != true) return;

                  final result = await context.read<BrandsCubit>().deleteBrand(
                        brand.id!,
                      );

                  if (!context.mounted) return;

                  if (result.hasDataOnly) {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result.error.toString())),
                    );
                  }
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CreateBrandScreen extends StatefulWidget {
  const CreateBrandScreen({super.key});

  @override
  State<CreateBrandScreen> createState() => _CreateBrandScreenState();
}

class _CreateBrandScreenState extends State<CreateBrandScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<BrandsCubit>().resetCreateParams();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BrandsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Brand')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                cubit.createParams.name = value;
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) {
                cubit.createParams.description = value;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final isValid = _formKey.currentState?.validate() ?? false;
                if (!isValid) return;

                final result = await cubit.createBrand();

                if (!context.mounted) return;

                if (result.hasDataOnly) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Brand created successfully'),
                    ),
                  );

                  Navigator.pop(context, result.data);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.error.toString())),
                  );
                }
              },
              child: const Text('Create Brand'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditBrandScreen extends StatefulWidget {
  final BrandModel brand;

  const EditBrandScreen({
    super.key,
    required this.brand,
  });

  @override
  State<EditBrandScreen> createState() => _EditBrandScreenState();
}

class _EditBrandScreenState extends State<EditBrandScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    context.read<BrandsCubit>().setUpdateParams(widget.brand);

    _nameController = TextEditingController(text: widget.brand.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.brand.description ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BrandsCubit>();

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Brand')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (value) {
                cubit.updateParams?.name = value;
              },
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name is required';
                }

                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (value) {
                cubit.updateParams?.description = value;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final isValid = _formKey.currentState?.validate() ?? false;
                if (!isValid) return;

                final result = await cubit.updateBrand();

                if (!context.mounted) return;

                if (result.hasDataOnly) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Brand updated successfully'),
                    ),
                  );

                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.error.toString())),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}