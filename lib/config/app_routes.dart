import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/profile/screens/benefit_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/career_path_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/commission_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/page_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/personal_info_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/options_screen.dart';
import 'package:in_and_co_portal/features/trending/screens/trending_screen.dart';
import 'package:in_and_co_portal/screens/favorite_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/forgot_password_screen.dart';
import 'package:in_and_co_portal/features/home/screens/home_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/login_screen.dart';
import 'package:in_and_co_portal/layouts/main_layout.dart';
import 'package:in_and_co_portal/screens/not_found_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/profile_screen.dart';
import 'package:in_and_co_portal/features/search/screens/search_screen.dart';
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

final AuthNotifier authNotifier = AuthNotifier(); // Tạo AuthNotifier để theo dõi trạng thái đăng nhập

// Danh sách các route có BottomBar
final List<String> mainRoutes = [
  '/home',
  '/profile',
  '/trending',
  '/favorite',
  '/search',
];

// Danh sách các route có HeaderBar
final List<String> headerRoutes = [
  '/home',
];

// Danh sách các route không có AppBar
final List<String> appBarBackButtonRoutes  = [
  '/profile',
  '/profile/personal-info',
  '/profile/options',
  '/profile/commission',
  '/profile/page',
  '/profile/benefit',
  '/profile/career-path',
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
  // observers: [GetObserver()], // Thêm GetObserver để theo dõi navigation của GetX
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
        GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
        GoRoute(path: '/search', builder: (context, state) => SearchScreen()),
        GoRoute(path: '/trending', builder: (context, state) => TrendingScreen()),
        GoRoute(path: '/favorite', builder: (context, state) => FavoriteScreen()),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
          routes: [
            GoRoute(
              path: 'personal-info', 
              builder: (context, state) => PersonalInfoScreen(),
            ),
            GoRoute(
              path: 'options', 
              builder: (context, state) => OptionsScreen(),
            ),
            GoRoute(
              path: 'commission',
              builder: (context, state) => CommissionScreen(),
            ),
            GoRoute(
              path: 'page',
              builder: (context, state) => PageScreen(),
            ),
            GoRoute(
              path: 'benefit',
              builder: (context, state) => BenefitScreen(),
            ),
            GoRoute(
              path: 'career-path',
              builder: (context, state) => CareerPathScreen(),
            ),
          ],
        ),
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