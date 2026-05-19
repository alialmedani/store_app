import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/boilerplate/get_model/widgets/get_model.dart';

import '../cubit/product_details_cubit.dart';
import '../data/model/product_details_model.dart';

class ProductDetailsScreen extends StatelessWidget {
  final int productId;

  const ProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Product Details'),
        ),
        body: GetModel<ProductDetailsModel>(
          useCaseCallBack: () {
            return context.read<ProductDetailsCubit>().fetchProductDetails(productId);
          },
          modelBuilder: (product) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (product.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      product.imageUrl!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),

                const SizedBox(height: 16),

                Text(
                  product.name ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${product.price ?? 0}',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),

                const SizedBox(height: 16),

                Text(product.description ?? ''),

                const SizedBox(height: 24),

                Text(
                  'Category: ${product.category?.name ?? ''}',
                ),

                const SizedBox(height: 8),

                Text(
                  'Brand: ${product.brand?.name ?? ''}',
                ),

                const SizedBox(height: 8),

                Text(
                  'Stock: ${product.totalVariantStock ?? 0}',
                ),

                const SizedBox(height: 24),

                const Text(
                  'Colors & Sizes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                ...?product.colors?.map(
                  (color) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            color.color ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            children: color.sizes
                                    ?.map(
                                      (size) => Chip(
                                        label: Text(
                                          '${size.size} (${size.quantity})',
                                        ),
                                      ),
                                    )
                                    .toList() ??
                                [],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}