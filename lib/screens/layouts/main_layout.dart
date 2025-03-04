import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/routes/app_routes.dart';
import 'package:in_and_co_portal/widgets/bottom_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String? currentPath = GoRouterState.of(context).fullPath;
    final bool shouldShowBottomBar = bottomBarRoutes.contains(currentPath);

    return Scaffold(
      body: Stack(
        children: [
          child,
          if (shouldShowBottomBar)
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: BottomBar(),
          ),
        ],
      ),
      
    );
  }
}
