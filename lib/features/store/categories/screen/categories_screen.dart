import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/categories_cubit.dart';
import '../data/model/category_model.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        final cubit = context.read<CategoriesCubit>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Categories'),
          ),
          body: PaginationList<CategoryModel>(
            key: ValueKey(cubit.refreshKey),
            withPagination: false,
            repositoryCallBack: (data) {
              return cubit.fetchCategories();
            },
            listBuilder: (categories) {
              if (categories.isEmpty) {
                return const Center(child: Text('No categories found'));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(category.name?.substring(0, 1) ?? '?'),
                      ),
                      title: Text(category.name ?? 'No name'),
                      subtitle: Text(category.description ?? 'No description'),
                      trailing: category.isActive == true
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
                  builder: (_) => const CreateCategoryScreen(),
                ),
              );

              if (result != null && context.mounted) {
                context.read<CategoriesCubit>().refreshCategories();
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().resetCreateParams();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CategoriesCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
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
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
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

                final result = await cubit.createCategory();

                if (!context.mounted) return;

                if (result.hasDataOnly) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category created successfully')),
                  );

                  Navigator.pop(context, result.data);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result.error.toString())),
                  );
                }
              },
              child: const Text('Create Category'),
            ),
          ],
        ),
      ),
    );
  }
}