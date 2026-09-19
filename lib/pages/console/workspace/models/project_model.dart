import '../../../../apps/screen_template.dart';

class ProjectModel {
  final String id;
  String title;
  String appTemplateId;
  String description;
  DateTime updatedAt;
  bool isStarred;
  Map<String, dynamic>? contentData;

  ProjectModel({
    required this.id,
    required this.title,
    required this.appTemplateId,
    this.description = '',
    required this.updatedAt,
    this.isStarred = false,
    this.contentData,
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? appTemplateId,
    String? description,
    DateTime? updatedAt,
    bool? isStarred,
    Map<String, dynamic>? contentData,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      appTemplateId: appTemplateId ?? this.appTemplateId,
      description: description ?? this.description,
      updatedAt: updatedAt ?? this.updatedAt,
      isStarred: isStarred ?? this.isStarred,
      contentData: contentData ?? this.contentData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'appTemplateId': appTemplateId,
      'description': description,
      'updatedAt': updatedAt.toIso8601String(),
      'isStarred': isStarred,
      'contentData': contentData,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map, String docId) {
    DateTime updated = DateTime.now();
    if (map['updatedAt'] is String) {
      updated = DateTime.tryParse(map['updatedAt']) ?? DateTime.now();
    }
    return ProjectModel(
      id: docId,
      title: map['title']?.toString() ?? '새 작업',
      appTemplateId: map['appTemplateId']?.toString() ?? 'kakaotalk',
      description: map['description']?.toString() ?? '',
      updatedAt: updated,
      isStarred: map['isStarred'] == true,
      contentData: map['contentData'] is Map ? Map<String, dynamic>.from(map['contentData'] as Map) : null,
    );
  }

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
