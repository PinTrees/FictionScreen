import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/console_page.dart';
import '../pages/editor/app_editor_page.dart';
import '../pages/home_page.dart';
import '../pages/legal/legal_page.dart';
import '../pages/login_page.dart';
import '../pages/studio_page.dart';
import '../services/auth_service.dart';

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }
}

class AppRouter {
  static final AuthNotifier _authNotifier = AuthNotifier();

  static final GoRouter router = GoRouter(
    initialLocation: '/', // 앱 처음 실행 시 메인 랜딩 화면부터 표시
    refreshListenable: _authNotifier,
    redirect: (context, state) {
      final user = AuthService.currentUser;
      final isLoggedIn = user != null;
      final loc = state.matchedLocation;

      // Protected routes: /console, /studio, /editor (로그인 필수)
      final isProtectedRoute = loc.startsWith('/console') ||
          loc.startsWith('/studio') ||
          loc.startsWith('/editor');

      if (isProtectedRoute && !isLoggedIn) {
        // 비로그인 사용자는 무조건 로그인 화면으로 강제 이동
        return '/login';
      }

      if (loc == '/login' && isLoggedIn) {
        return '/console';
      }

      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('페이지를 찾을 수 없습니다: ${state.uri}'),
      ),
    ),
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/console',
        name: 'console',
        builder: (context, state) {
          final initialOs = state.uri.queryParameters['os'];
          return ConsolePage(initialOs: initialOs);
        },
      ),
      GoRoute(
        path: '/console/editor/:templateId',
        name: 'console-editor',
        builder: (context, state) {
          final templateId = state.pathParameters['templateId'] ?? 'kakaotalk';
          return AppEditorPage(templateId: templateId);
        },
      ),
      GoRoute(
        path: '/editor/:templateId',
        name: 'editor',
        builder: (context, state) {
          final templateId = state.pathParameters['templateId'] ?? 'kakaotalk';
          return AppEditorPage(templateId: templateId);
        },
      ),
      GoRoute(
        path: '/studio/:templateId',
        name: 'studio',
        builder: (context, state) {
          final templateId = state.pathParameters['templateId'] ?? 'kakaotalk';
          return StudioPage(templateId: templateId);
        },
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const LegalPage(initialTab: 'terms'),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const LegalPage(initialTab: 'privacy'),
      ),
    ],
  );
}
