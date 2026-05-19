import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/core/utils/Navigation/navigation.dart';
import 'package:store/features/store/create_product/screen/create_product_screen.dart';
import 'package:store/features/store/product_details/screen/product_details_screen.dart';

import '../../../../core/boilerplate/pagination/widgets/pagination_list.dart';
import '../cubit/home_cubit.dart';
import '../data/model/product_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();

        return Scaffold(
          appBar: AppBar(title: const Text('Store Products')),
          body: PaginationList<ProductModel>(
            key: ValueKey(cubit.refreshKey),
            withPagination: false,
            repositoryCallBack: (data) {
              return cubit.fetchProducts(data);
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

                  return InkWell(
                    onTap: () {
                      Navigation.push(
                        ProductDetailsScreen(productId: product.id!),
                      );
                    },
                    child: Card(
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
                MaterialPageRoute(builder: (_) => const CreateProductScreen()),
              );

              if (result != null && context.mounted) {
                context.read<HomeCubit>().refreshProducts();
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
