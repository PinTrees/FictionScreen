import 'package:flutter/material.dart';
import '../data/visual_studio_model.dart';

class VisualStudioEditDialog extends StatefulWidget {
  final VisualStudioConfig initialConfig;
  final ValueChanged<VisualStudioConfig> onSave;

  const VisualStudioEditDialog({
    super.key,
    required this.initialConfig,
    required this.onSave,
  });

  @override
  State<VisualStudioEditDialog> createState() => _VisualStudioEditDialogState();
}

class _VisualStudioEditDialogState extends State<VisualStudioEditDialog> {
  late TextEditingController _solutionController;
  late TextEditingController _projectController;
  late TextEditingController _fileController;
  late TextEditingController _codeController;
  late TextEditingController _breakpointController;
  late TextEditingController _buildStatusController;
  late String _configuration;
  late String _platform;
  late bool _isDebugging;

  @override
  void initState() {
    super.initState();
    final cfg = widget.initialConfig;
    _solutionController = TextEditingController(text: cfg.solutionName);
    _projectController = TextEditingController(text: cfg.projectName);
    _fileController = TextEditingController(text: cfg.activeFileName);
    _breakpointController = TextEditingController(text: cfg.breakpointLine.toString());
    _buildStatusController = TextEditingController(text: cfg.buildStatus);
    _configuration = cfg.configuration;
    _platform = cfg.platform;
    _isDebugging = cfg.isDebugging;

    final codeText = cfg.codeLines.map((l) => l.content).join('\n');
    _codeController = TextEditingController(text: codeText);
  }

  @override
  void dispose() {
    _solutionController.dispose();
    _projectController.dispose();
    _fileController.dispose();
    _codeController.dispose();
    _breakpointController.dispose();
    _buildStatusController.dispose();
    super.dispose();
  }

  void _save() {
    final bpLine = int.tryParse(_breakpointController.text) ?? 19;
    final lines = _codeController.text.split('\n');
    final codeLines = List.generate(lines.length, (idx) {
      final lineNum = idx + 1;
      return CodeLine(
        lineNumber: lineNum,
        content: lines[idx],
        hasBreakpoint: lineNum == bpLine,
        isExecutionLine: _isDebugging && lineNum == bpLine,
      );
    });

    final updated = widget.initialConfig.copyWith(
      solutionName: _solutionController.text.trim(),
      projectName: _projectController.text.trim(),
      activeFileName: _fileController.text.trim(),
      configuration: _configuration,
      platform: _platform,
      buildStatus: _buildStatusController.text.trim(),
      isDebugging: _isDebugging,
      breakpointLine: bpLine,
      codeLines: codeLines,
    );

    widget.onSave(updated);
    Navigator.of(context).pop();
  }

  void _restoreDefaults() {
    final def = VisualStudioConfig.defaultPreset();
    setState(() {
      _solutionController.text = def.solutionName;
      _projectController.text = def.projectName;
      _fileController.text = def.activeFileName;
      _breakpointController.text = def.breakpointLine.toString();
      _buildStatusController.text = def.buildStatus;
      _configuration = def.configuration;
      _platform = def.platform;
      _isDebugging = def.isDebugging;
      _codeController.text = def.codeLines.map((l) => l.content).join('\n');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF252526),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        width: 680,
        height: 720,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF68217A),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.code, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Visual Studio 2026 환경 설정',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '솔루션, C# 소스 코드, 중단점 및 빌드 설정을 편집합니다.',
                      style: TextStyle(color: Colors.white60, fontSize: 12),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(color: Color(0xFF3E3E42), height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('솔루션 파일명', _solutionController),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('프로젝트명', _projectController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField('활성 파일명 (.cs)', _fileController),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField('중단점 라인 번호', _breakpointController, isNumber: true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown('빌드 구성', _configuration, ['Debug', 'Release'], (val) {
                            if (val != null) setState(() => _configuration = val);
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdown('플랫폼', _platform, ['Any CPU', 'x64', 'ARM64'], (val) {
                            if (val != null) setState(() => _platform = val);
                          }),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('디버깅 상태', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Switch(
                                    value: _isDebugging,
                                    activeThumbColor: const Color(0xFF68217A),
                                    onChanged: (v) => setState(() => _isDebugging = v),
                                  ),
                                  Text(
                                    _isDebugging ? '디버깅 중' : '정지됨',
                                    style: TextStyle(
                                      color: _isDebugging ? const Color(0xFF4EC9B0) : Colors.white60,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextField('빌드 완료 상태 메시지', _buildStatusController),
                    const SizedBox(height: 16),
                    const Text(
                      'C# 소스 코드 (실시간 구문 강조 적용)',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        border: Border.all(color: const Color(0xFF3E3E42)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        controller: _codeController,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontFamily: 'Consolas',
                          fontSize: 12,
                          color: Color(0xFFD4D4D4),
                          height: 1.4,
                        ),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Color(0xFF3E3E42), height: 24),
            Row(
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                  label: const Text('기본값 복원', style: TextStyle(color: Colors.white70)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3E3E42)),
                  ),
                  onPressed: _restoreDefaults,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소', style: TextStyle(color: Colors.white60)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF68217A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: _save,
                  child: const Text('적용하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            border: Border.all(color: const Color(0xFF3E3E42)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            border: Border.all(color: const Color(0xFF3E3E42)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              dropdownColor: const Color(0xFF252526),
              isExpanded: true,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white70),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
