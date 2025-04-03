import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';
import '../blocs/product_bloc.dart';

class SearchSortBar extends StatefulWidget {
  const SearchSortBar({super.key});

  @override
  State<SearchSortBar> createState() => _SearchSortBarState();
}

class _SearchSortBarState extends State<SearchSortBar> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSort = "title_asc";

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(14);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  hintStyle: const TextStyle(fontSize: 14),
                  prefixIcon: const Icon(IconlyLight.search, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                onChanged: (query) {
                  context.read<ProductBloc>().add(SearchProductsEvent(query));
                },
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: borderRadius,
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedSort,
                borderRadius: borderRadius,
                icon: const Icon(IconlyLight.arrow_down_2),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: borderRadius,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  filled: true,
                  fillColor: Colors.white,
                ),
                items: const [
                  DropdownMenuItem(value: "title_asc", child: Text("A-Z")),
                  DropdownMenuItem(value: "title_desc", child: Text("Z-A")),
                  DropdownMenuItem(value: "price_asc", child: Text("Price ↑")),
                  DropdownMenuItem(value: "price_desc", child: Text("Price ↓")),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedSort = value);
                  final parts = value.split("_");
                  context.read<ProductBloc>().add(
                    SortProductsEvent(sortBy: parts[0], order: parts[1]),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
