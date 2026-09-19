/// Microsoft Edge 설정 모델
class EdgeConfig {
  final String url;
  final bool isBrowsing;

  const EdgeConfig({
    required this.url,
    required this.isBrowsing,
  });

  EdgeConfig copyWith({
    String? url,
    bool? isBrowsing,
  }) {
    return EdgeConfig(
      url: url ?? this.url,
      isBrowsing: isBrowsing ?? this.isBrowsing,
    );
  }

  static EdgeConfig defaultPreset() {
    return const EdgeConfig(
      url: 'https://fiction-screen.web.app',
      isBrowsing: false,
    );
  }
}
