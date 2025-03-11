import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/config/app_routes.dart';
import 'package:in_and_co_portal/theme/app_text.dart';
import 'package:in_and_co_portal/widgets/bottom_bar.dart';
import 'package:in_and_co_portal/widgets/header_bar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  
  const MainLayout({super.key, required this.child});
  String getTitle(String? path) {
    switch (path) {
      case '/home':
        return 'home_title'.tr;
      case '/profile':
        return 'profile_title'.tr;
      case '/trending':
        return 'trending_title'.tr;
      case '/favorite':
        return 'favorite_title'.tr;
      case '/search':
        return 'search_title'.tr;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentPath = GoRouterState.of(context).fullPath;
    final bool shouldShowMainRoute = mainRoutes.contains(currentPath);
    final bool shouldHeader = headerRoutes.contains(currentPath);
    final bool shouldBackBtn = appBarBackButtonRoutes.contains(currentPath);

    return Scaffold(
      appBar: shouldHeader || shouldBackBtn ? null : PreferredSize(
        preferredSize: const Size.fromHeight(34), // Chiều cao mới (mặc định là 56)
        child: AppBar(
          title: Text(getTitle(currentPath), style: AppText.headerTitle(context)),
          centerTitle: true,
          elevation: 0, 
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: shouldHeader ? 80 : 0,
            ),
            child: child
          ),
          if (shouldShowMainRoute)
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: BottomBar(),
          ),
          if(shouldHeader)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderBar()
          )
        ],
      ),
    );
  }
}
