class SolutionItem {
  final String id;
  final String name;
  final String type; // 'solution', 'project', 'folder', 'csharp', 'json', 'config'
  final bool isExpanded;
  final List<SolutionItem> children;

  const SolutionItem({
    required this.id,
    required this.name,
    required this.type,
    this.isExpanded = true,
    this.children = const [],
  });

  SolutionItem copyWith({
    String? id,
    String? name,
    String? type,
    bool? isExpanded,
    List<SolutionItem>? children,
  }) {
    return SolutionItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      isExpanded: isExpanded ?? this.isExpanded,
      children: children ?? this.children,
    );
  }
}

class CodeLine {
  final int lineNumber;
  final String content;
  final bool hasBreakpoint;
  final bool isExecutionLine;

  const CodeLine({
    required this.lineNumber,
    required this.content,
    this.hasBreakpoint = false,
    this.isExecutionLine = false,
  });

  CodeLine copyWith({
    int? lineNumber,
    String? content,
    bool? hasBreakpoint,
    bool? isExecutionLine,
  }) {
    return CodeLine(
      lineNumber: lineNumber ?? this.lineNumber,
      content: content ?? this.content,
      hasBreakpoint: hasBreakpoint ?? this.hasBreakpoint,
      isExecutionLine: isExecutionLine ?? this.isExecutionLine,
    );
  }
}

class BuildOutput {
  final String message;
  final String type; // 'info', 'success', 'warning', 'error'
  final String? code;
  final int? line;

  const BuildOutput({
    required this.message,
    this.type = 'info',
    this.code,
    this.line,
  });
}

class VisualStudioConfig {
  final String solutionName;
  final String projectName;
  final String activeFileName;
  final String configuration; // 'Debug', 'Release'
  final String platform; // 'Any CPU', 'x64', 'ARM64'
  final String buildStatus;
  final bool isDebugging;
  final int breakpointLine;
  final List<CodeLine> codeLines;
  final List<SolutionItem> solutionItems;
  final List<BuildOutput> outputMessages;

  const VisualStudioConfig({
    required this.solutionName,
    required this.projectName,
    required this.activeFileName,
    this.configuration = 'Debug',
    this.platform = 'Any CPU',
    this.buildStatus = '빌드 성공 (경과 시간: 00:00:01.42)',
    this.isDebugging = false,
    this.breakpointLine = 19,
    required this.codeLines,
    required this.solutionItems,
    required this.outputMessages,
  });

  VisualStudioConfig copyWith({
    String? solutionName,
    String? projectName,
    String? activeFileName,
    String? configuration,
    String? platform,
    String? buildStatus,
    bool? isDebugging,
    int? breakpointLine,
    List<CodeLine>? codeLines,
    List<SolutionItem>? solutionItems,
    List<BuildOutput>? outputMessages,
  }) {
    return VisualStudioConfig(
      solutionName: solutionName ?? this.solutionName,
      projectName: projectName ?? this.projectName,
      activeFileName: activeFileName ?? this.activeFileName,
      configuration: configuration ?? this.configuration,
      platform: platform ?? this.platform,
      buildStatus: buildStatus ?? this.buildStatus,
      isDebugging: isDebugging ?? this.isDebugging,
      breakpointLine: breakpointLine ?? this.breakpointLine,
      codeLines: codeLines ?? this.codeLines,
      solutionItems: solutionItems ?? this.solutionItems,
      outputMessages: outputMessages ?? this.outputMessages,
    );
  }

  static VisualStudioConfig defaultPreset() {
    const rawCode = '''using System;
using System.Threading.Tasks;
using FictionScreen.Core.Models;

namespace FictionScreen.Core
{
    /// <summary>
    /// 픽션 스크린 초특급 바이럴 시나리오 생성 엔진 v2026
    /// </summary>
    public class FictionEngine : IFictionService
    {
        private readonly ILogger<FictionEngine> _logger;
        private const int MaximumViralPower = 99999;

        public async Task<FictionResult> GenerateEpicScenarioAsync(string prompt)
        {
            _logger.LogInformation("시나리오 생성 시작: {Prompt}", prompt);
            var scenario = new CreativeScenario(prompt);

            // [중단점] 실시간 바이럴 지수 계산 루프
            var viralScore = await CalculateViralScoreAsync(scenario);
            if (viralScore > 8000)
            {
                _logger.LogWarning("주의: 바이럴 지수 임계값 초과! 실시간 트렌드 1위 예상");
            }

            return new FictionResult
            {
                Title = "신입사원의 반란: 회장님 의자에서 낮잠자기",
                ViralScore = viralScore,
                Status = ScenarioStatus.ReadyToPost
            };
        }
    }
}''';

    final lines = rawCode.split('\n');
    final codeLines = List.generate(lines.length, (idx) {
      final lineNum = idx + 1;
      return CodeLine(
        lineNumber: lineNum,
        content: lines[idx],
        hasBreakpoint: lineNum == 19,
        isExecutionLine: lineNum == 19,
      );
    });

    final solutionItems = [
      const SolutionItem(
        id: 'sol-root',
        name: '솔루션 \'PinTrees.FictionScreen\' (프로젝트 1개)',
        type: 'solution',
        children: [
          SolutionItem(
            id: 'proj-1',
            name: 'FictionCore (net9.0)',
            type: 'project',
            children: [
              SolutionItem(id: 'f-1', name: 'Connected Services', type: 'folder'),
              SolutionItem(id: 'f-2', name: '종속성 (Dependencies)', type: 'folder'),
              SolutionItem(
                id: 'f-3',
                name: 'Controllers',
                type: 'folder',
                children: [
                  SolutionItem(id: 'c-1', name: 'ScenarioController.cs', type: 'csharp'),
                  SolutionItem(id: 'c-2', name: 'MemeApiController.cs', type: 'csharp'),
                ],
              ),
              SolutionItem(
                id: 'f-4',
                name: 'Services',
                type: 'folder',
                children: [
                  SolutionItem(id: 's-1', name: 'FictionEngine.cs', type: 'csharp'),
                  SolutionItem(id: 's-2', name: 'AiPromptOptimizer.cs', type: 'csharp'),
                ],
              ),
              SolutionItem(id: 'p-1', name: 'Program.cs', type: 'csharp'),
              SolutionItem(id: 'p-2', name: 'appsettings.json', type: 'json'),
            ],
          ),
        ],
      ),
    ];

    final outputMessages = [
      const BuildOutput(message: '1>------ 빌드 시작: 프로젝트: FictionCore, 구성: Debug Any CPU ------', type: 'info'),
      const BuildOutput(message: '1>FictionCore -> bin\\Debug\\net9.0\\FictionCore.dll', type: 'info'),
      const BuildOutput(message: '========== 빌드: 성공 1개, 실패 0개, 최신 0개, 생략 0개 ==========', type: 'success'),
      const BuildOutput(message: '========== 빌드 완료: 00:00:01.42에 완료되었습니다 ==========', type: 'success'),
    ];

    return VisualStudioConfig(
      solutionName: 'PinTrees.FictionScreen.sln',
      projectName: 'FictionCore',
      activeFileName: 'FictionEngine.cs',
      configuration: 'Debug',
      platform: 'Any CPU',
      buildStatus: '빌드 성공 (경과 시간: 00:00:01.42)',
      isDebugging: false,
      breakpointLine: 19,
      codeLines: codeLines,
      solutionItems: solutionItems,
      outputMessages: outputMessages,
    );
  }
}
