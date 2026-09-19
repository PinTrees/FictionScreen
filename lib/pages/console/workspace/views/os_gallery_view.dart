import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../constants/app_platform_icons.dart';
import '../../../../widgets/scale_button.dart';

class OsGalleryView extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<String> onSelectOs;

  const OsGalleryView({
    super.key,
    required this.isDarkMode,
    required this.onSelectOs,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white54 : const Color(0xFF64748B);
    final cardBgColor = isDarkMode ? const Color(0xFF141822) : Colors.white;

    final osList = AppPlatformIcons.osList;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Banner (ZERO OUTLINE)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFFE0F2FE), const Color(0xFFEDE9FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDarkMode ? 0.35 : 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(CupertinoIcons.macwindow, size: 30, color: Color(0xFF38BDF8)),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF38BDF8).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'VIRTUAL OS HUB',
                              style: TextStyle(
                                color: Color(0xFF0284C7),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '총 ${osList.length}개 가상 데스크톱 환경',
                            style: TextStyle(color: textSubColor, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '가상 데스크톱 OS 선택 및 접속',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Windows 11, macOS, SteamOS(Steam Deck), Windows XP 등 원하는 가상 OS로 즉시 부팅하여 창 모드로 앱을 실행하세요.',
                        style: TextStyle(color: textSubColor, fontSize: 13.5, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Section Title
          Text(
            '사용 가능한 운영체제 목록',
            style: TextStyle(
              color: textColor,
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),

          // OS Grid
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 360,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 1.35,
              ),
              itemCount: osList.length,
              itemBuilder: (context, index) {
                final os = osList[index];

                return ScaleButton(
                  onTap: () => onSelectOs(os.id),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cardBgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.04),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // OS Logo
                            Container(
                              width: 44,
                              height: 44,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Image.asset(os.assetPath, fit: BoxFit.contain),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    os.name,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 15.5,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Virtual Desktop Environment',
                                    style: TextStyle(
                                      color: textSubColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          _getOsDescription(os.id),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textSubColor, fontSize: 12, height: 1.35),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'OS 부팅 및 접속',
                                    style: TextStyle(
                                      color: Color(0xFF0284C7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(CupertinoIcons.play_arrow_solid, size: 10, color: Color(0xFF0284C7)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getOsDescription(String id) {
    switch (id) {
      case 'windows_11':
        return '최신 Windows 11 Fluent 디자인 가상 데스크톱. 시작 메뉴 및 멀티태스킹 창 완벽 지원.';
      case 'windows_10':
        return '클래식 Windows 10 작업 표시줄과 시작 타일 메뉴를 갖춘 안정적인 데스크톱.';
      case 'windows_7':
        return 'Aero Glass 테마와 시작 메뉴를 재현한 추억의 윈도우 7 가상 환경.';
      case 'windows_xp':
        return '블리스 초원 배경화면과 루나 테마의 레트로 Windows XP 가상 데스크톱.';
      case 'macos':
        return '애플 독(Dock)과 상단 메뉴바, Finder를 완벽 구현한 macOS 가상 스튜디오.';
      case 'steamos':
        return '밸브 공식 Steam Deck 및 SteamOS 데스크톱 모드. 게임 라이브러리 연동.';
      case 'windows_bsod':
        return '치명적인 시스템 오류 연출을 위한 실감나는 윈도우 블루스크린 화면.';
      case 'windows_update':
        return '무한 업데이트 화면 연출을 위한 윈도우 가짜 업데이트 가상 화면.';
      default:
        return '실제 운영체제와 동일한 인터랙션을 제공하는 가상 데스크톱 화면.';
    }
  }
}
