import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../../../../core/di/service_locator.dart';
import '../blocs/product_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/search_sort_bar.dart';
import '../widgets/shimmer_loader.dart';
import '../widgets/category_filter_widget.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductBloc>()..add(LoadProductsEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('🛍️ Trending Products'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              const CategoryFilterWidget(),
              const SizedBox(height: 12),
              const SearchSortBar(),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ProductBloc, ProductState>(
                  builder: (context, state) {
                    if (state is ProductLoading) {
                      return const ShimmerLoader();
                    }

                    if (state is ProductLoaded) {
                      final products = state.products;

                      if (products.isEmpty) {
                        return const Center(
                          child: Text(
                            "😕 No products found in this category.",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        );
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: products.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(product: product);
                        },
                      );
                    }

                    if (state is ProductError) {
                      return Center(
                        child: Text(
                          "🚫 ${state.message}",
                          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
