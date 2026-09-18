import 'package:flutter/cupertino.dart';

class BlindCompanyBadge extends StatelessWidget {
  final String company;
  final String maskedId;
  final String? timeAgo;
  final int? viewCount;
  final bool isAuthor;
  final double fontSize;

  const BlindCompanyBadge({
    super.key,
    required this.company,
    required this.maskedId,
    this.timeAgo,
    this.viewCount,
    this.isAuthor = false,
    this.fontSize = 12.5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F3F5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(CupertinoIcons.building_2_fill, size: 10.5, color: Color(0xFF71747A)),
              const SizedBox(width: 3.5),
              Text(
                company,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF22252A),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '· $maskedId',
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xFF8A8F98),
            fontWeight: FontWeight.w400,
          ),
        ),
        if (isAuthor) ...[
          const SizedBox(width: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.5, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFDA3238).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              '작성자',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDA3238),
              ),
            ),
          ),
        ],
        if (timeAgo != null) ...[
          const SizedBox(width: 6),
          Text(
            '· $timeAgo',
            style: TextStyle(
              fontSize: fontSize - 0.5,
              color: const Color(0xFF9EA3AA),
            ),
          ),
        ],
        if (viewCount != null) ...[
          const SizedBox(width: 6),
          Text(
            '· 조회 $viewCount',
            style: TextStyle(
              fontSize: fontSize - 0.5,
              color: const Color(0xFF9EA3AA),
            ),
          ),
        ],
      ],
    );
  }
}
