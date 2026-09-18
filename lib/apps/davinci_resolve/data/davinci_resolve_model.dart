import 'package:flutter/material.dart';

enum DavinciPage {
  media('Media', Icons.perm_media_outlined),
  cut('Cut', Icons.movie_filter_outlined),
  edit('Edit', Icons.content_cut_outlined),
  fusion('Fusion', Icons.hub_outlined),
  color('Color', Icons.palette_outlined),
  fairlight('Fairlight', Icons.graphic_eq_outlined),
  deliver('Deliver', Icons.rocket_launch_outlined);

  final String label;
  final IconData icon;
  const DavinciPage(this.label, this.icon);
}

class GradingNode {
  final int id;
  final String label;
  final bool isBypassed;
  final bool isSelected;

  const GradingNode({
    required this.id,
    required this.label,
    this.isBypassed = false,
    this.isSelected = false,
  });

  GradingNode copyWith({
    int? id,
    String? label,
    bool? isBypassed,
    bool? isSelected,
  }) {
    return GradingNode(
      id: id ?? this.id,
      label: label ?? this.label,
      isBypassed: isBypassed ?? this.isBypassed,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class ColorWheelValues {
  final Offset lift; // (-1.0 ~ 1.0)
  final double liftMaster;
  final Offset gamma;
  final double gammaMaster;
  final Offset gain;
  final double gainMaster;
  final Offset offset;
  final double offsetMaster;
  final double temp; // -100 ~ 100
  final double tint; // -100 ~ 100
  final double contrast; // 0.0 ~ 2.0
  final double saturation; // 0 ~ 100

  const ColorWheelValues({
    this.lift = const Offset(0.0, 0.0),
    this.liftMaster = 0.0,
    this.gamma = const Offset(0.0, 0.0),
    this.gammaMaster = 0.0,
    this.gain = const Offset(0.0, 0.0),
    this.gainMaster = 0.0,
    this.offset = const Offset(0.0, 0.0),
    this.offsetMaster = 0.0,
    this.temp = 0.0,
    this.tint = 0.0,
    this.contrast = 1.0,
    this.saturation = 50.0,
  });

  ColorWheelValues copyWith({
    Offset? lift,
    double? liftMaster,
    Offset? gamma,
    double? gammaMaster,
    Offset? gain,
    double? gainMaster,
    Offset? offset,
    double? offsetMaster,
    double? temp,
    double? tint,
    double? contrast,
    double? saturation,
  }) {
    return ColorWheelValues(
      lift: lift ?? this.lift,
      liftMaster: liftMaster ?? this.liftMaster,
      gamma: gamma ?? this.gamma,
      gammaMaster: gammaMaster ?? this.gammaMaster,
      gain: gain ?? this.gain,
      gainMaster: gainMaster ?? this.gainMaster,
      offset: offset ?? this.offset,
      offsetMaster: offsetMaster ?? this.offsetMaster,
      temp: temp ?? this.temp,
      tint: tint ?? this.tint,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
    );
  }
}

class TimelineClip {
  final String title;
  final double start;
  final double duration;
  final Color color;

  const TimelineClip({
    required this.title,
    required this.start,
    required this.duration,
    required this.color,
  });
}

class TimelineTrack {
  final String name;
  final bool isVideo;
  final bool isMuted;
  final bool isLocked;
  final List<TimelineClip> clips;

  const TimelineTrack({
    required this.name,
    required this.isVideo,
    this.isMuted = false,
    this.isLocked = false,
    required this.clips,
  });
}

class DavinciConfig {
  final String projectName;
  final String timelineName;
  final String activeTimecode;
  final String resolution;
  final DavinciPage activePage;
  final List<GradingNode> nodes;
  final ColorWheelValues colorValues;
  final List<TimelineTrack> tracks;
  final bool isPlaying;
  final String activeLutPreset;
  final String renderStatus;

  const DavinciConfig({
    required this.projectName,
    required this.timelineName,
    this.activeTimecode = '01:00:14:22',
    this.resolution = '3840 x 2160 Ultra HD 24.00fps',
    this.activePage = DavinciPage.color,
    required this.nodes,
    required this.colorValues,
    required this.tracks,
    this.isPlaying = false,
    this.activeLutPreset = 'Teal & Orange (헐리우드 블록버스터)',
    this.renderStatus = '대기 중 (H.265 Master 4K)',
  });

  DavinciConfig copyWith({
    String? projectName,
    String? timelineName,
    String? activeTimecode,
    String? resolution,
    DavinciPage? activePage,
    List<GradingNode>? nodes,
    ColorWheelValues? colorValues,
    List<TimelineTrack>? tracks,
    bool? isPlaying,
    String? activeLutPreset,
    String? renderStatus,
  }) {
    return DavinciConfig(
      projectName: projectName ?? this.projectName,
      timelineName: timelineName ?? this.timelineName,
      activeTimecode: activeTimecode ?? this.activeTimecode,
      resolution: resolution ?? this.resolution,
      activePage: activePage ?? this.activePage,
      nodes: nodes ?? this.nodes,
      colorValues: colorValues ?? this.colorValues,
      tracks: tracks ?? this.tracks,
      isPlaying: isPlaying ?? this.isPlaying,
      activeLutPreset: activeLutPreset ?? this.activeLutPreset,
      renderStatus: renderStatus ?? this.renderStatus,
    );
  }

  static DavinciConfig defaultPreset() {
    final defaultNodes = [
      const GradingNode(id: 1, label: 'Base Balance & Exposure', isSelected: false),
      const GradingNode(id: 2, label: 'Teal & Orange Grade', isSelected: true),
      const GradingNode(id: 3, label: 'Glow & Film Grain', isSelected: false),
    ];

    const defaultColorValues = ColorWheelValues(
      lift: Offset(-0.25, 0.15), // 약간 청록색(Teal) 그림자
      gamma: Offset(0.05, -0.05),
      gain: Offset(0.28, -0.18), // 따뜻한 오렌지(Orange) 하이라이트
      temp: 12.0,
      tint: -4.0,
      contrast: 1.15,
      saturation: 58.0,
    );

    final defaultTracks = [
      const TimelineTrack(
        name: 'V3 (Subtitles)',
        isVideo: true,
        clips: [
          TimelineClip(title: '[자막] "지금 바로 시작합니다"', start: 0.1, duration: 0.35, color: Color(0xFFE91E63)),
          TimelineClip(title: '[자막] 픽션스크린 2026', start: 0.5, duration: 0.4, color: Color(0xFFE91E63)),
        ],
      ),
      const TimelineTrack(
        name: 'V2 (B-Roll)',
        isVideo: true,
        clips: [
          TimelineClip(title: 'Cyberpunk_Neon_4K.mov', start: 0.2, duration: 0.3, color: Color(0xFF00BCD4)),
          TimelineClip(title: 'Seoul_Night_Drive.mov', start: 0.55, duration: 0.35, color: Color(0xFF00BCD4)),
        ],
      ),
      const TimelineTrack(
        name: 'V1 (Main Cam A)',
        isVideo: true,
        clips: [
          TimelineClip(title: 'A001_C001_RAW_6K.braw', start: 0.0, duration: 0.45, color: Color(0xFF3F51B5)),
          TimelineClip(title: 'A001_C002_RAW_6K.braw', start: 0.45, duration: 0.55, color: Color(0xFF3F51B5)),
        ],
      ),
      const TimelineTrack(
        name: 'A1 (BGM Stereo)',
        isVideo: false,
        clips: [
          TimelineClip(title: 'Synthwave_Epic_Trailer_Master.wav', start: 0.0, duration: 0.95, color: Color(0xFF4CAF50)),
        ],
      ),
      const TimelineTrack(
        name: 'A2 (Voice & SFX)',
        isVideo: false,
        clips: [
          TimelineClip(title: 'Voiceover_Korean.wav', start: 0.05, duration: 0.4, color: Color(0xFF8BC34A)),
          TimelineClip(title: 'Whoosh_Transition.wav', start: 0.44, duration: 0.1, color: Color(0xFFFF9800)),
        ],
      ),
    ];

    return DavinciConfig(
      projectName: 'FictionScreen_Cinematic_TealOrange',
      timelineName: 'Timeline 1 (Main Edit 4K)',
      activeTimecode: '01:00:14:22',
      resolution: '3840 x 2160 Ultra HD 24.00fps',
      activePage: DavinciPage.color,
      nodes: defaultNodes,
      colorValues: defaultColorValues,
      tracks: defaultTracks,
      isPlaying: false,
      activeLutPreset: 'Teal & Orange (헐리우드 블록버스터)',
      renderStatus: '대기 중 (H.265 Master 4K)',
    );
  }
}
