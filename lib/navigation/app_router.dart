import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/console_page.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/studio_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // 앱 처음 실행 시 메인 랜딩 화면부터 표시
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
        builder: (context, state) => const ConsolePage(),
      ),
      GoRoute(
        path: '/studio/:templateId',
        name: 'studio',
        builder: (context, state) {
          final templateId = state.pathParameters['templateId'] ?? 'kakaotalk';
          return StudioPage(templateId: templateId);
        },
      ),
    ],
  );
}
