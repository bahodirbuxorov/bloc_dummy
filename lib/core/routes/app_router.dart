import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/service_locator.dart';
import '../../features/product/presentation/blocs/product_bloc.dart';
import '../../features/product/presentation/screens/add_product_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';

import '../root/root_navbar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ProductBloc>(),
        child: const MainNavScreen(),
      ),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const AddProductScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailScreen(productId: id);
      },
    ),
  ],
);
