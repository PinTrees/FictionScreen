import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/dcinside_model.dart';

class DcinsideHeader extends StatelessWidget {
  final DcinsideConfig config;
  final ValueChanged<String> onTabChanged;
  final VoidCallback onOpenSettings;
  final VoidCallback? onBackToList;
  final bool isShowingDetail;

  const DcinsideHeader({
    super.key,
    required this.config,
    required this.onTabChanged,
    required this.onOpenSettings,
    this.onBackToList,
    this.isShowingDetail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. 상단 글로벌 네이비 바
        Container(
          height: 48,
          color: const Color(0xFF3B4890),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // 뒤로가기 (상세 화면일 때)
              if (isShowingDetail)
                IconButton(
                  icon: const Icon(CupertinoIcons.back, color: Colors.white, size: 20),
                  tooltip: '목록으로 돌아가기',
                  onPressed: onBackToList,
                ),

              // DC Inside 텍스트 로고
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'dc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.0,
                      ),
                    ),
                    TextSpan(
                      text: 'inside',
                      style: TextStyle(
                        color: Color(0xFFFFD54F),
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 14),

              // 검색창 가짜 인풋
              Expanded(
                child: Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '${config.galleryName} 내 검색',
                        style: const TextStyle(color: Colors.black38, fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(CupertinoIcons.search, color: Color(0xFF3B4890), size: 16),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // 설정 버튼
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF283570),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  elevation: 0,
                ),
                onPressed: onOpenSettings,
                icon: const Icon(CupertinoIcons.gear_alt_fill, size: 13),
                label: const Text('시나리오 설정', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),

        // 2. 갤러리 타이틀 & 정보 바
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 갤러리 이름
              Text(
                config.galleryName,
                style: const TextStyle(
                  color: Color(0xFF222222),
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 8),

              // 갤러리 구분 뱃지 (마이너 갤러리 등)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Text(
                  config.galleryCategory,
                  style: const TextStyle(
                    color: Color(0xFF3B4890),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Spacer(),

              // 글쓰기 버튼
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B4890),
                  borderRadius: BorderRadius.circular(3),
                ),
                alignment: Alignment.center,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.pencil, color: Colors.white, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '글쓰기',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 3. 갤러리 탭 바 (전체글 / 개념글 / 공지)
        Container(
          height: 38,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F8FA),
            border: Border(
              top: BorderSide(color: Color(0xFFE2E4E8)),
              bottom: BorderSide(color: Color(0xFF3B4890), width: 1.5),
            ),
          ),
          child: Row(
            children: [
              _buildTabItem('전체글', config.activeTab == '전체글'),
              _buildTabItem('개념글', config.activeTab == '개념글', isConcept: true),
              _buildTabItem('공지', config.activeTab == '공지'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabItem(String label, bool isSelected, {bool isConcept = false}) {
    return GestureDetector(
      onTap: () => onTabChanged(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF3B4890) : Colors.transparent,
          border: isSelected
              ? null
              : const Border(right: BorderSide(color: Color(0xFFE2E4E8))),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isConcept)
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: Icon(
                  CupertinoIcons.star_fill,
                  color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFFE65100),
                  size: 12,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF444444),
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
