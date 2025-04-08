import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/product_model.dart';
import '../blocs/crud/product_crud_bloc.dart';
import '../../../../core/di/service_locator.dart';

class DeleteProductPage extends StatelessWidget {
  final ProductModel product;

  const DeleteProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCrudBloc>(),
      child: _DeleteProductView(product: product),
    );
  }
}

class _DeleteProductView extends StatelessWidget {
  final ProductModel product;

  const _DeleteProductView({required this.product});

  void _deleteProduct(BuildContext context) {
    context.read<ProductCrudBloc>().add(DeleteProductEvent(product.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete Product")),
      body: BlocConsumer<ProductCrudBloc, ProductCrudState>(
        listener: (context, state) {
          if (state is ProductCrudSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Product deleted")),
            );
            if (context.canPop()) context.pop();
          } else if (state is ProductCrudFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${product.id}", style: const TextStyle(fontWeight: FontWeight.bold)),
                Text("Title: ${product.title}"),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: state is ProductCrudLoading ? null : () => _deleteProduct(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: state is ProductCrudLoading
                      ? const CircularProgressIndicator()
                      : const Text("Confirm Delete"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
