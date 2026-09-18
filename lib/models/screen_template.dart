import 'package:flutter/cupertino.dart';

enum TemplateCategory {
  messenger('메신저 / 채팅'),
  sns('SNS / 소셜'),
  os('OS & 시스템 오류'),
  lifestyle('라이프스타일 / 배달');

  final String label;
  const TemplateCategory(this.label);
}

class ScreenTemplate {
  final String id;
  final String title;
  final String description;
  final TemplateCategory category;
  final IconData icon;
  final Color themeColor;
  final String badge;
  final bool isDesktop; // 폰 프레임 vs 데스크톱 프레임

  const ScreenTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.themeColor,
    this.badge = '',
    this.isDesktop = false,
  });

  static List<ScreenTemplate> get allTemplates => [
    const ScreenTemplate(
      id: 'kakaotalk',
      title: '카카오톡 채팅방',
      description: '1:1 대화 및 단톡방, 노란 말풍선, 1 안읽음 숫자, 상단바 커스텀',
      category: TemplateCategory.messenger,
      icon: CupertinoIcons.chat_bubble_2_fill,
      themeColor: Color(0xFFFEE500),
      badge: '인기',
    ),
    const ScreenTemplate(
      id: 'windows_bsod',
      title: 'Windows 블루스크린',
      description: 'Windows 10/11 죽음의 블루스크린 (슬픈 표정, % 카운트 애니메이션, QR코드)',
      category: TemplateCategory.os,
      icon: CupertinoIcons.device_desktop,
      themeColor: Color(0xFF0078D7),
      badge: '실감형',
      isDesktop: true,
    ),
    const ScreenTemplate(
      id: 'youtube',
      title: '유튜브 영상 & 댓글',
      description: '유튜브 플레이어, 채널 정보, 조회수, 베스트 댓글 생성',
      category: TemplateCategory.sns,
      icon: CupertinoIcons.play_circle_fill,
      themeColor: Color(0xFFFF0000),
    ),
    const ScreenTemplate(
      id: 'instagram',
      title: '인스타그램 피드',
      description: '인스타 피드 게시물, 프로필, 좋아요 수, 캡션 및 댓글',
      category: TemplateCategory.sns,
      icon: CupertinoIcons.camera_fill,
      themeColor: Color(0xFFE1306C),
    ),
    const ScreenTemplate(
      id: 'delivery',
      title: '배달 플랫폼 (배민/쿠팡)',
      description: '배달 완료, 라이더 픽업, 예상 도착 시간 라이브 현황',
      category: TemplateCategory.lifestyle,
      icon: CupertinoIcons.bag_fill,
      themeColor: Color(0xFF2AC1BC),
    ),
  ];
}
