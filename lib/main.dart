import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'navigation/app_router.dart';
import 'services/firebase_service.dart';
import 'style/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  // Firebase 사전 준비 (사용자가 연동값 제공 시 즉각 연결)
  await FirebaseService.initialize();

  runApp(const FictionScreenApp());
}

class FictionScreenApp extends StatelessWidget {
  const FictionScreenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FictionScreen | 가짜 화면 스튜디오',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: AppRouter.router,
    );
  }
}
