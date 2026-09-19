import 'package:flutter/material.dart';
import 'data/word_model.dart';
import 'widgets/word_document_canvas.dart';
import 'widgets/word_edit_dialog.dart';
import 'widgets/word_ribbon.dart';

class WordScreen extends StatefulWidget {
  final WordConfig config;
  final ValueChanged<WordConfig>? onConfigChanged;

  const WordScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  late WordConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(covariant WordScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _config = widget.config;
    }
  }

  void _updateConfig(WordConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => WordEditDialog(
        config: _config,
        onApply: _updateConfig,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE1DFDD),
      child: Column(
        children: [
          // 1. Blue Ribbon Bar
          WordRibbon(
            documentTitle: _config.documentTitle,
            onOpenEdit: _openEditDialog,
          ),

          // 2. Main A4 Paper Canvas
          Expanded(
            child: WordDocumentCanvas(
              config: _config,
            ),
          ),
        ],
      ),
    );
  }
}
