import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/instagram_model.dart';
import 'pages/instagram_dm_page.dart';
import 'pages/instagram_explore_page.dart';
import 'pages/instagram_home_page.dart';
import 'pages/instagram_profile_page.dart';
import 'pages/instagram_reels_page.dart';
import 'widgets/instagram_bottom_nav.dart';
import 'widgets/instagram_story_viewer.dart';

class InstagramScreen extends StatefulWidget {
  final InstagramConfig config;

  const InstagramScreen({super.key, required this.config});

  @override
  State<InstagramScreen> createState() => _InstagramScreenState();
}

class _InstagramScreenState extends State<InstagramScreen> {
  int _currentTab = 0;
  InstagramStoryItem? _activeStory;
  bool _isInDm = false;

  @override
  void initState() {
    super.initState();
    widget.config.syncPrimaryPost();
  }

  @override
  void didUpdateWidget(covariant InstagramScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.config.syncPrimaryPost();
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

  void _showCreateModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  '만들기',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(height: 1, thickness: 0.5),
              _buildCreateOption(
                icon: CupertinoIcons.play_rectangle,
                title: '릴스',
                onTap: () {
                  Navigator.pop(context);
                  setState(() => _currentTab = 3);
                },
              ),
              _buildCreateOption(
                icon: CupertinoIcons.square_grid_2x2,
                title: '게시물',
                onTap: () {
                  Navigator.pop(context);
                  _openNewPostDialog();
                },
              ),
              _buildCreateOption(
                icon: CupertinoIcons.plus_circle,
                title: '스토리',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('스토리 생성 카메라를 엽니다 📸'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              _buildCreateOption(
                icon: CupertinoIcons.heart_circle,
                title: '스토리 하이라이트',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('스토리 하이라이트 추가 화면입니다.'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              _buildCreateOption(
                icon: CupertinoIcons.antenna_radiowaves_left_right,
                title: '라이브 방송',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('인스타그램 라이브 방송을 시작합니다 🔴'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _openNewPostDialog() {
    final captionCtrl = TextEditingController();
    final locCtrl = TextEditingController(text: 'Seoul, South Korea');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('취소', style: TextStyle(color: Colors.black54, fontSize: 15)),
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
                        Navigator.pop(context);
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
            ],
          ),
        );
      },
    );
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

    return Scaffold(
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
    );
  }
}
