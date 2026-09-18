import 'package:flutter/material.dart';
import '../data/visual_studio_model.dart';

class VisualStudioBottomPanel extends StatefulWidget {
  final List<BuildOutput> outputs;
  final String buildStatus;

  const VisualStudioBottomPanel({
    super.key,
    required this.outputs,
    required this.buildStatus,
  });

  @override
  State<VisualStudioBottomPanel> createState() => _VisualStudioBottomPanelState();
}

class _VisualStudioBottomPanelState extends State<VisualStudioBottomPanel> {
  int _selectedTabIndex = 0; // 0: 출력, 1: 오류 목록, 2: 터미널

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(
        color: Color(0xFF252526),
        border: Border(top: BorderSide(color: Color(0xFF3F3F46), width: 1)),
      ),
      child: Column(
        children: [
          // Tabs Bar
          Container(
            height: 26,
            color: const Color(0xFF2D2D30),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                _buildTab(0, '출력 (Output)'),
                _buildTab(1, '오류 목록 (Error List)'),
                _buildTab(2, '터미널 (Terminal)'),
                const Spacer(),
                const Icon(Icons.minimize, size: 12, color: Color(0xFF9E9E9E)),
                const SizedBox(width: 8),
                const Icon(Icons.close, size: 12, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildOutputView()
                : (_selectedTabIndex == 1 ? _buildErrorListView() : _buildTerminalView()),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(int idx, String title) {
    final isSelected = _selectedTabIndex == idx;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = idx),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E1E1E) : Colors.transparent,
          border: isSelected ? const Border(top: BorderSide(color: Color(0xFF68217A), width: 2)) : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF9E9E9E),
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _buildOutputView() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(8),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: widget.outputs.length,
        itemBuilder: (context, idx) {
          final out = widget.outputs[idx];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 1),
            child: Text(
              out.message,
              style: TextStyle(
                color: out.type == 'error'
                    ? const Color(0xFFF48771)
                    : (out.type == 'success' ? const Color(0xFF89D185) : const Color(0xFFCCCCCC)),
                fontSize: 11,
                fontFamily: 'Consolas',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorListView() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text('0개의 오류', style: TextStyle(color: Color(0xFF89D185), fontSize: 11, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF57F17).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text('0개의 경고', style: TextStyle(color: Color(0xFFFFD54F), fontSize: 11)),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF1976D2).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text('0개의 메시지', style: TextStyle(color: Color(0xFF64B5F6), fontSize: 11)),
          ),
          const Spacer(),
          const Text('현재 프로젝트의 코드 분석 완료 (문제 없음)', style: TextStyle(color: Color(0xFF888888), fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildTerminalView() {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.all(8),
      child: const Text(
        'PS C:\\Users\\Developer\\source\\repos\\FictionScreen> dotnet run\n[FictionCore] Scenario engine listening on https://localhost:7026',
        style: TextStyle(color: Color(0xFFD4D4D4), fontSize: 11, fontFamily: 'Consolas'),
      ),
    );
  }
}
