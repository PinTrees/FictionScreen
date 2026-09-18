import 'package:flutter/material.dart';

class PhotoshopTopMenu extends StatelessWidget {
  final String documentTitle;
  final int zoomPercent;
  final String colorMode;
  final VoidCallback onEditStory;

  const PhotoshopTopMenu({
    super.key,
    required this.documentTitle,
    required this.zoomPercent,
    required this.colorMode,
    required this.onEditStory,
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = ['파일(F)', '편집(E)', '이미지(I)', '레이어(L)', '문자(T)', '선택(S)', '필터(T)', '보기(V)', '창(W)', '도움말(H)'];

    return Column(
      children: [
        // 1. Menu Bar (28px)
        Container(
          height: 28,
          color: const Color(0xFF282828),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // Photoshop Ps Logo Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF001E36),
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: const Color(0xFF31A8FF), width: 1),
                ),
                child: const Text(
                  'Ps',
                  style: TextStyle(
                    color: Color(0xFF31A8FF),
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Menu Items
              ...menuItems.map((menu) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    menu,
                    style: const TextStyle(
                      color: Color(0xFFD6D6D6),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                );
              }),

              const Spacer(),

              // Story Scenario Edit button
              InkWell(
                onTap: onEditStory,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF31A8FF).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFF31A8FF), width: 0.8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit, size: 12, color: Color(0xFF31A8FF)),
                      SizedBox(width: 4),
                      Text(
                        '시나리오/레이어 편집',
                        style: TextStyle(
                          color: Color(0xFF31A8FF),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Window controls mockup
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

        // 2. Document Tab Bar (28px)
        Container(
          height: 28,
          color: const Color(0xFF1E1E1E),
          padding: const EdgeInsets.only(left: 6, top: 2),
          child: Row(
            children: [
              Container(
                height: 26,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2D2D2D),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                ),
                child: Row(
                  children: [
                    Text(
                      '$documentTitle @ $zoomPercent% ($colorMode) *',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.close, size: 12, color: Color(0xFF9E9E9E)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
