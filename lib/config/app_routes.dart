import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/trending/screens/trending_screen.dart';
import 'package:in_and_co_portal/screens/favorite_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/forgot_password_screen.dart';
import 'package:in_and_co_portal/features/home/screens/home_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/login_screen.dart';
import 'package:in_and_co_portal/layouts/main_layout.dart';
import 'package:in_and_co_portal/screens/not_found_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/profile_screen.dart';
import 'package:in_and_co_portal/screens/search_screen.dart';
import 'package:in_and_co_portal/screens/splash.dart';
import 'package:in_and_co_portal/screens/upload_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/welcome_screen.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }
}

final AuthNotifier authNotifier = AuthNotifier();

// Danh sách các route có BottomBar
final List<String> mainRoutes = [
  '/home',
  '/profile',
  '/trending',
  '/favorite',
  '/search',
];

final List<String> headerRoutes = [
  '/home',
];

Page<dynamic> customPageTransition(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var fadeTween = Tween<double>(begin: 0.5, end: 1.0);
      var scaleTween = Tween<double>(begin: 0.95, end: 1.0);
      
      return FadeTransition(
        opacity: animation.drive(fadeTween),
        child: ScaleTransition(
          scale: animation.drive(scaleTween),
          child: child,
        ),
      );
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
    GoRoute(path: '/upload', builder: (context, state) => UploadScreen()),

    // Dùng ShellRoute để giữ lại MainLayout tránh load lại bottom bar
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(path: '/home', pageBuilder: (context, state) => customPageTransition(HomeScreen(), state)),
        GoRoute(path: '/search', pageBuilder: (context, state) => customPageTransition(SearchScreen(), state)),
        GoRoute(path: '/trending', pageBuilder: (context, state) => customPageTransition(TrendingScreen(), state)),
        GoRoute(path: '/favorite', pageBuilder: (context, state) => customPageTransition(FavoriteScreen(), state)),
        GoRoute(path: '/profile', pageBuilder: (context, state) => customPageTransition(ProfileScreen(), state)),
      ],
    ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(
      key: state.pageKey,
      child: NotFoundScreen()
    );
  },
);