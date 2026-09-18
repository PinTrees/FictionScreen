import 'package:flutter/material.dart';
import 'data/daangn_model.dart';
import 'pages/daangn_chat_page.dart';

/// 당근마켓 메인 스크린 쉘 위젯
class DaangnScreen extends StatefulWidget {
  final DaangnConfig config;

  const DaangnScreen({
    super.key,
    required this.config,
  });

  @override
  State<DaangnScreen> createState() => _DaangnScreenState();
}

class _DaangnScreenState extends State<DaangnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DaangnChatPage(
          config: widget.config,
          onHeaderTap: () {},
          onProductCardTap: () {},
        ),
      ),
    );
  }
}
