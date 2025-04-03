import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../blocs/crud/product_crud_bloc.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _thumbController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _thumbController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final data = {
        "title": _titleController.text,
        "description": _descController.text,
        "price": double.tryParse(_priceController.text) ?? 0.0,
        "category": _categoryController.text,
        "thumbnail": _thumbController.text,
      };

      context.read<ProductCrudBloc>().add(AddProductEvent(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCrudBloc(remoteDataSource: ProductRemoteDataSource()),
      child: BlocListener<ProductCrudBloc, ProductCrudState>(
        listener: (context, state) {
          if (state is ProductCrudSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context); // Go back on success
          } else if (state is ProductCrudFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text("➕ Add Product")),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  _buildTextField(_titleController, "Title"),
                  const SizedBox(height: 12),
                  _buildTextField(_descController, "Description"),
                  const SizedBox(height: 12),
                  _buildTextField(_priceController, "Price", keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  _buildTextField(_categoryController, "Category"),
                  const SizedBox(height: 12),
                  _buildTextField(_thumbController, "Thumbnail URL"),
                  const SizedBox(height: 24),
                  BlocBuilder<ProductCrudBloc, ProductCrudState>(
                    builder: (context, state) {
                      final isLoading = state is ProductCrudLoading;
                      return ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        onPressed: isLoading ? null : () => _submit(context),
                        label: isLoading
                            ? const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Text("Add Product"),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
    );
  }
}
