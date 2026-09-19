import 'package:flutter/material.dart';

enum CctvGridMode {
  split4(4, '4분할 (2x2)'),
  split9(9, '9분할 (3x3)'),
  single(1, '1채널 (단독 확대)');

  final int channelCount;
  final String label;
  const CctvGridMode(this.channelCount, this.label);
}

enum CctvFilterMode {
  normal('일반 컬러'),
  nightVisionGreen('적외선 야간 투시 (그린)'),
  nightVisionMono('적외선 흑백 (B&W)'),
  highContrast('고대비 흑백');

  final String label;
  const CctvFilterMode(this.label);
}

class CctvChannel {
  final int id; // 1 ~ 9
  final String code; // CAM 01
  final String location; // 1F 현관 로비
  final String sceneType; // lobby, parking, elevator, server, stairs, rooftop, hallway, dock, control
  final bool isRecording;
  final bool isSignalLost;
  final bool isMotionDetected;
  final String? motionTarget; // "TARGET: UNKNOWN"
  final Rect? motionRect; // 0.0 ~ 1.0 relative
  final CctvFilterMode filterMode;
  final String alertMessage;

  const CctvChannel({
    required this.id,
    required this.code,
    required this.location,
    required this.sceneType,
    this.isRecording = true,
    this.isSignalLost = false,
    this.isMotionDetected = false,
    this.motionTarget = 'TARGET ACQUIRED: UNKNOWN',
    this.motionRect,
    this.filterMode = CctvFilterMode.nightVisionMono,
    this.alertMessage = 'MOTION DETECTED',
  });

  CctvChannel copyWith({
    int? id,
    String? code,
    String? location,
    String? sceneType,
    bool? isRecording,
    bool? isSignalLost,
    bool? isMotionDetected,
    String? motionTarget,
    Rect? motionRect,
    CctvFilterMode? filterMode,
    String? alertMessage,
  }) {
    return CctvChannel(
      id: id ?? this.id,
      code: code ?? this.code,
      location: location ?? this.location,
      sceneType: sceneType ?? this.sceneType,
      isRecording: isRecording ?? this.isRecording,
      isSignalLost: isSignalLost ?? this.isSignalLost,
      isMotionDetected: isMotionDetected ?? this.isMotionDetected,
      motionTarget: motionTarget ?? this.motionTarget,
      motionRect: motionRect ?? this.motionRect,
      filterMode: filterMode ?? this.filterMode,
      alertMessage: alertMessage ?? this.alertMessage,
    );
  }
}

class CctvConfig {
  final String systemTitle;
  final CctvGridMode gridMode;
  final int selectedChannelId; // 1 ~ 9 (for single focus)
  final DateTime baseDateTime;
  final bool isPlaying;
  final double playbackSpeed; // 1.0, 2.0, 4.0, 8.0
  final bool showScanlines;
  final bool showNoise;
  final bool showRecBlink;
  final List<CctvChannel> channels;

  const CctvConfig({
    required this.systemTitle,
    required this.gridMode,
    required this.selectedChannelId,
    required this.baseDateTime,
    required this.isPlaying,
    required this.playbackSpeed,
    required this.showScanlines,
    required this.showNoise,
    required this.showRecBlink,
    required this.channels,
  });

  static CctvConfig defaultPreset() {
    return CctvConfig(
      systemTitle: 'SECURE-NET NVR 9000 INTELLIGENT SURVEILLANCE',
      gridMode: CctvGridMode.split4,
      selectedChannelId: 1,
      baseDateTime: DateTime(2026, 9, 19, 23, 47, 12),
      isPlaying: true,
      playbackSpeed: 1.0,
      showScanlines: true,
      showNoise: true,
      showRecBlink: true,
      channels: [
        const CctvChannel(
          id: 1,
          code: 'CAM 01',
          location: '1F 중앙 현관 로비',
          sceneType: 'lobby',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: true,
          motionTarget: 'TARGET: HOODED SUBJECT [94%]',
          motionRect: Rect.fromLTWH(0.42, 0.28, 0.22, 0.48),
          filterMode: CctvFilterMode.nightVisionMono,
          alertMessage: 'BREACH: PERIMETER INTRUSION',
        ),
        const CctvChannel(
          id: 2,
          code: 'CAM 02',
          location: '지하 주차장 B2 구역',
          sceneType: 'parking',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.nightVisionGreen,
        ),
        const CctvChannel(
          id: 3,
          code: 'CAM 03',
          location: '엘리베이터 #2 호기',
          sceneType: 'elevator',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.normal,
        ),
        const CctvChannel(
          id: 4,
          code: 'CAM 04',
          location: 'B1 비밀 서버실 / 금고',
          sceneType: 'server',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: true,
          motionTarget: 'TARGET: UNIDENTIFIED MOTION',
          motionRect: Rect.fromLTWH(0.58, 0.35, 0.24, 0.36),
          filterMode: CctvFilterMode.nightVisionMono,
          alertMessage: 'ALARM: VAULT AREA MOTION',
        ),
        const CctvChannel(
          id: 5,
          code: 'CAM 05',
          location: '외곽 비상계단 3층',
          sceneType: 'stairs',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.nightVisionMono,
        ),
        const CctvChannel(
          id: 6,
          code: 'CAM 06',
          location: '옥상 비상 출입문',
          sceneType: 'rooftop',
          isRecording: false,
          isSignalLost: true, // 신호 두절 연출!
          filterMode: CctvFilterMode.highContrast,
          alertMessage: 'ERROR: VIDEO CARRIER LOST',
        ),
        const CctvChannel(
          id: 7,
          code: 'CAM 07',
          location: 'VIP 집무실 복도',
          sceneType: 'hallway',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.normal,
        ),
        const CctvChannel(
          id: 8,
          code: 'CAM 08',
          location: '후문 하역장 / 물류 컨테이너',
          sceneType: 'dock',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.nightVisionGreen,
        ),
        const CctvChannel(
          id: 9,
          code: 'CAM 09',
          location: '보안 통제실 관제 데스크',
          sceneType: 'control',
          isRecording: true,
          isSignalLost: false,
          isMotionDetected: false,
          filterMode: CctvFilterMode.normal,
        ),
      ],
    );
  }

  CctvConfig copyWith({
    String? systemTitle,
    CctvGridMode? gridMode,
    int? selectedChannelId,
    DateTime? baseDateTime,
    bool? isPlaying,
    double? playbackSpeed,
    bool? showScanlines,
    bool? showNoise,
    bool? showRecBlink,
    List<CctvChannel>? channels,
  }) {
    return CctvConfig(
      systemTitle: systemTitle ?? this.systemTitle,
      gridMode: gridMode ?? this.gridMode,
      selectedChannelId: selectedChannelId ?? this.selectedChannelId,
      baseDateTime: baseDateTime ?? this.baseDateTime,
      isPlaying: isPlaying ?? this.isPlaying,
      playbackSpeed: playbackSpeed ?? this.playbackSpeed,
      showScanlines: showScanlines ?? this.showScanlines,
      showNoise: showNoise ?? this.showNoise,
      showRecBlink: showRecBlink ?? this.showRecBlink,
      channels: channels ?? this.channels,
    );
  }
}
