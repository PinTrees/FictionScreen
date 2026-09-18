import 'package:flutter/material.dart';

class VisualStudioTopMenu extends StatelessWidget {
  final String solutionName;
  final VoidCallback onEditStory;

  const VisualStudioTopMenu({
    super.key,
    required this.solutionName,
    required this.onEditStory,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ['파일(F)', '편집(E)', '보기(V)', 'Git(G)', '프로젝트(P)', '빌드(B)', '디버그(D)', '테스트(S)', '분석(N)', '도구(T)', '확장(X)', '창(W)', '도움말(H)'];

    return Column(
      children: [
        // 1. Title Bar (32px)
        Container(
          height: 32,
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Visual Studio Purple Infinity Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFF68217A),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'VS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Title Text
              Expanded(
                child: Text(
                  '$solutionName - Microsoft Visual Studio 2026 (관리자 권한)',
                  style: const TextStyle(
                    color: Color(0xFFCCCCCC),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Quick Launch Search Box (Ctrl+Q)
              Container(
                height: 22,
                width: 200,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2D30),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF3F3F46)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, size: 12, color: Color(0xFF9E9E9E)),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '기능 및 코드 검색 (Ctrl+Q)',
                        style: TextStyle(color: Color(0xFF757575), fontSize: 10.5),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Scenario Edit Action
              InkWell(
                onTap: onEditStory,
                borderRadius: BorderRadius.circular(3),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF68217A).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: const Color(0xFF854C9E)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.code, size: 12, color: Color(0xFFC586C0)),
                      SizedBox(width: 4),
                      Text(
                        '시나리오/코드 편집',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Window controls
              const Row(
                children: [
                  Icon(Icons.remove, size: 13, color: Color(0xFF9E9E9E)),
                  SizedBox(width: 10),
                  Icon(Icons.crop_square, size: 12, color: Color(0xFF9E9E9E)),
                  SizedBox(width: 10),
                  Icon(Icons.close, size: 13, color: Color(0xFF9E9E9E)),
                ],
              ),
            ],
          ),
        ),

        // 2. Menu Bar (24px)
        Container(
          height: 24,
          color: const Color(0xFF2D2D30),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: menuItems.map((menu) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  menu,
                  style: const TextStyle(
                    color: Color(0xFFD6D6D6),
                    fontSize: 11.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
