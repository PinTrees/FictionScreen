import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'navigation/app_router.dart';
import 'services/app_theme_service.dart';
import 'services/firebase_service.dart';
import 'style/app_theme.dart';

import 'package:web/web.dart' as web;
import 'dart:js_interop';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 웹 브라우저 기본 우클릭 메뉴(검사, 뒤로 등) 차단 및 가상 OS 우클릭 메뉴 전용 처리
  if (kIsWeb) {
    try {
      web.window.addEventListener(
        'contextmenu',
        (web.Event event) {
          event.preventDefault();
        }.toJS,
      );
    } catch (e) {
      debugPrint('[Main] Prevent context menu error: $e');
    }
  }

  // 웹 URL의 '#' 해시 제거
  try {
    usePathUrlStrategy();
  } catch (e) {
    debugPrint('[Main] UrlStrategy error: $e');
  }

  // 다국어 날짜 포맷 로케일 데이터 초기화 (ko_KR 필수)
  try {
    await initializeDateFormatting('ko_KR', null);
  } catch (e) {
    debugPrint('[Main] initializeDateFormatting error: $e');
  }

  // Firebase 사전 준비
  await FirebaseService.initialize();

  // 전역 다크/라이트 테마 서비스 초기화 (세션 및 유저 데이터 동기화)
  await AppThemeService.instance.initialize();

  runApp(const FictionScreenApp());
}

class FictionScreenApp extends StatelessWidget {
  const FictionScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppThemeService.instance,
      builder: (context, _) {
        return MaterialApp.router(
          title: 'FictionScreen | 가짜 화면 스튜디오',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: AppThemeService.instance.themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
