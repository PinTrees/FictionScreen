import 'package:flutter/material.dart';
import 'data/daangn_model.dart';
import 'pages/daangn_chat_page.dart';
import 'widgets/daangn_edit_dialog.dart';

/// 당근마켓 메인 스크린 쉘 위젯
class DaangnScreen extends StatefulWidget {
  final DaangnConfig config;
  final ValueChanged<DaangnConfig>? onConfigChanged;

  const DaangnScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<DaangnScreen> createState() => _DaangnScreenState();
}

class _DaangnScreenState extends State<DaangnScreen> {
  void _openEditDialog() {
    DaangnEditDialog.show(context, widget.config, (updated) {
      setState(() {});
      widget.onConfigChanged?.call(updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DaangnChatPage(
          config: widget.config,
          onHeaderTap: _openEditDialog,
          onProductCardTap: _openEditDialog,
        ),
      ),
    );
  }
}
