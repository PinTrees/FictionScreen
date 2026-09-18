import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 실제 인스타그램 공식 UI 아이콘 및 로고 모음
class InstagramIcons {
  InstagramIcons._();

  /// 인스타그램 공식 워드마크 로고
  static Widget wordmark({
    double height = 28,
    Color color = Colors.black,
  }) {
    return SvgPicture.asset(
      'assets/images/instagram_wordmark.svg',
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );
  }

  /// 홈 아이콘 (Outline & Filled)
  static Widget home({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    if (filled) {
      return SvgPicture.string(
        '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="$_toHex(color)">
          <path d="M22 23h-6.001a1 1 0 0 1-1-1v-5.455a2.997 2.997 0 1 0-5.993 0V22a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V11.543a1.002 1.002 0 0 1 .31-.724l10-9.543a1.001 1.001 0 0 1 1.38 0l10 9.543a1.002 1.002 0 0 1 .31.724V22a1 1 0 0 1-1 1Z"/>
        </svg>''',
        width: size,
        height: size,
      );
    }
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M3 9.5L12 3l9 6.5V20a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V9.5z"/>
        <polyline points="9 22 9 12 15 12 15 22"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 검색 아이콘
  static Widget search({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    final strokeWidth = filled ? '2.8' : '2.2';
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round">
        <circle cx="11" cy="11" r="7.5"/>
        <line x1="21" y1="21" x2="16.5" y2="16.5"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 게시물 생성 (+) 아이콘
  static Widget create({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    final strokeWidth = filled ? '2.6' : '2';
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="$strokeWidth" stroke-linecap="round" stroke-linejoin="round">
        <rect x="3" y="3" width="18" height="18" rx="5" ry="5"/>
        <line x1="12" y1="8" x2="12" y2="16"/>
        <line x1="8" y1="12" x2="16" y2="12"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 릴스 아이콘 (Clapperboard with Play button)
  static Widget reels({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    final playFill = filled ? _toHex(color) : 'none';
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <rect x="2.5" y="2.5" width="19" height="19" rx="5"/>
        <path d="M2.5 8.5h19"/>
        <path d="M7 2.5l2.5 6"/>
        <path d="M14.5 2.5l2.5 6"/>
        <polygon points="10 12 16 15 10 18 10 12" fill="$playFill" stroke="$_toHex(color)"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 하트 (좋아요 / 알림) 아이콘
  static Widget heart({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    if (filled) {
      return SvgPicture.string(
        '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="$_toHex(color)">
          <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
        </svg>''',
        width: size,
        height: size,
      );
    }
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 댓글 말풍선 아이콘 (인스타그램 고유의 타원형 말풍선)
  static Widget comment({
    Color color = Colors.black,
    double size = 24,
  }) {
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 비행기 / DM 공유 아이콘
  static Widget share({
    Color color = Colors.black,
    double size = 24,
  }) {
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <line x1="22" y1="2" x2="11" y2="13"/>
        <polygon points="22 2 15 22 11 13 2 9 22 2"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 인스타그램 메신저 / 종이비행기 DM 아이콘
  static Widget messenger({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="none" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 2L11 13"/>
        <path d="M22 2L15 22L11 13L2 9L22 2Z"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  /// 북마크 / 저장 아이콘
  static Widget bookmark({
    bool filled = false,
    Color color = Colors.black,
    double size = 24,
  }) {
    final fill = filled ? _toHex(color) : 'none';
    return SvgPicture.string(
      '''<svg viewBox="0 0 24 24" width="$size" height="$size" fill="$fill" stroke="$_toHex(color)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"/>
      </svg>''',
      width: size,
      height: size,
    );
  }

  static String _toHex(Color c) {
    return '#${c.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
  }
}
