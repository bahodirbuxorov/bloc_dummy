import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/service_locator.dart';
import '../../../product/data/models/product_model.dart';
import '../blocs/crud/product_crud_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();

  ProductModel? _addedProduct;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        "title": _titleController.text,
        "description": _descController.text,
        "price": double.tryParse(_priceController.text) ?? 0.0,
        "thumbnail": _imageUrlController.text,
        "category": _categoryController.text,
      };

      context.read<ProductCrudBloc>().add(AddProductEvent(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCrudBloc>(),
      child: Builder(
        builder: (newContext) => Scaffold(
          appBar: AppBar(title: const Text('➕ Add New Product')),
          body: BlocListener<ProductCrudBloc, ProductCrudState>(
            listener: (context, state) {
              if (state is ProductCrudSuccess) {
                setState(() {
                  _addedProduct = state.product;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Product successfully added!'), backgroundColor: Colors.green),
                );
              }

              if (state is ProductCrudFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
            child: _buildForm(newContext),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _buildTextField(controller: _titleController, label: 'Title'),
            _buildTextField(controller: _descController, label: 'Description', maxLines: 3),
            _buildTextField(
              controller: _priceController,
              label: 'Price',
              inputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                if (double.tryParse(value) == null) return 'Must be a number';
                return null;
              },
            ),
            _buildTextField(controller: _imageUrlController, label: 'Image URL'),
            _buildTextField(controller: _categoryController, label: 'Category'),
            const SizedBox(height: 24),
            BlocBuilder<ProductCrudBloc, ProductCrudState>(
              builder: (context, state) {
                return ElevatedButton.icon(
                  onPressed: state is ProductCrudLoading ? null : () => _submit(context),
                  icon: const Icon(Icons.save),
                  label: Text(state is ProductCrudLoading ? 'Saving...' : 'Submit'),
                );
              },
            ),
            const SizedBox(height: 24),

            if (_addedProduct != null) _buildPreview(_addedProduct!),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview(ProductModel product) {
    return Card(
      color: Colors.green.shade50,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("🆕 Product Preview", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Image.network(product.thumbnail, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 12),
            Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.description),
            Text("💲 ${product.price.toStringAsFixed(2)}"),
            Text("📦 ${product.category}"),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: validator ?? (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }
}
