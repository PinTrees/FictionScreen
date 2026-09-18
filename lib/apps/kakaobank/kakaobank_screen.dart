import 'package:flutter/material.dart';
import 'data/kakaobank_model.dart';
import 'data/kakaobank_transfer_page.dart';
import 'pages/kakaobank_home_page.dart';
import 'widgets/kakaobank_bottom_nav.dart';

/// 카카오뱅크 메인 스크린 쉘 위젯
class KakaoBankScreen extends StatefulWidget {
  final KakaoBankConfig config;

  const KakaoBankScreen({
    super.key,
    required this.config,
  });

  @override
  State<KakaoBankScreen> createState() => _KakaoBankScreenState();
}

class _KakaoBankScreenState extends State<KakaoBankScreen> {
  int _activeNavIndex = 0;
  bool _showTransferPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _showTransferPage
                  ? KakaoBankTransferPage(
                      config: widget.config,
                      onClose: () => setState(() => _showTransferPage = false),
                    )
                  : KakaoBankHomePage(
                      config: widget.config,
                      onTransferTap: () => setState(() => _showTransferPage = true),
                    ),
            ),
            KakaoBankBottomNav(
              activeIndex: _activeNavIndex,
              onTap: (idx) => setState(() => _activeNavIndex = idx),
            ),
          ],
        ),
      ),
    );
  }
}
