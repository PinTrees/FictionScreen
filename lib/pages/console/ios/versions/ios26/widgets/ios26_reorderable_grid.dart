import 'package:flutter/material.dart';
import '../models/ios26_app_item.dart';
import 'ios26_app_icon.dart';

/// iOS 26 드래그 앤 드롭 앱 아이콘 위치 변경 그리드
class Ios26ReorderableGrid extends StatelessWidget {
  final List<Ios26AppItem> items;
  final bool isEditMode;
  final Function(int oldIndex, int newIndex) onReorder;
  final Function(String appId) onOpenApp;
  final VoidCallback onEnterEditMode;
  final Function(Ios26AppItem item)? onDeleteItem;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final double childAspectRatio;
  final double iconSize;
  final ScrollPhysics physics;

  const Ios26ReorderableGrid({
    super.key,
    required this.items,
    required this.isEditMode,
    required this.onReorder,
    required this.onOpenApp,
    required this.onEnterEditMode,
    this.onDeleteItem,
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 14,
    this.childAspectRatio = 0.80,
    this.iconSize = 64.0,
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

        return DragTarget<Ios26AppItem>(
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
            final normalIcon = Ios26AppIcon(
              key: ValueKey(item.id),
              title: item.title,
              size: iconSize,
              imageAsset: item.imageAsset,
              customIcon: item.customIcon,
              badgeCount: item.badgeCount,
              isEditMode: isEditMode,
              index: index,
              onTap: () => onOpenApp(item.id),
              onLongPress: onEnterEditMode,
              onDelete: onDeleteItem != null ? () => onDeleteItem!(item) : null,
            );

            final feedbackIcon = Material(
              color: Colors.transparent,
              child: Transform.scale(
                scale: 1.15,
                child: Opacity(
                  opacity: 0.95,
                  child: Ios26AppIcon(
                    title: item.title,
                    size: iconSize,
                    imageAsset: item.imageAsset,
                    customIcon: item.customIcon,
                    badgeCount: item.badgeCount,
                    isEditMode: false,
                    onTap: () {},
                  ),
                ),
              ),
            );

            final placeholder = Opacity(
              opacity: 0.22,
              child: normalIcon,
            );

            if (isEditMode) {
              return Draggable<Ios26AppItem>(
                data: item,
                feedback: feedbackIcon,
                childWhenDragging: placeholder,
                child: normalIcon,
              );
            } else {
              return LongPressDraggable<Ios26AppItem>(
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
