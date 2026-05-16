import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import '../features/auth/controllers/auth_controller.dart';
import '../features/buyer/navigation/buyer_navigation_screen.dart';
import '../features/seller/navigation/seller_navigation_screen.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/splash_screen.dart';
import '../features/auth/views/role_selection_screen.dart';
import '../features/auth/views/register/buyer_register_screen.dart';
import '../features/auth/views/register/seller_register_screen.dart';
import '../features/auth/views/forgot_password/forgot_password_screen.dart';
import '../features/auth/views/forgot_password/otp_verification_screen.dart';
import '../features/auth/views/forgot_password/reset_password_screen.dart';
import '../features/auth/views/forgot_password/success_screen.dart';
import '../features/buyer/home/screens/home_screen.dart';
import '../features/buyer/home/screens/trending_screen.dart';
import '../features/buyer/home/screens/following_screen.dart';
import '../features/buyer/home/screens/live_list_screen.dart';
import '../features/buyer/discover/discover_screen.dart';
import '../features/buyer/live/live_screen.dart';
import '../features/buyer/inbox/inbox_screen.dart';
import '../features/buyer/profile/profile_screen.dart';
import '../features/seller/dashboard/dashboard_screen.dart';
import '../features/seller/products/products_screen.dart';
import '../features/seller/live/live_screen.dart';
import '../features/seller/orders/orders_screen.dart';
import '../features/seller/profile/profile_screen.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }
  late final StreamSubscription<dynamic> _subscription;
  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppPages {
  AppPages._();

  static final rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      StreamGroup.merge([
        Get.find<AuthController>().isAuthenticated.stream,
        Get.find<AuthController>().userRole.stream,
      ]),
    ),
    redirect: (context, state) {
      final authController = Get.find<AuthController>();
      final isAuth = authController.isAuthenticated.value;
      final role = authController.userRole.value;
      
      final isSplash = state.matchedLocation == AppRoutes.splash;
      final isRoleSelection = state.matchedLocation == AppRoutes.roleSelection;
      final isLogin = state.matchedLocation == AppRoutes.login;
      final isRegister = state.matchedLocation.startsWith('/register');
      final isForgotPassword = state.matchedLocation == AppRoutes.forgotPassword ||
          state.matchedLocation == AppRoutes.otpVerification ||
          state.matchedLocation == AppRoutes.resetPassword ||
          state.matchedLocation == AppRoutes.passwordSuccess;

      final isAuthRoute = isSplash || isRoleSelection || isLogin || isRegister || isForgotPassword;

      if (!isAuth) {
        return isAuthRoute ? null : AppRoutes.splash;
      }

      if (isAuthRoute) {
        if (role == UserRole.buyer) {
          return AppRoutes.buyerHome;
        } else if (role == UserRole.seller) {
          return AppRoutes.sellerDashboard;
        }
      }

      final isBuyerRoute = state.matchedLocation.startsWith('/buyer');
      final isSellerRoute = state.matchedLocation.startsWith('/seller');

      if (role == UserRole.buyer && isSellerRoute) return AppRoutes.buyerHome;
      if (role == UserRole.seller && isBuyerRoute) return AppRoutes.sellerDashboard;

      if (state.matchedLocation == '/') {
        return (role == UserRole.seller) ? AppRoutes.sellerDashboard : AppRoutes.buyerHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.roleSelection,
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.buyer;
          return LoginScreen(role: role);
        },
      ),
      GoRoute(
        path: AppRoutes.registerBuyer,
        builder: (context, state) => const BuyerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.registerSeller,
        builder: (context, state) => const SellerRegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.otpVerification,
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: AppRoutes.resetPassword,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.passwordSuccess,
        builder: (context, state) => const PasswordSuccessScreen(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BuyerNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerHome,
                builder: (context, state) => const BuyerHomeScreen(),
              ),
              GoRoute(
                path: AppRoutes.trending,
                builder: (context, state) => const TrendingScreen(),
              ),
              GoRoute(
                path: AppRoutes.following,
                builder: (context, state) => const FollowingScreen(),
              ),
              GoRoute(
                path: AppRoutes.liveNow,
                builder: (context, state) => const LiveListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerDiscover,
                builder: (context, state) => const DiscoverScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerLive,
                builder: (context, state) => const BuyerLiveScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerInbox,
                builder: (context, state) => const InboxScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.buyerProfile,
                builder: (context, state) => const BuyerProfileScreen(),
              ),
            ],
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return SellerNavigationScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerDashboard,
                builder: (context, state) => const SellerDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerProducts,
                builder: (context, state) => const ProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerLive,
                builder: (context, state) => const SellerLivestreamScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerOrders,
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.sellerProfile,
                builder: (context, state) => const SellerProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class StreamGroup {
  static Stream<T> merge<T>(Iterable<Stream<T>> streams) {
    final controller = StreamController<T>();
    final subscriptions = <StreamSubscription<T>>[];
    
    void onDone(StreamSubscription<T> sub) {
      subscriptions.remove(sub);
      if (subscriptions.isEmpty) {
        controller.close();
      }
    }

    for (var stream in streams) {
      late StreamSubscription<T> sub;
      sub = stream.listen(
        controller.add,
        onError: controller.addError,
        onDone: () => onDone(sub),
      );
      subscriptions.add(sub);
    }
    
    return controller.stream;
  }
}
