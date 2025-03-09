import 'package:flutter/material.dart';
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
        return 'Trang chủ';
      case '/profile':
        return 'Hồ sơ';
      case '/trending':
        return 'Thịnh hành';
      case '/favorite':
        return 'Yêu thích';
      case '/search':
        return 'Tìm kiếm';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? currentPath = GoRouterState.of(context).fullPath;
    final bool shouldShowMainRoute = mainRoutes.contains(currentPath);
    final bool shouldHeader = headerRoutes.contains(currentPath);
    final bool isProfile = currentPath == '/profile';

    return Scaffold(
      appBar: shouldHeader || isProfile ? null : PreferredSize(
        preferredSize: const Size.fromHeight(34), // Chiều cao mới (mặc định là 56)
        child: AppBar(
          title: Text(getTitle(currentPath), style: AppText.headerTitle),
          centerTitle: true,
          elevation: 0, 
          backgroundColor: Colors.white,
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
