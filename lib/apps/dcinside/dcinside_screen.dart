import 'package:flutter/material.dart';
import 'data/dcinside_model.dart';
import 'widgets/dcinside_edit_dialog.dart';
import 'widgets/dcinside_header.dart';
import 'widgets/dcinside_post_detail.dart';
import 'widgets/dcinside_post_list.dart';

class DcinsideScreen extends StatefulWidget {
  final DcinsideConfig config;
  final ValueChanged<DcinsideConfig>? onConfigChanged;

  const DcinsideScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<DcinsideScreen> createState() => _DcinsideScreenState();
}

class _DcinsideScreenState extends State<DcinsideScreen> {
  bool _isShowingDetail = true; // 기본적으로 상세글 화면을 보여주어 웹툰 컷 캡처에 즉시 사용 가능하도록 설정

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => DcinsideEditDialog(
        config: widget.config,
        onApply: (updated) {
          widget.onConfigChanged?.call(updated);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPost = widget.config.posts.firstWhere(
      (p) => p.id == widget.config.selectedPostId,
      orElse: () => widget.config.posts.first,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          // 1. 헤더 (네이비 글로벌 바 + 갤러리 타이틀 + 탭 바)
          DcinsideHeader(
            config: widget.config,
            isShowingDetail: _isShowingDetail,
            onBackToList: () => setState(() => _isShowingDetail = false),
            onTabChanged: (tab) {
              setState(() => _isShowingDetail = false);
              widget.onConfigChanged?.call(widget.config.copyWith(activeTab: tab));
            },
            onOpenSettings: _openEditDialog,
          ),

          // 2. 메인 컨텐츠 (상세글 또는 글 목록)
          Expanded(
            child: _isShowingDetail
                ? DcinsidePostDetail(
                    post: currentPost,
                    onBackToList: () => setState(() => _isShowingDetail = false),
                    onPostUpdated: (updatedPost) {
                      final posts = List<DcPost>.from(widget.config.posts);
                      final idx = posts.indexWhere((p) => p.id == updatedPost.id);
                      if (idx != -1) {
                        posts[idx] = updatedPost;
                      } else {
                        posts[0] = updatedPost;
                      }
                      widget.onConfigChanged?.call(widget.config.copyWith(posts: posts));
                    },
                  )
                : DcinsidePostList(
                    config: widget.config,
                    onSelectPost: (postId) {
                      setState(() => _isShowingDetail = true);
                      widget.onConfigChanged?.call(widget.config.copyWith(selectedPostId: postId));
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
