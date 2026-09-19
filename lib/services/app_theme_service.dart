import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import 'auth_service.dart';

class AppThemeService extends ChangeNotifier {
  static final AppThemeService instance = AppThemeService._internal();
  AppThemeService._internal();

  static const String _storageKey = 'fiction_screen_theme_mode';

  // 기본값: 기기 설정값(ThemeMode.system)을 따름
  ThemeMode _themeMode = ThemeMode.system;
  bool _hasUserExplicitOverride = false;

  ThemeMode get themeMode => _themeMode;
  bool get hasUserExplicitOverride => _hasUserExplicitOverride;

  /// 현재 화면 컨텍스트 기준 다크모드 여부 반환
  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.dark) return true;
    if (_themeMode == ThemeMode.light) return false;
    return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
  }

  /// 앱 시작 시 초기화
  Future<void> initialize() async {
    // 1. 비로그인 유저 세션/로컬 스토리지에 저장된 테마 불러오기
    if (kIsWeb) {
      try {
        final saved = web.window.localStorage.getItem(_storageKey);
        if (saved == 'dark') {
          _themeMode = ThemeMode.dark;
          _hasUserExplicitOverride = true;
        } else if (saved == 'light') {
          _themeMode = ThemeMode.light;
          _hasUserExplicitOverride = true;
        }
      } catch (e) {
        debugPrint('[AppThemeService] 로컬 스토리지 테마 로드 오류: $e');
      }
    }

    // 2. 로그인 유저 상태 변화 구독: 로그인 시 Firestore에서 유저별 테마 설정 로드
    AuthService.authStateChanges.listen((user) async {
      if (user != null) {
        await _syncWithFirestore(user.uid);
      }
    });

    final currentUser = AuthService.currentUser;
    if (currentUser != null) {
      await _syncWithFirestore(currentUser.uid);
    }
  }

  /// Firestore 유저 테마 동기화 (불러오거나 현재 세션 설정 저장)
  Future<void> _syncWithFirestore(String uid) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('settings')
          .doc('theme_config');

      final doc = await docRef.get();
      if (doc.exists && doc.data() != null) {
        final savedMode = doc.data()!['themeMode'] as String?;
        if (savedMode == 'dark') {
          _themeMode = ThemeMode.dark;
          _hasUserExplicitOverride = true;
          notifyListeners();
          _saveToLocalStorage('dark');
          return;
        } else if (savedMode == 'light') {
          _themeMode = ThemeMode.light;
          _hasUserExplicitOverride = true;
          notifyListeners();
          _saveToLocalStorage('light');
          return;
        }
      }

      // 만약 Firestore에 저장된 값이 없는데, 세션 중 사용자가 테마를 변경한 적이 있다면 Firestore에 즉시 저장
      if (_hasUserExplicitOverride) {
        final modeStr = _themeMode == ThemeMode.dark ? 'dark' : 'light';
        await docRef.set({
          'themeMode': modeStr,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      debugPrint('[AppThemeService] Firestore 테마 동기화 오류: $e');
    }
  }

  /// 테마 토글 (Dark <-> Light)
  Future<void> toggleTheme(BuildContext context) async {
    final currentIsDark = isDarkMode(context);
    final targetMode = currentIsDark ? ThemeMode.light : ThemeMode.dark;
    await setThemeMode(targetMode);
  }

  /// 테마 모드 직접 지정
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    _hasUserExplicitOverride = (mode != ThemeMode.system);
    notifyListeners();

    final modeStr = mode == ThemeMode.dark
        ? 'dark'
        : (mode == ThemeMode.light ? 'light' : 'system');

    // 1. 브라우저 세션/로컬 스토리지에 메모리 & 전역 보관
    _saveToLocalStorage(modeStr);

    // 2. 로그인 상태인 경우 Firestore 유저 프로필 데이터에 저장
    final user = AuthService.currentUser;
    if (user != null && mode != ThemeMode.system) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('settings')
            .doc('theme_config')
            .set({
          'themeMode': modeStr,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('[AppThemeService] Firestore 테마 저장 실패: $e');
      }
    }
  }

  void _saveToLocalStorage(String value) {
    if (kIsWeb) {
      try {
        web.window.localStorage.setItem(_storageKey, value);
      } catch (e) {
        debugPrint('[AppThemeService] 로컬 스토리지 저장 실패: $e');
      }
    }
  }
}
