import 'package:bloc_dummy/features/product/presentation/screens/add_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';


class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ProductListScreen(),
    AddProductScreen(),

  ];

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(icon: Icon(IconlyLight.home), label: "Home"),
    BottomNavigationBarItem(icon: Icon(IconlyLight.plus), label: "Add product"),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: _navItems,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 10,
      ),
    );
  }
}
