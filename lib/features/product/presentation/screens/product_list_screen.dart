import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product_bloc.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../domain/usecases/get_all_products_usecase.dart';
import '../widgets/product_card.dart';
import '../widgets/search_sort_bar.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/category_filter_widget.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(
        getAllProductsUseCase: GetAllProductsUseCase(ProductRemoteDataSource()),
        dataSource: ProductRemoteDataSource(), // ✅
      )..add(LoadProductsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('🛍️ Trending Products'),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            const CategoryFilterWidget(),
            const SizedBox(height: 8),
            const SearchSortBar(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const ShimmerLoader();
                  }

                  if (state is ProductLoaded) {
                    final products = state.products;

                    if (products.isEmpty) {
                      return const Center(child: Text("No products found in this category."));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(product: product);
                      },
                    );
                  }

                  if (state is ProductError) {
                    return Center(child: Text(state.message));
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),

      ),
    );
  }
}
