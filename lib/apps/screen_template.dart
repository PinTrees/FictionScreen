import 'package:flutter/cupertino.dart';

enum TemplateCategory {
  messenger('메신저 / 채팅'),
  sns('SNS / 소셜'),
  finance('금융 / 송금'),
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
  final bool isDesktop;
  final String? imageAsset;

  const ScreenTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.themeColor,
    this.badge = '',
    this.isDesktop = false,
    this.imageAsset,
  });

  static List<ScreenTemplate> get allTemplates => [
    const ScreenTemplate(
      id: 'kakaotalk',
      title: '카카오톡 채팅방',
      description: '1:1 대화 및 단톡방, 노란 말풍선, 1 안읽음 숫자, 상단바 커스텀',
      category: TemplateCategory.messenger,
      icon: CupertinoIcons.chat_bubble_2_fill,
      imageAsset: 'assets/images/kakaotalk_icon.webp',
      themeColor: Color(0xFFFEE500),
      badge: '인기',
    ),
    const ScreenTemplate(
      id: 'toss',
      title: '토스(Toss) 송금 완료 & 계좌',
      description: '토스 송금 완료 화면, 계좌 통장 잔액 및 거래 내역 커스텀',
      category: TemplateCategory.finance,
      icon: CupertinoIcons.money_dollar_circle_fill,
      themeColor: Color(0xFF0050FF),
      badge: '신규',
    ),
    const ScreenTemplate(
      id: 'kakaobank',
      title: '카카오뱅크 통장 & 이체',
      description: '카카오뱅크 옐로우 입출금 통장, 계좌 잔액, 세이프박스, 이체 내역 연출',
      category: TemplateCategory.finance,
      icon: CupertinoIcons.creditcard_fill,
      imageAsset: 'assets/images/kakaobank_icon.webp',
      themeColor: Color(0xFFFEE500),
      badge: '신규',
    ),
    const ScreenTemplate(
      id: 'x_twitter',
      title: 'X (구 트위터) 포스트',
      description: 'X (트위터) 게시글, 블루 틱, 리포스트, 좋아요, 북마크 커스텀',
      category: TemplateCategory.sns,
      icon: CupertinoIcons.conversation_bubble,
      themeColor: Color(0xFF1D9BF0),
      badge: '신규',
    ),
    const ScreenTemplate(
      id: 'pinterest',
      title: '핀터레스트 핀',
      description: '핀터레스트 핀 포스트, 크리에이터 프로필, 저장 수, 보드 커스텀',
      category: TemplateCategory.sns,
      icon: CupertinoIcons.sparkles,
      themeColor: Color(0xFFE60023),
      badge: '신규',
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
      id: 'windows_update',
      title: 'Windows 가짜 업데이트',
      description: '현실감 넘치는 Windows 10/11 업데이트 진행 전체화면 (% 퍼센트 애니메이션)',
      category: TemplateCategory.os,
      icon: CupertinoIcons.arrow_clockwise,
      themeColor: Color(0xFF0078D7),
      badge: '전체화면',
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
      imageAsset: 'assets/images/instagram_icon.webp',
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
    const ScreenTemplate(
      id: 'daangn',
      title: '당근마켓 중고거래',
      description: '당근마켓 중고거래 채팅, 매너온도, 거래완료, 네고 대화 연출',
      category: TemplateCategory.lifestyle,
      icon: CupertinoIcons.cart_fill,
      imageAsset: 'assets/images/daangn_icon.webp',
      themeColor: Color(0xFFFF6F0F),
      badge: '신규',
    ),
    const ScreenTemplate(
      id: 'coupang',
      title: '쿠팡 (Coupang)',
      description: '로켓배송, 로켓프레시, 골드박스, 데스크탑 와이드 몰 & 모바일 앱',
      category: TemplateCategory.lifestyle,
      icon: CupertinoIcons.cart_fill,
      imageAsset: 'assets/images/coupang_icon.webp',
      themeColor: Color(0xFFC72424),
      badge: '인기',
      isDesktop: true,
    ),
    const ScreenTemplate(
      id: 'netflix',
      title: '넷플릭스 (Netflix)',
      description: '프로필 선택, 오리지널 시리즈, TOP 10 거대 순위, 회차별 상세 모달',
      category: TemplateCategory.sns,
      icon: CupertinoIcons.tv_fill,
      imageAsset: 'assets/images/netflix_icon.webp',
      themeColor: Color(0xFFE50914),
      badge: 'HOT',
      isDesktop: true,
    ),
    const ScreenTemplate(
      id: 'lottery',
      title: '동행복권 (로또 6/45)',
      description: '로또 6/45 추첨 결과, 1등 당첨 영수증 생성, QR 당첨 확인, 스피또 2000',
      category: TemplateCategory.lifestyle,
      icon: CupertinoIcons.tickets_fill,
      imageAsset: 'assets/images/lottery_icon.webp',
      themeColor: Color(0xFF0066B3),
      badge: '인기',
      isDesktop: true,
    ),
    const ScreenTemplate(
      id: 'yanolja',
      title: '야놀자(NOL) 숙소 & 여행',
      description: '국내/해외 호텔·모텔·리조트·풀빌라 예약, 특가 타임세일, 모바일 앱 & 데스크탑 웹 지원',
      category: TemplateCategory.lifestyle,
      icon: CupertinoIcons.bed_double_fill,
      imageAsset: 'assets/images/yanolja_icon.webp',
      themeColor: Color(0xFFFF3478),
      badge: '신규',
      isDesktop: true,
    ),
    const ScreenTemplate(
      id: 'upbit',
      title: '업비트 (Upbit)',
      description: '비트코인/알트코인 실시간 시세, 호가창, 캔들 차트, 내 보유자산 & 수익률 연출',
      category: TemplateCategory.finance,
      icon: CupertinoIcons.chart_bar_alt_fill,
      imageAsset: 'assets/images/upbit_icon.webp',
      themeColor: Color(0xFF093687),
      badge: 'HOT',
      isDesktop: true,
    ),
  ];
}
