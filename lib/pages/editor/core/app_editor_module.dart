import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';

/// 각 어플이 독립적으로 자신의 캔버스 아트보드와 인스펙터 편집기를 정의할 수 있는 모듈 인터페이스
abstract class AppEditorModule {
  ScreenTemplate get template;

  /// 피그마 캔버스 중앙에 배치될 실시간 아트보드 화면 위젯
  Widget buildCanvasArtboard(BuildContext context, bool isDarkMode);

  /// 우측 피그마 스타일 인스펙터 패널에 렌더링될 전용 속성 편집 위젯
  Widget buildInspector(BuildContext context, bool isDarkMode);

  /// 상단 툴바에 추가할 수 있는 앱별 특화 액션 버튼 (선택 사항)
  List<Widget> buildTopBarExtraActions(BuildContext context, bool isDarkMode) => const [];
}
