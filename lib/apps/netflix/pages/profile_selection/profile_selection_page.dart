import 'package:flutter/material.dart';
import '../../common/netflix_icons.dart';
import '../../data/netflix_model.dart';
import 'profile_card.dart';

/// 넷플릭스 "누가 시청 중인가요?" 프로필 선택 메인 페이지
class ProfileSelectionPage extends StatelessWidget {
  final NetflixConfig config;
  final ValueChanged<NetflixProfile> onSelectProfile;
  final VoidCallback onManageProfiles;

  const ProfileSelectionPage({
    super.key,
    required this.config,
    required this.onSelectProfile,
    required this.onManageProfiles,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF141414),
      width: double.infinity,
      height: double.infinity,
      child: SafeArea(
        child: Column(
          children: [
            // 상단 넷플릭스 로고
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: NetflixWordmark(fontSize: 28),
              ),
            ),
            const Spacer(),

            // 헤더 질문
            const Text(
              '넷플릭스를 시청할 프로필을 선택하세요.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 36),

            // 프로필 카드 수평 리스트
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...config.profiles.map(
                    (p) => ProfileCard(
                      profile: p,
                      onTap: () => onSelectProfile(p),
                    ),
                  ),
                  AddProfileCard(onTap: onManageProfiles),
                ],
              ),
            ),
            const Spacer(),

            // 하단 프로필 관리 버튼
            OutlinedButton(
              onPressed: onManageProfiles,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white60,
                side: const BorderSide(color: Colors.white38, width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: const Text(
                '프로필 관리',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
