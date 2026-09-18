import 'package:flutter/material.dart';
import '../data/visual_studio_model.dart';

class VisualStudioCodeEditor extends StatelessWidget {
  final VisualStudioConfig config;
  final ValueChanged<int>? onToggleBreakpoint;

  const VisualStudioCodeEditor({
    super.key,
    required this.config,
    this.onToggleBreakpoint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          // 1. File Tabs Row (30px)
          _buildFileTabs(),

          // 2. Navigation Breadcrumbs (22px)
          _buildBreadcrumbs(),

          // 3. Code Stream Area
          Expanded(
            child: Row(
              children: [
                // Code Scrollable Area
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: config.codeLines.length,
                    itemBuilder: (context, idx) {
                      final line = config.codeLines[idx];
                      return _buildCodeLineRow(line);
                    },
                  ),
                ),

                // Right Code Minimap (48px)
                _buildMinimap(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTabs() {
    return Container(
      height: 30,
      color: const Color(0xFF252526),
      child: Row(
        children: [
          // Active Tab: FictionEngine.cs
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E1E1E),
              border: Border(
                top: BorderSide(color: Color(0xFF68217A), width: 2),
                right: BorderSide(color: Color(0xFF252526), width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF239120),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text('C#', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 6),
                Text(
                  '${config.activeFileName} *',
                  style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.close, size: 12, color: Color(0xFF9E9E9E)),
              ],
            ),
          ),
          // Inactive Tab: Program.cs
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF2D2D30),
              border: Border(right: BorderSide(color: Color(0xFF252526), width: 1)),
            ),
            child: const Row(
              children: [
                Text('Program.cs', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 11.5)),
                SizedBox(width: 6),
                Icon(Icons.close, size: 12, color: Color(0xFF6E6E6E)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumbs() {
    return Container(
      height: 22,
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF2D2D30), width: 1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.folder_open, size: 11, color: Color(0xFF888888)),
          SizedBox(width: 4),
          Text(
            'FictionCore > Services > FictionEngine > GenerateEpicScenarioAsync(string prompt)',
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 10.5),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeLineRow(CodeLine line) {
    final isBreakpoint = line.lineNumber == config.breakpointLine;

    return Container(
      height: 20,
      color: isBreakpoint
          ? const Color(0xFF68217A).withValues(alpha: 0.25)
          : (line.isExecutionLine && config.isDebugging
              ? const Color(0xFF856404).withValues(alpha: 0.3)
              : Colors.transparent),
      child: Row(
        children: [
          // Breakpoint & Gutter Column (44px)
          SizedBox(
            width: 44,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Breakpoint indicator
                InkWell(
                  onTap: () => onToggleBreakpoint?.call(line.lineNumber),
                  child: Container(
                    width: 14,
                    height: 14,
                    alignment: Alignment.center,
                    child: isBreakpoint
                        ? Container(
                            width: 11,
                            height: 11,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE51400),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFE51400).withValues(alpha: 0.6),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          )
                        : (line.isExecutionLine && config.isDebugging
                            ? const Icon(Icons.arrow_right, size: 14, color: Color(0xFFFFD700))
                            : const SizedBox()),
                  ),
                ),
                const SizedBox(width: 4),
                // Line Number
                Text(
                  '${line.lineNumber}',
                  style: TextStyle(
                    color: isBreakpoint ? Colors.white : const Color(0xFF858585),
                    fontSize: 11,
                    fontFamily: 'Consolas',
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),

          // Code Text with Syntax Coloring
          Expanded(
            child: _buildSyntaxHighlightedText(line.content),
          ),
        ],
      ),
    );
  }

  Widget _buildSyntaxHighlightedText(String text) {
    final spans = <TextSpan>[];

    // Simple regex lexer for C# in Visual Studio
    final tokens = text.split(' ');
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      final trimmed = token.trim();

      Color color = const Color(0xFFD4D4D4); // default text color

      if (['using', 'namespace', 'public', 'class', 'private', 'readonly', 'const', 'int', 'async', 'string', 'var', 'new', 'if', 'return', 'static'].contains(trimmed)) {
        color = const Color(0xFF569CD6); // Keyword blue
      } else if (['Task', 'ILogger', 'FictionResult', 'CreativeScenario', 'IFictionService', 'ScenarioStatus', 'FictionEngine'].contains(trimmed.replaceAll(RegExp(r'[<>()/{};,]'), ''))) {
        color = const Color(0xFF4EC9B0); // Class/Type teal
      } else if (trimmed.startsWith('//') || trimmed.startsWith('///')) {
        color = const Color(0xFF6A9955); // Comment green
      } else if (trimmed.startsWith('"') || trimmed.endsWith('"')) {
        color = const Color(0xFFCE9178); // String orange
      } else if (trimmed.contains('(')) {
        color = const Color(0xFFDCDCAA); // Method yellow
      }

      spans.add(TextSpan(text: '$token ', style: TextStyle(color: color, fontSize: 12, fontFamily: 'Consolas')));
    }

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.visible,
    );
  }

  Widget _buildMinimap() {
    return Container(
      width: 48,
      color: const Color(0xFF252526),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(18, (idx) {
          final width = (idx % 3 == 0) ? 36.0 : (idx % 2 == 0 ? 24.0 : 30.0);
          return Container(
            width: width,
            height: 2,
            margin: const EdgeInsets.symmetric(vertical: 1.5),
            color: (idx == 12) ? const Color(0xFFE51400) : const Color(0xFF4A4A4A),
          );
        }),
      ),
    );
  }
}
