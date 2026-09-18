import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class FunctionsService {
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;

  /// 서버 헬스체크 또는 템플릿 목록 조회
  static Future<List<dynamic>> fetchRemoteTemplates() async {
    try {
      final callable = _functions.httpsCallable('getTemplates');
      final result = await callable.call();
      final data = result.data as Map<String, dynamic>?;
      return data?['templates'] as List<dynamic>? ?? [];
    } catch (e) {
      debugPrint('[FunctionsService] getTemplates error: $e');
      return [];
    }
  }

  /// AI 시나리오 자동 생성 (Cloud Functions)
  static Future<Map<String, dynamic>?> generateScenario({
    required String topic,
    String type = 'kakaotalk',
  }) async {
    try {
      final callable = _functions.httpsCallable('generateScenario');
      final result = await callable.call({
        'topic': topic,
        'type': type,
      });
      return Map<String, dynamic>.from(result.data as Map);
    } catch (e) {
      debugPrint('[FunctionsService] generateScenario error: $e');
      return null;
    }
  }
}
