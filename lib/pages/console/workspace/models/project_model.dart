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
}
