import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 넷플릭스 데스크탑 푸터
class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 36),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(CupertinoIcons.globe, color: Colors.white54, size: 16),
              SizedBox(width: 6),
              Text('한국어', style: TextStyle(color: Colors.white54, fontSize: 12)),
            ],
          ),
          SizedBox(height: 16),
          Text(
            '넷플릭스서비시스코리아 유한회사 통신판매업신고번호: 제2018-서울종로-1002호 전화번호: 00-308-321-0161 (수신자 부담)',
            style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.5),
          ),
          Text(
            '대표: 레지널드 숀 톰프슨 | 이메일 주소: korea@netflix.com | 주소: 대한민국 서울특별시 종로구 우정국로 26, 센트로폴리스 A동 20층',
            style: TextStyle(color: Colors.white38, fontSize: 11, height: 1.5),
          ),
        ],
      ),
    );
  }
}
