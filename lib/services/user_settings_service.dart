import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'auth_service.dart';

class UserOsSettings {
  final String pcTheme;
  final String windowsVersion;
  final String mobileTheme;
  final String galaxyVersion;
  final String wallpaper;

  UserOsSettings({
    this.pcTheme = 'windows',
    this.windowsVersion = '11',
    this.mobileTheme = 'ios',
    this.galaxyVersion = '9',
    this.wallpaper = 'win10_hero',
  });

  Map<String, dynamic> toMap() {
    return {
      'pcTheme': pcTheme,
      'windowsVersion': windowsVersion,
      'mobileTheme': mobileTheme,
      'galaxyVersion': galaxyVersion,
      'wallpaper': wallpaper,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserOsSettings.fromMap(Map<String, dynamic>? map) {
    if (map == null) return UserOsSettings();
    return UserOsSettings(
      pcTheme: map['pcTheme'] as String? ?? 'windows',
      windowsVersion: map['windowsVersion'] as String? ?? '11',
      mobileTheme: map['mobileTheme'] as String? ?? 'ios',
      galaxyVersion: map['galaxyVersion'] as String? ?? '9',
      wallpaper: map['wallpaper'] as String? ?? 'win10_hero',
    );
  }
}

class UserSettingsService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// 유저별 OS 설정 Firestore 저장
  static Future<void> saveOsSettings(UserOsSettings settings) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('os_config')
          .set(settings.toMap(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('[UserSettingsService] Firestore 저장 실패: $e');
    }
  }

  /// 유저별 OS 설정 Firestore 불러오기
  static Future<UserOsSettings?> loadOsSettings() async {
    final user = AuthService.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('settings')
          .doc('os_config')
          .get();

      if (doc.exists && doc.data() != null) {
        return UserOsSettings.fromMap(doc.data());
      }
    } catch (e) {
      debugPrint('[UserSettingsService] Firestore 불러오기 실패: $e');
    }
    return null;
  }
}
