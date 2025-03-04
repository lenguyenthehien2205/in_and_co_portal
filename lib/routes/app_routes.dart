import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/screens/explore_screen.dart';
import 'package:in_and_co_portal/screens/favorite_screen.dart';
import 'package:in_and_co_portal/screens/forgot_password_screen.dart';
import 'package:in_and_co_portal/screens/home_screen.dart';
import 'package:in_and_co_portal/screens/login_screen.dart';
import 'package:in_and_co_portal/screens/layouts/main_layout.dart';
import 'package:in_and_co_portal/screens/profile_screen.dart';
import 'package:in_and_co_portal/screens/search_screen.dart';
import 'package:in_and_co_portal/screens/splash.dart';
import 'package:in_and_co_portal/screens/welcome_screen.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }
}

final AuthNotifier authNotifier = AuthNotifier();

// Danh sách các route có BottomBar
final List<String> bottomBarRoutes = [
  '/home',
  '/profile',
  '/explore',
  '/favorite',
  '/search',
];

Page<dynamic> customPageTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      var tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
final GoRouter router = GoRouter(
  initialLocation: '/',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn = state.uri.path == '/login';
    final isForgotPassword = state.uri.path == '/forgot-password';

    if (state.uri.path == '/') {
      return null;
    }
    if (user == null && !isLoggingIn && !isForgotPassword) {
      return '/login';
    }
    if (user != null && isLoggingIn) { 
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => LoginScreen()),
    GoRoute(path: '/splash', builder: (context, state) => SplashScreen()),
    GoRoute(path: '/forgot-password', builder: (context, state) => ForgotPasswordScreen()),

    // Dùng ShellRoute để giữ lại MainLayout tránh load lại bottom bar
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(path: '/home', pageBuilder: (context, state) => customPageTransition(HomeScreen(), state)),
        GoRoute(path: '/search', pageBuilder: (context, state) => customPageTransition(SearchScreen(), state)),
        GoRoute(path: '/explore', pageBuilder: (context, state) => customPageTransition(ExploreScreen(), state)),
        GoRoute(path: '/favorite', pageBuilder: (context, state) => customPageTransition(FavoriteScreen(), state)),
        GoRoute(path: '/profile', pageBuilder: (context, state) => customPageTransition(ProfileScreen(), state)),
      ],
    ),
  ]
);