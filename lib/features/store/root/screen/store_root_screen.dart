import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store/features/home/screen/home_screen.dart';
import 'package:store/features/store/brands/screen/brands_screen.dart';
import 'package:store/features/store/categories/screen/categories_screen.dart';
import '../cubit/store_root_cubit.dart';

class StoreRootScreen extends StatelessWidget {
  const StoreRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreRootCubit, StoreRootState>(
      builder: (context, state) {
        final cubit = context.read<StoreRootCubit>();

        final screens = [
          const HomeScreen(),
          const CategoriesScreen(),
          const BrandsScreen(),
          const Center(child: Text('More')),
        ];

        return Scaffold(
          body: screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: cubit.changeTab,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined),
                activeIcon: Icon(Icons.inventory_2),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Categories',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_offer_outlined),
                activeIcon: Icon(Icons.local_offer),
                label: 'Brands',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.more_horiz),
                label: 'More',
              ),
            ],
          ),
        );
      },
    );
  }
}
