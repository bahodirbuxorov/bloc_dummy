import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';

class ProductInfoCard extends StatelessWidget {
  final ProductModel product;

  const ProductInfoCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Wrap(
          runSpacing: 8,
          children: [
            _infoRow(Icons.star, 'Rating', product.rating.toString()),
            _infoRow(Icons.category, 'Category', product.category),
            _infoRow(Icons.business, 'Brand', product.brand),
          ],
        ),
      ],
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
