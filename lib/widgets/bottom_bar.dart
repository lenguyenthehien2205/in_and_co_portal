import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/theme/app_colors.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  /// Widget tạo IconButton thay đổi kích thước theo route
  Widget _buildNavItem(BuildContext context, 
      {required IconData icon, required String route, required String? currentPath}) {
    bool isSelected = currentPath == route;

    return IconButton(
      icon: CircleAvatar(
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        radius: 20, // Tăng size nếu đang ở route hiện tại
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.black,
          size: 20, // Tăng icon nếu đang ở route hiện tại
        ),
      ),
      onPressed: () {
        context.go(route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final String? currentPath = GoRouterState.of(context).fullPath;

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(66, 104, 104, 104),
            blurRadius: 10,
            spreadRadius: 1.5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home,
            route: '/home',
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.search,
            route: '/search',
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.explore_outlined,
            route: '/trending',
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.corporate_fare,
            route: '/overview',
            currentPath: currentPath,
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            route: '/profile',
            currentPath: currentPath,
          ),
        ],
      ),
    );
  }
}
