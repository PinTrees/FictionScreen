import 'package:flutter/material.dart';

/// iOS 18 홈스크린 앱 아이템 데이터 모델
class Ios18AppItem {
  final String id;
  final String title;
  final String? imageAsset;
  final Widget? customIcon;
  final int? badgeCount;

  const Ios18AppItem({
    required this.id,
    required this.title,
    this.imageAsset,
    this.customIcon,
    this.badgeCount,
  });

  Ios18AppItem copyWith({
    String? id,
    String? title,
    String? imageAsset,
    Widget? customIcon,
    int? badgeCount,
  }) {
    return Ios18AppItem(
      id: id ?? this.id,
      title: title ?? this.title,
      imageAsset: imageAsset ?? this.imageAsset,
      customIcon: customIcon ?? this.customIcon,
      badgeCount: badgeCount ?? this.badgeCount,
    );
  }
}
