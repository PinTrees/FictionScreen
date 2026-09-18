import 'dart:ui';
import 'package:flutter/material.dart';
import 'ios18_app_icon.dart';

/// Apple iOS 18 순정 리퀴드 글래스모피즘 (Liquid Glassmorphism) 독(Dock) 바
/// - 고굴절 다층 배경 블러 (sigma 38)
/// - 유체 표면장력 스펙큘러 하이라이트 (Top Specular Sheen)
/// - 하단 굴절 바운스 림 라이트
/// - 듀얼 앰비언트 심도 그림자 및 스쿼클 곡률 (r=36)
/// - 롱프레스 홈 화면 편집 모드 및 지글 흔들림 연동
class Ios18Dock extends StatelessWidget {
  final Function(String appId) onOpenApp;
  final bool isEditMode;
  final VoidCallback? onEnterEditMode;

  const Ios18Dock({
    super.key,
    required this.onOpenApp,
    this.isEditMode = false,
    this.onEnterEditMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        // 리퀴드 앰비언트 심도 & 외곽 광택 림 섀도우
        boxShadow: [
          // 바닥 드롭 섀도우 (깊은 부유감)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.32),
            blurRadius: 30,
            spreadRadius: 1,
            offset: const Offset(0, 12),
          ),
          // 은은한 접촉 섀도우
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          // 외곽 빛 반사 림
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.18),
            blurRadius: 1,
            spreadRadius: 0.5,
          ),
        ],
        // 고굴절 액체 테두리
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.38),
          width: 1.1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 38, sigmaY: 38),
          child: Container(
            decoration: BoxDecoration(
              // 리퀴드 글래스 특유의 상단 광택 및 하단 굴절 그라데이션
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.38), // 최상단 액체 림 하이라이트
                  Colors.white.withValues(alpha: 0.16), // 상단 반투명 유리 바디
                  Colors.white.withValues(alpha: 0.08), // 중앙 높은 투과성
                  Colors.white.withValues(alpha: 0.22), // 하단 굴절 바운스 라이트
                ],
                stops: const [0.0, 0.22, 0.65, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // 1. 최상단 스펙큘러 유체 반사선 (Liquid Specular Sheen)
                Positioned(
                  top: 0,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 1.2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.0),
                          Colors.white.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),

                // 2. 도크 내부 4개 순정 앱 아이콘
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Ios18AppIcon(
                          title: '',
                          imageAsset: 'assets/images/ios/icons/phone.png',
                          isEditMode: isEditMode,
                          index: 100,
                          onTap: () => onOpenApp('phone'),
                          onLongPress: onEnterEditMode,
                        ),
                        Ios18AppIcon(
                          title: '',
                          imageAsset: 'assets/images/ios/icons/safari.png',
                          isEditMode: isEditMode,
                          index: 101,
                          onTap: () => onOpenApp('safari'),
                          onLongPress: onEnterEditMode,
                        ),
                        Ios18AppIcon(
                          title: '',
                          imageAsset: 'assets/images/ios/icons/messages.png',
                          badgeCount: 3,
                          isEditMode: isEditMode,
                          index: 102,
                          onTap: () => onOpenApp('messages'),
                          onLongPress: onEnterEditMode,
                        ),
                        Ios18AppIcon(
                          title: '',
                          imageAsset: 'assets/images/ios/icons/music.png',
                          isEditMode: isEditMode,
                          index: 103,
                          onTap: () => onOpenApp('music'),
                          onLongPress: onEnterEditMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
