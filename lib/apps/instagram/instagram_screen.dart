import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/instagram_model.dart';
import 'pages/instagram_dm_page.dart';
import 'pages/instagram_explore_page.dart';
import 'pages/instagram_home_page.dart';
import 'pages/instagram_profile_page.dart';
import 'pages/instagram_reels_page.dart';
import 'widgets/instagram_bottom_nav.dart';
import 'widgets/instagram_modal_scope.dart';
import 'widgets/instagram_story_viewer.dart';

class InstagramScreen extends StatefulWidget {
  final InstagramConfig config;

  const InstagramScreen({super.key, required this.config});

  @override
  State<InstagramScreen> createState() => _InstagramScreenState();
}

class _InstagramScreenState extends State<InstagramScreen> with SingleTickerProviderStateMixin {
  int _currentTab = 0;
  InstagramStoryItem? _activeStory;
  bool _isInDm = false;

  // 인앱(앱 창 내부) 전용 바텀시트/모달 상태 및 애니메이션
  Widget? _currentModal;
  late AnimationController _modalAnimController;
  late Animation<Offset> _modalSlideAnimation;
  late Animation<double> _modalFadeAnimation;

  @override
  void initState() {
    super.initState();
    widget.config.syncPrimaryPost();

    _modalAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _modalSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _modalAnimController, curve: Curves.easeOutCubic));

    _modalFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _modalAnimController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _modalAnimController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InstagramScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.config.syncPrimaryPost();
  }

  void _showModal(Widget modal) {
    setState(() {
      _currentModal = modal;
    });
    _modalAnimController.forward(from: 0.0);
  }

  void _hideModal() {
    _modalAnimController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _currentModal = null;
        });
      }
    });
  }

  void _openStory(InstagramStoryItem story) {
    setState(() {
      _activeStory = story;
    });
  }

  void _closeStory() {
    setState(() {
      _activeStory = null;
    });
  }

  void _openDm() {
    setState(() {
      _isInDm = true;
    });
  }

  void _closeDm() {
    setState(() {
      _isInDm = false;
    });
  }

  /// 만들기 모달 바텀시트 (앱 창 내부에서만 오픈)
  void _showCreateModal() {
    final createSheet = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 6),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 24),
                  const Text(
                    '만들기',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: _hideModal,
                    child: const Icon(CupertinoIcons.xmark, size: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 0.5),
            _buildCreateOption(
              icon: CupertinoIcons.play_rectangle,
              title: '릴스',
              onTap: () {
                _hideModal();
                setState(() => _currentTab = 3);
              },
            ),
            _buildCreateOption(
              icon: CupertinoIcons.square_grid_2x2,
              title: '게시물',
              onTap: () {
                _hideModal();
                _openNewPostDialog();
              },
            ),
            _buildCreateOption(
              icon: CupertinoIcons.plus_circle,
              title: '스토리',
              onTap: () {
                _hideModal();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('스토리 생성 카메라를 엽니다 📸'), duration: Duration(seconds: 1)),
                );
              },
            ),
            _buildCreateOption(
              icon: CupertinoIcons.heart_circle,
              title: '스토리 하이라이트',
              onTap: () {
                _hideModal();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('스토리 하이라이트 추가 화면입니다.'), duration: Duration(seconds: 1)),
                );
              },
            ),
            _buildCreateOption(
              icon: CupertinoIcons.antenna_radiowaves_left_right,
              title: '라이브 방송',
              onTap: () {
                _hideModal();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('인스타그램 라이브 방송을 시작합니다 🔴'), duration: Duration(seconds: 1)),
                );
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );

    _showModal(createSheet);
  }

  /// 새 게시물 작성 모달 (앱 창 내부에서만 오픈)
  void _openNewPostDialog() {
    final captionCtrl = TextEditingController();
    final locCtrl = TextEditingController(text: 'Seoul, South Korea');

    final newPostSheet = Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _hideModal,
                child: const Text('취소', style: TextStyle(color: Colors.black54, fontSize: 15)),
              ),
              const Text('새 게시물 작성', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              GestureDetector(
                onTap: () {
                  final text = captionCtrl.text.trim();
                  if (text.isNotEmpty) {
                    setState(() {
                      widget.config.posts.insert(
                        0,
                        InstagramFeedPost(
                          id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                          username: widget.config.username,
                          location: locCtrl.text.trim(),
                          userAvatarLetter: widget.config.username.isNotEmpty ? widget.config.username[0].toUpperCase() : 'S',
                          userAvatarBg: const Color(0xFFF97316),
                          imageAsset: 'assets/images/macos_golden_gate.webp',
                          likesText: '1',
                          likesCount: 1,
                          caption: text,
                          timeAgo: '방금 전',
                          commentCount: 0,
                          isLiked: true,
                          comments: [],
                        ),
                      );
                      _currentTab = 0;
                    });
                    _hideModal();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('피드에 새 게시물이 등록되었습니다 🎉'), duration: Duration(seconds: 1)),
                    );
                  }
                },
                child: const Text('공유', style: TextStyle(color: Color(0xFF0095F6), fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: captionCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: '문구를 작성하거나 설문 및 태그를 추가하세요...',
              border: InputBorder.none,
            ),
          ),
          const Divider(),
          TextField(
            controller: locCtrl,
            decoration: const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.location_solid, size: 18, color: Colors.black54),
              hintText: '위치 추가',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );

    _showModal(newPostSheet);
  }

  Widget _buildCreateOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87, size: 24),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.config.syncPrimaryPost();

    // 1. Story Viewer full-screen overlay
    if (_activeStory != null) {
      return InstagramStoryViewer(
        story: _activeStory!,
        onClose: _closeStory,
      );
    }

    // 2. DM Page overlay
    if (_isInDm) {
      return InstagramDmPage(
        config: widget.config,
        onBack: _closeDm,
      );
    }

    // 3. Tab Body
    Widget bodyContent;
    switch (_currentTab) {
      case 0:
        bodyContent = InstagramHomePage(
          config: widget.config,
          onOpenStory: _openStory,
          onOpenDm: _openDm,
          onOpenProfile: () => setState(() => _currentTab = 4),
        );
        break;
      case 1:
        bodyContent = const InstagramExplorePage();
        break;
      case 3:
        bodyContent = const InstagramReelsPage();
        break;
      case 4:
        bodyContent = InstagramProfilePage(config: widget.config);
        break;
      default:
        bodyContent = InstagramHomePage(
          config: widget.config,
          onOpenStory: _openStory,
          onOpenDm: _openDm,
          onOpenProfile: () => setState(() => _currentTab = 4),
        );
    }

    final avatarLetter = widget.config.username.isNotEmpty ? widget.config.username[0].toUpperCase() : 'S';

    return InstagramModalScope(
      showModal: _showModal,
      hideModal: _hideModal,
      child: ClipRect(
        child: Stack(
          children: [
            Scaffold(
              body: bodyContent,
              bottomNavigationBar: InstagramBottomNav(
                currentIndex: _currentTab,
                userAvatarLetter: avatarLetter,
                onTabSelected: (index) {
                  if (index == 2) {
                    _showCreateModal();
                  } else {
                    setState(() {
                      _currentTab = index;
                    });
                  }
                },
              ),
            ),

            // 인앱 모달 베리어 (배경 어둡게 처리 & 터치 시 닫힘)
            if (_currentModal != null) ...[
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _modalFadeAnimation,
                  builder: (context, _) => GestureDetector(
                    onTap: _hideModal,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.45 * _modalFadeAnimation.value),
                    ),
                  ),
                ),
              ),

              // 슬라이딩 인앱 바텀시트
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: SlideTransition(
                  position: _modalSlideAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: _currentModal!,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
