import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/home_cubit.dart';
import '../data/model/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Store Products'),
        ),
        body: PaginationList<ProductModel>(
          withPagination: true,
          repositoryCallBack: (data) {
            return context.read<HomeCubit>().fetchProducts(data);
          },
          listBuilder: (products) {
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(product.name?.substring(0, 1) ?? '?'),
                    ),
                    title: Text(product.name ?? 'No name'),
                    subtitle: Text(
                      'Stock: ${product.totalVariantStock ?? 0} | ${product.brandName ?? ''}',
                    ),
                    trailing: Text('${product.price ?? 0}'),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}