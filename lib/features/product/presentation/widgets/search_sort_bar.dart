import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (query) {
                final bloc = context.read<ProductBloc>();
                debugPrint("Query sent: $query");
                bloc.add(SearchProductsEvent(query));
              },

            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              value: _selectedSort,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
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
                final parts = value.split("_"); // ["title", "asc"]
                context.read<ProductBloc>().add(
                  SortProductsEvent(sortBy: parts[0], order: parts[1]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
