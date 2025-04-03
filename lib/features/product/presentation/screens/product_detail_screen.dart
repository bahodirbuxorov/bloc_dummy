import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/models/product_model.dart';
import '../widgets/product_detail_image.dart';
import '../widgets/product_info_card.dart';
import '../widgets/product_price_tile.dart';
import '../widgets/product_gallery.dart';
import '../widgets/product_action_bar.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  Future<ProductModel> fetchProduct() async {
    return await ProductRemoteDataSource().getProductById(productId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductModel>(
      future: fetchProduct(),
      builder: (context, snapshot) {
        final isLoading = snapshot.connectionState == ConnectionState.waiting;

        final product = snapshot.data ??
            ProductModel(
              id: 0,
              title: '',
              description: '',
              price: 0.0,
              thumbnail: '',
              rating: 0,
              category: '',
              brand: '',
              images: const [],
            );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isLoading ? 'Loading...' : product.title,
              overflow: TextOverflow.ellipsis,
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go("/"),
            ),
          ),
          bottomNavigationBar:
          isLoading ? null : ProductActionBar(product: product),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailImage(
                  imageUrl: product.thumbnail,
                  isLoading: snapshot.connectionState == ConnectionState.waiting,
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductPriceTile(
                        price: product.price,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 16),
                      ProductInfoCard(
                        product: product,
                        isLoading: isLoading,
                      ),
                      const SizedBox(height: 24),
                      if (!isLoading && product.images.isNotEmpty)
                        ProductGallery(images: product.images),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
