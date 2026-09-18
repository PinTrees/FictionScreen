import 'package:flutter/material.dart';
import '../models/ios18_app_item.dart';
import 'ios18_app_icon.dart';

/// iOS 18 드래그 앤 드롭 앱 아이콘 위치 변경 그리드
/// - 꾹 누르면(롱프레스) 홈 화면 편집 모드 진입 및 드래그 시작
/// - 아이콘 이동 시 실시간 위치 교체 (Live Hover Swap)
/// - 흔들림(Jiggle) 애니메이션 및 삭제 '-' 배지 지원
class Ios18ReorderableGrid extends StatelessWidget {
  final List<Ios18AppItem> items;
  final bool isEditMode;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(String appId) onOpenApp;
  final VoidCallback onEnterEditMode;
  final Function(Ios18AppItem item)? onDeleteItem;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final ScrollPhysics physics;

  const Ios18ReorderableGrid({
    super.key,
    required this.items,
    required this.isEditMode,
    required this.onReorder,
    required this.onOpenApp,
    required this.onEnterEditMode,
    this.onDeleteItem,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 14,
    this.crossAxisSpacing = 14,
    this.childAspectRatio = 0.74,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: physics,
      itemCount: items.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) {
        final item = items[index];

        return DragTarget<Ios18AppItem>(
          onWillAcceptWithDetails: (details) {
            if (details.data.id != item.id) {
              final oldIdx = items.indexWhere((it) => it.id == details.data.id);
              final newIdx = index;
              if (oldIdx != -1 && newIdx != -1 && oldIdx != newIdx) {
                onReorder(oldIdx, newIdx);
              }
            }
            return true;
          },
          builder: (context, candidateData, rejectedData) {
            // 평상 시 / 편집 모드 기본 아이콘
            final normalIcon = Ios18AppIcon(
              key: ValueKey(item.id),
              title: item.title,
              imageAsset: item.imageAsset,
              customIcon: item.customIcon,
              badgeCount: item.badgeCount,
              isEditMode: isEditMode,
              index: index,
              onTap: () => onOpenApp(item.id),
              onLongPress: onEnterEditMode,
              onDelete: onDeleteItem != null ? () => onDeleteItem!(item) : null,
            );

            // 드래그 중인 손가락 아래 떠다니는 피드백 아이콘 (확대 + 그림자)
            final feedbackIcon = Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.15,
                child: Opacity(
                  opacity: 0.95,
                  child: Ios18AppIcon(
                    title: item.title,
                    imageAsset: item.imageAsset,
                    customIcon: item.customIcon,
                    badgeCount: item.badgeCount,
                    isEditMode: false,
                    onTap: () {},
                  ),
                ),
              ),
            );

            // 드래그 시 원래 자리 반투명 고스트 자리
            final placeholder = Opacity(
              opacity: 0.22,
              child: normalIcon,
            );

            if (isEditMode) {
              // 편집 모드에서는 짧은 탭-드래그로 즉시 이동
              return Draggable<Ios18AppItem>(
                data: item,
                feedback: feedbackIcon,
                childWhenDragging: placeholder,
                child: normalIcon,
              );
            } else {
              // 일반 모드에서는 길게 누르면(롱프레스) 편집 모드 진입 및 드래그 시작
              return LongPressDraggable<Ios18AppItem>(
                data: item,
                delay: const Duration(milliseconds: 320),
                onDragStarted: onEnterEditMode,
                feedback: feedbackIcon,
                childWhenDragging: placeholder,
                child: normalIcon,
              );
            }
          },
        );
      },
    );
  }
}
