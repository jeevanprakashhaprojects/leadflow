import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/add_lead_screen/add_lead_screen.dart';
import '../presentation/leads_list_screen/leads_list_screen.dart';
import '../presentation/analytics_screen/analytics_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/notifications_screen/notifications_screen.dart';
import '../presentation/lead_detail_screen/lead_detail_screen.dart';
import '../presentation/sign_up_login_screen/anbu_login_screen.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/welcome_screen/welcome_screen.dart';
import '../presentation/forgot_password_screen/forgot_password_screen.dart';
import '../presentation/buy_product_screen/buy_product_screen.dart';
import '../presentation/create_account_screen/create_account_screen.dart';
import '../presentation/calls_permission_screen/calls_permission_screen.dart';
import '../presentation/sim_selection_screen/sim_selection_screen.dart';
import '../widgets/app_scaffold.dart';

class AppRoutes {
  static const String initial = '/';
  static const String splashScreen = '/splash';
  static const String welcomeScreen = '/welcome';
  static const String signUpLoginScreen = '/sign-up-login-screen';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String buyProductScreen = '/buy-product';
  static const String createAccountScreen = '/create-account';
  static const String callsPermissionScreen = '/calls-permission';
  static const String simSelectionScreen = '/sim-selection';
  static const String leadsListScreen = '/leads-list-screen';
  static const String addLeadScreen = '/add-lead-screen';
  static const String analyticsScreen = '/analytics-screen';
  static const String profileScreen = '/profile-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String leadDetailScreen = '/lead-detail-screen';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.initial,
  routes: [
    // Splash — entry point
    GoRoute(
      path: AppRoutes.initial,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SplashScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 300),
      ),
    ),
    // Welcome screen
    GoRoute(
      path: AppRoutes.welcomeScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const WelcomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              ),
              child: child,
            ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
    // Login screen
    GoRoute(
      path: AppRoutes.signUpLoginScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AnbuLoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Forgot password
    GoRoute(
      path: AppRoutes.forgotPasswordScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Buy product onboarding
    GoRoute(
      path: AppRoutes.buyProductScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const BuyProductScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    ),
    // Create Account
    GoRoute(
      path: AppRoutes.createAccountScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CreateAccountScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Calls Permission
    GoRoute(
      path: AppRoutes.callsPermissionScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const CallsPermissionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // SIM Selection
    GoRoute(
      path: AppRoutes.simSelectionScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SimSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Notifications (standalone)
    GoRoute(
      path: AppRoutes.notificationsScreen,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const NotificationsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide =
              Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              );
          return SlideTransition(position: slide, child: child);
        },
        transitionDuration: const Duration(milliseconds: 320),
      ),
    ),
    // Lead Detail (standalone)
    GoRoute(
      path: AppRoutes.leadDetailScreen,
      pageBuilder: (context, state) {
        final lead = state.extra as LeadModel;
        return CustomTransitionPage(
          key: state.pageKey,
          child: LeadDetailScreen(lead: lead),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final slide =
                Tween<Offset>(
                  begin: const Offset(1.0, 0),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  ),
                );
            return SlideTransition(position: slide, child: child);
          },
          transitionDuration: const Duration(milliseconds: 320),
        );
      },
    ),
    // Main app shell (post-login) — 4 tabs
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.leadsListScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: LeadsListScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.addLeadScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AddLeadScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.analyticsScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: AnalyticsScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profileScreen,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
