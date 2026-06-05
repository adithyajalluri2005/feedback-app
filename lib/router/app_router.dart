import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/feedback_list_screen.dart';
import '../screens/feedback_detail_screen.dart';
import '../models/feedback_item.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);

      // Wait for Firebase auth to finish initializing before redirecting
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull != null;
      final isOnLogin = state.matchedLocation == '/login';

      if (!isLoggedIn && !isOnLogin) return '/login';
      if (isLoggedIn && isOnLogin) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const FeedbackListScreen(),
        routes: [
          GoRoute(
            path: 'detail/:id',
            builder: (context, state) {
              final item = state.extra as FeedbackItem;
              return FeedbackDetailScreen(item: item);
            },
          ),
        ],
      ),
    ],
  );
});

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(Ref ref) {
    ref.listen(authStateProvider, (prev, next) => notifyListeners());
  }
}
