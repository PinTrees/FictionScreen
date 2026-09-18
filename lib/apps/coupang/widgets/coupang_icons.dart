import 'package:flutter/cupertino.dart';
import '../data/coupang_model.dart';

class CoupangIcons {
  CoupangIcons._();

  /// 쿠팡 시그니처 7색 워드마크 로고 (coupang)
  static Widget logo({double height = 24}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('c', style: TextStyle(color: const Color(0xFF902324), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('o', style: TextStyle(color: const Color(0xFFC74323), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('u', style: TextStyle(color: const Color(0xFFE2911C), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('p', style: TextStyle(color: const Color(0xFF90AB28), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('a', style: TextStyle(color: const Color(0xFF16834F), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('n', style: TextStyle(color: const Color(0xFF0075BC), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
        Text('g', style: TextStyle(color: const Color(0xFF8B255D), fontSize: height, fontWeight: FontWeight.w900, fontFamily: 'sans-serif')),
      ],
    );
  }

  /// 로켓배송 / 프레시 / 직구 공식 배지
  static Widget badge(RocketBadgeType type, {double scale = 1.0}) {
    switch (type) {
      case RocketBadgeType.rocket:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFF0073E9),
            borderRadius: BorderRadius.circular(3 * scale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.paperplane_fill, color: const Color(0xFFFFFFFF), size: 10 * scale),
              SizedBox(width: 3 * scale),
              Text(
                '로켓배송',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        );
      case RocketBadgeType.rocketFresh:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFF009245),
            borderRadius: BorderRadius.circular(3 * scale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.leaf_arrow_circlepath, color: const Color(0xFFFFFFFF), size: 10 * scale),
              SizedBox(width: 3 * scale),
              Text(
                '로켓프레시',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        );
      case RocketBadgeType.rocketGlobal:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFF5B32E4),
            borderRadius: BorderRadius.circular(3 * scale),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(CupertinoIcons.airplane, color: const Color(0xFFFFFFFF), size: 10 * scale),
              SizedBox(width: 3 * scale),
              Text(
                '로켓직구',
                style: TextStyle(
                  color: const Color(0xFFFFFFFF),
                  fontSize: 10 * scale,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        );
      case RocketBadgeType.wowOnly:
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5 * scale, vertical: 2 * scale),
          decoration: BoxDecoration(
            color: const Color(0xFF7B2CBF),
            borderRadius: BorderRadius.circular(3 * scale),
          ),
          child: Text(
            '와우회원가',
            style: TextStyle(
              color: const Color(0xFFFFFFFF),
              fontSize: 10 * scale,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        );
    }
  }

  /// 별점 렌더러
  static Widget ratingStars(double rating, {double size = 12}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (rating >= index + 1) {
          return Icon(CupertinoIcons.star_fill, color: const Color(0xFFFFB800), size: size);
        } else if (rating >= index + 0.5) {
          return Icon(CupertinoIcons.star_lefthalf_fill, color: const Color(0xFFFFB800), size: size);
        } else {
          return Icon(CupertinoIcons.star, color: const Color(0xFFCCCCCC), size: size);
        }
      }),
    );
  }
}
