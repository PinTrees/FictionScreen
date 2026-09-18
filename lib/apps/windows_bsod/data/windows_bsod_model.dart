class WindowsBsodConfig {
  int percentage;
  String stopCode;
  String whatFailed;
  String supportUrl;
  bool isWin11;

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
