class WindowsBsodConfig {
  int percentage;
  String stopCode;
  String whatFailed;
  String supportUrl;
  bool isWin11; // 윈도우 11 블랙스크린 모드 or 전통 블루

  WindowsBsodConfig({
    this.percentage = 70,
    this.stopCode = 'CRITICAL_PROCESS_DIED',
    this.whatFailed = '',
    this.supportUrl = 'https://www.windows.com/stopcode',
    this.isWin11 = false,
  });

  static WindowsBsodConfig defaultPreset() {
    return WindowsBsodConfig(
      percentage: 67,
      stopCode: 'CRITICAL_PROCESS_DIED',
      whatFailed: '',
      supportUrl: 'https://www.windows.com/stopcode',
    );
  }
}
