import '../../../../apps/screen_template.dart';

class ProjectModel {
  final String id;
  String title;
  String appTemplateId;
  String description;
  DateTime updatedAt;
  bool isStarred;

  ProjectModel({
    required this.id,
    required this.title,
    required this.appTemplateId,
    this.description = '',
    required this.updatedAt,
    this.isStarred = false,
  });

  ScreenTemplate? get template {
    try {
      return ScreenTemplate.allTemplates.firstWhere((t) => t.id == appTemplateId);
    } catch (_) {
      return null;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(updatedAt);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}일 전';
    } else {
      return '${updatedAt.month}월 ${updatedAt.day}일';
    }
  }

  static List<ProjectModel> get initialSampleProjects => [
        ProjectModel(
          id: 'proj_kakaotalk_romance',
          title: '웹소설 14화 단톡방 시나리오',
          appTemplateId: 'kakaotalk',
          description: '남주와 여주의 1:1 카카오톡 대화 및 카카오페이 송금 장면',
          updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
          isStarred: true,
        ),
        ProjectModel(
          id: 'proj_messages_thriller',
          title: '스릴러 형사 긴급 문자 내역',
          appTemplateId: 'messages',
          description: '사건 현장 용의자 긴급 SMS 문자 추적 씬',
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          isStarred: false,
        ),
        ProjectModel(
          id: 'proj_telegram_crypto',
          title: '주식/코인 리딩방 폭락 캡처',
          appTemplateId: 'telegram',
          description: 'VIP 시그널 방 패닉셀 메시지 연출',
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          isStarred: true,
        ),
        ProjectModel(
          id: 'proj_instagram_feed',
          title: '인플루언서 피드 & 협찬 DM',
          appTemplateId: 'instagram',
          description: '협찬 문의 DM 및 스토리 반응 씬',
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
          isStarred: false,
        ),
      ];
}
