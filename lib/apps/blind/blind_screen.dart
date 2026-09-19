import 'package:flutter/material.dart';
import 'data/blind_model.dart';
import 'pages/desktop/blind_desktop_home_page.dart';
import 'pages/mobile/blind_mobile_detail_page.dart';
import 'pages/mobile/blind_mobile_home_page.dart';
import 'widgets/blind_edit_dialog.dart';

class BlindScreen extends StatefulWidget {
  final BlindConfig config;
  final ValueChanged<BlindConfig>? onConfigChanged;

  const BlindScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<BlindScreen> createState() => _BlindScreenState();
}

class _BlindScreenState extends State<BlindScreen> {
  bool _isMobileDetail = true;
  late BlindPostItem _selectedPost;

  @override
  void initState() {
    super.initState();
    _selectedPost = widget.config.currentPost;
  }

  @override
  void didUpdateWidget(covariant BlindScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _selectedPost = widget.config.currentPost;
    }
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => BlindEditDialog(
        post: _selectedPost,
        onSave: (updated) {
          setState(() => _selectedPost = updated);
          final updatedFeed = widget.config.feedPosts.map((p) => p.id == updated.id ? updated : p).toList();
          widget.onConfigChanged?.call(
            widget.config.copyWith(
              currentPost: updated,
              feedPosts: updatedFeed,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light().copyWith(
        inputDecorationTheme: const InputDecorationTheme(
          filled: false,
          fillColor: Colors.transparent,
        ),
      ),
      child: LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 750;

        if (isDesktop) {
          return BlindDesktopHomePage(
            config: widget.config,
            onConfigChanged: widget.onConfigChanged,
            onEditStory: _openEditDialog,
          );
        }

        if (_isMobileDetail) {
          return BlindMobileDetailPage(
            post: _selectedPost,
            onBack: () => setState(() => _isMobileDetail = false),
            onPostUpdated: (updated) {
              setState(() => _selectedPost = updated);
              final updatedFeed = widget.config.feedPosts.map((p) => p.id == updated.id ? updated : p).toList();
              widget.onConfigChanged?.call(
                widget.config.copyWith(
                  currentPost: updated,
                  feedPosts: updatedFeed,
                ),
              );
            },
            onEditStory: _openEditDialog,
          );
        }

        return BlindMobileHomePage(
          config: widget.config,
          onConfigChanged: widget.onConfigChanged,
          onSelectPost: (post) {
            setState(() {
              _selectedPost = post;
              _isMobileDetail = true;
            });
          },
          onEditStory: _openEditDialog,
        );
      },
    ),
  );
}
}
