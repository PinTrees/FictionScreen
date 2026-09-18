import 'package:flutter/material.dart';

/// iOS 26 홈스크린 앱 아이템 데이터 모델
class Ios26AppItem {
  final String id;
  final String title;
  final String? imageAsset;
  final Widget? customIcon;
  final int? badgeCount;

  const Ios26AppItem({
    required this.id,
    required this.title,
    this.imageAsset,
    this.customIcon,
    this.badgeCount,
  });

  Ios26AppItem copyWith({
    String? id,
    String? title,
    String? imageAsset,
    Widget? customIcon,
    int? badgeCount,
  }) {
    return Ios26AppItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageAsset: imageAsset ?? this.imageAsset,
      customIcon: customIcon ?? this.customIcon,
      badgeCount: badgeCount ?? this.badgeCount,
    );
  }
}
