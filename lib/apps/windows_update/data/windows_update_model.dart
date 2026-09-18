/// Windows 가짜 업데이트 스크린 설정 모델
class WindowsUpdateConfig {
  int progress;
  String version; // 'win11' vs 'win10'
  bool isAnimated;
  String primaryMessage;
  String secondaryMessage;

  WindowsUpdateConfig({
    this.progress = 35,
    this.version = 'win11',
    this.isAnimated = true,
    this.primaryMessage = 'Windows 업데이트 작업 중입니다',
    this.secondaryMessage = 'PC를 켜놓은 상태로 유지하십시오.\nPC를 끄지 마십시오. 이 작업은 다소 시간이 걸릴 수 있습니다.',
  });

  factory WindowsUpdateConfig.defaultPreset() => WindowsUpdateConfig();
}
