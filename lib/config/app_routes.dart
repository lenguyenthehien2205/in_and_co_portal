import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:in_and_co_portal/features/chat/screens/chat_screen.dart';
import 'package:in_and_co_portal/features/chat/screens/conversations_screen.dart';
import 'package:in_and_co_portal/features/home/screens/notification_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/add_schedule_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/business_itinerary_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/pending_post_screen.dart';
import 'package:in_and_co_portal/features/post/screens/add_post_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/add_task_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/benefit_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/career_path_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/commission_screen.dart';
import 'package:in_and_co_portal/features/post/screens/post_detail_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/page_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/personal_info_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/settings_screen.dart';
import 'package:in_and_co_portal/features/search/screens/result_search_screen.dart';
import 'package:in_and_co_portal/features/trending/screens/trending_screen.dart';
import 'package:in_and_co_portal/features/overview/screens/overview_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/forgot_password_screen.dart';
import 'package:in_and_co_portal/features/home/screens/home_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/login_screen.dart';
import 'package:in_and_co_portal/layouts/main_layout.dart';
import 'package:in_and_co_portal/main.dart';
import 'package:in_and_co_portal/theme/screens/not_found_screen.dart';
import 'package:in_and_co_portal/features/profile/screens/profile_screen.dart';
import 'package:in_and_co_portal/features/search/screens/search_screen.dart';
import 'package:in_and_co_portal/theme/screens/splash.dart';
import 'package:in_and_co_portal/theme/screens/upload_screen.dart';
import 'package:in_and_co_portal/features/auth/screens/welcome_screen.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      notifyListeners();
    });
  }
}

final AuthNotifier authNotifier =
    AuthNotifier(); // Tạo AuthNotifier để theo dõi trạng thái đăng nhập

// Danh sách các route có BottomBar
final List<String> mainRoutes = [
  '/home',
  '/profile',
  '/trending',
  '/overview',
  '/search',
];

// Danh sách các route có HeaderBar
final List<String> headerRoutes = ['/home'];

// Danh sách các route không có AppBar
final List<String> appBarBackButtonRoutes = [
  '/add-post',

  '/profile',
  '/profile/personal-info',
  '/profile/settings',
  '/profile/page/:userId',

  '/overview/commission',
  '/overview/benefit',
  '/overview/career-path',
  '/overview/career-path/add-task',
  '/overview/pending-posts',
  '/overview/business-itinerary',
  '/overview/business-itinerary/add-schedule',

  '/search/result',
  '/home/notification',
  '/post-detail/:postId',
  '/conversations',
  '/conversations/chat/:conversationId',
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
  navigatorKey: navigatorKey,
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
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(path: '/upload', builder: (context, state) => UploadScreen()),

    // Dùng ShellRoute để giữ lại MainLayout tránh load lại bottom bar
    ShellRoute(
      builder: (context, state, child) {
        return MainLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home', 
          builder: (context, state) => HomeScreen(), 
          routes: [
            GoRoute(path: '/notification', builder: (context, state) => NotificationScreen()),
          ]
        ),
        GoRoute(
          path: '/conversations', 
          builder: (context, state) => ConversationsScreen(),
          routes: [
            GoRoute(path: '/chat/:conversationId', builder: (context, state) {
              final String? conversationId = state.pathParameters['conversationId'];
              if (conversationId == null) {
                return Scaffold(
                  body: Center(child: Text("Lỗi: Không có userId!")),
                );
              }
              return ChatScreen(conversationId: conversationId);
            }),
          ],
        ),
        GoRoute(path: '/add-post', builder: (context, state) => AddPostScreen()),
        GoRoute(
          path: '/post-detail/:postId',
          builder: (context, state) {
            final String? postId = state.pathParameters['postId'];
            if (postId == null) {
              return Scaffold(
                body: Center(child: Text("Lỗi: Không có postId!")),
              );
            }
            return PostDetailScreen(postId: postId);
          },
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => SearchScreen(),
          routes: [
            GoRoute(
              path: 'result',
              builder: (context, state) {
                return ResultSearchScreen();
              },
            ),
          ],
        ),
        GoRoute(
          path: '/trending',
          builder: (context, state) => TrendingScreen(),
        ),
        GoRoute(
          path: '/overview',
          builder: (context, state) => OverviewScreen(),
          routes: [
            GoRoute(
              path: 'business-itinerary',
              builder: (context, state) => BusinessItineraryScreen(),
              routes: [
                GoRoute(path: 'add-schedule', builder: (context, state) {
                  return AddScheduleScreen();
                }),
              ]
            ),
            GoRoute(
              path: 'commission',
              builder: (context, state) => CommissionScreen(),
            ),
            GoRoute(
              path: 'benefit',
              builder: (context, state) => BenefitScreen(),
            ),
            GoRoute(
              path: 'career-path',
              builder: (context, state) => CareerPathScreen(),
              routes: [
                GoRoute(
                  path: 'add-task',
                  builder: (context, state) => AddTaskScreen(),
                ),
              ],
            ),
            GoRoute(
              path: 'pending-posts',
              builder: (context, state) => PendingPostScreen(),
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
          routes: [
            GoRoute(
              path: 'personal-info',
              builder: (context, state) => PersonalInfoScreen(),
            ),
            GoRoute(
              path: 'page/:userId', 
              builder: (context, state) {
                final String? userId = state.pathParameters['userId'];
                if(userId == null) {
                  return Scaffold(
                    body: Center(child: Text("Lỗi: Không có userId!")),
                  );
                }
                return PageScreen(userId: userId);
              }
            ),
            GoRoute(
              path: 'settings',
              builder: (context, state) => SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  errorPageBuilder: (context, state) {
    return MaterialPage(key: state.pageKey, child: NotFoundScreen());
  },
);
