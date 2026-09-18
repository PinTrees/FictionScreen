import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 스튜디오 우측 상세 인스펙터/에디터 패널
class StudioAdvancedPanel extends StatelessWidget {
  final String templateId;
  final VoidCallback onClose;
  final VoidCallback onOpenEditDialog;
  final VoidCallback? onAddKakaoMessage;

  const StudioAdvancedPanel({
    super.key,
    required this.templateId,
    required this.onClose,
    required this.onOpenEditDialog,
    this.onAddKakaoMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12141D),
        border: Border(left: BorderSide(color: Colors.white.withValues(alpha: 0.08))),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.08)))),
            child: Row(
              children: [
                const Text('상세 에디터 패널', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const Spacer(),
                IconButton(icon: const Icon(CupertinoIcons.xmark, color: Colors.white70, size: 16), onPressed: onClose),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(CupertinoIcons.pencil, size: 16),
                  label: const Text('항목 전체 편집 다이얼로그 열기', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: onOpenEditDialog,
                ),
                const SizedBox(height: 16),
                if (templateId == 'kakaotalk' && onAddKakaoMessage != null) ...[
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 40),
                      side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    icon: const Icon(CupertinoIcons.plus, size: 16),
                    label: const Text('새 카카오톡 메시지 추가'),
                    onPressed: onAddKakaoMessage,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
