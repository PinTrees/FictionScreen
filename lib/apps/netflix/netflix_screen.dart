import 'package:flutter/material.dart';
import 'data/netflix_model.dart';
import 'pages/desktop_home/desktop_home_page.dart';
import 'pages/media_detail/media_detail_dialog.dart';
import 'pages/mobile_home/mobile_home_page.dart';
import 'pages/profile_selection/profile_selection_page.dart';

/// 넷플릭스 스크린 메인 오케스트레이터 (데스크탑 와이드 / 모바일 앱 반응형 및 모달 제어)
class NetflixScreen extends StatefulWidget {
  final NetflixConfig config;
  final ValueChanged<NetflixConfig>? onConfigChanged;

  const NetflixScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<NetflixScreen> createState() => _NetflixScreenState();
}

class _NetflixScreenState extends State<NetflixScreen> {
  late NetflixConfig _currentConfig;
  bool _isProfileSelecting = false;
  NetflixMediaItem? _selectedMedia;

  @override
  void initState() {
    super.initState();
    _currentConfig = widget.config;
    _isProfileSelecting = widget.config.showProfileSelector;
  }

  @override
  void didUpdateWidget(covariant NetflixScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != oldWidget.config) {
      _currentConfig = widget.config;
    }
  }

  void _handleSelectProfile(NetflixProfile profile) {
    setState(() {
      _currentConfig = _currentConfig.copyWith(activeProfileId: profile.id);
      _isProfileSelecting = false;
    });
    widget.onConfigChanged?.call(_currentConfig);
  }

  void _handleOpenProfileSelector() {
    setState(() {
      _isProfileSelecting = true;
      _selectedMedia = null;
    });
  }

  void _handleSelectMedia(NetflixMediaItem media) {
    setState(() {
      _selectedMedia = media;
    });
  }

  void _handleCloseDetail() {
    setState(() {
      _selectedMedia = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF141414),
      body: Stack(
        children: [
          // 1. 프로필 선택 화면 또는 메인 홈 화면 (반응형 분기)
          if (_isProfileSelecting)
            ProfileSelectionPage(
              config: _currentConfig,
              onSelectProfile: _handleSelectProfile,
              onManageProfiles: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('프로필 편집은 상단 넷플릭스 설정창에서 변경할 수 있습니다.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isWidescreen = constraints.maxWidth > 680;
                if (isWidescreen) {
                  return DesktopHomePage(
                    config: _currentConfig,
                    onSelectMedia: _handleSelectMedia,
                    onOpenProfileSelector: _handleOpenProfileSelector,
                  );
                } else {
                  return MobileHomePage(
                    config: _currentConfig,
                    onSelectMedia: _handleSelectMedia,
                    onOpenProfileSelector: _handleOpenProfileSelector,
                  );
                }
              },
            ),

          // 2. 창 내부 전용 상세 정보 모달
          if (_selectedMedia != null)
            MediaDetailDialog(
              media: _selectedMedia!,
              onClose: _handleCloseDetail,
              onPlay: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('[${_selectedMedia!.title}] 재생을 시작합니다.'),
                    duration: const Duration(seconds: 2),
                    backgroundColor: const Color(0xFFE50914),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
