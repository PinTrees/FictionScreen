import 'dart:async';
import 'package:flutter/material.dart';
import 'data/cctv_model.dart';
import 'widgets/cctv_control_panel.dart';
import 'widgets/cctv_edit_dialog.dart';
import 'widgets/cctv_grid_view.dart';

class CctvScreen extends StatefulWidget {
  final CctvConfig? config;
  final ValueChanged<CctvConfig>? onConfigChanged;

  const CctvScreen({
    super.key,
    this.config,
    this.onConfigChanged,
  });

  @override
  State<CctvScreen> createState() => _CctvScreenState();
}

class _CctvScreenState extends State<CctvScreen> {
  late CctvConfig _config;
  late DateTime _currentDisplayTime;
  Timer? _playbackTimer;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? CctvConfig.defaultPreset();
    _currentDisplayTime = _config.baseDateTime;
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant CctvScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null && widget.config != _config) {
      _config = widget.config!;
    }
  }

  void _startTimer() {
    _playbackTimer?.cancel();
    _playbackTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted) return;
      if (_config.isPlaying) {
        setState(() {
          final addedMs = (50 * _config.playbackSpeed).toInt();
          _currentDisplayTime = _currentDisplayTime.add(Duration(milliseconds: addedMs));
        });
      } else {
        // 일시정지 중에도 깜빡임 연출을 위해 리빌드
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _playbackTimer?.cancel();
    super.dispose();
  }

  void _updateConfig(CctvConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged?.call(_config);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (_) => CctvEditDialog(
        config: _config,
        onSave: (newConfig) {
          _updateConfig(newConfig);
          _currentDisplayTime = newConfig.baseDateTime;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          // 중앙 CCTV 그리드 피드 뷰
          Expanded(
            child: CctvGridView(
              config: _config,
              currentDisplayTime: _currentDisplayTime,
              onSelectChannel: (id) {
                _updateConfig(_config.copyWith(selectedChannelId: id));
              },
              onGridModeChanged: (mode) {
                _updateConfig(_config.copyWith(gridMode: mode));
              },
            ),
          ),

          // 하단 NVR 관제 컨트롤 패널
          CctvControlPanel(
            config: _config,
            onGridModeChanged: (mode) => _updateConfig(_config.copyWith(gridMode: mode)),
            onTogglePlay: () => _updateConfig(_config.copyWith(isPlaying: !_config.isPlaying)),
            onSpeedChanged: (spd) => _updateConfig(_config.copyWith(playbackSpeed: spd)),
            onToggleScanlines: () => _updateConfig(_config.copyWith(showScanlines: !_config.showScanlines)),
            onToggleNoise: () => _updateConfig(_config.copyWith(showNoise: !_config.showNoise)),
            onOpenEditDialog: _openEditDialog,
            onSelectChannel: (id) => _updateConfig(_config.copyWith(selectedChannelId: id)),
          ),
        ],
      ),
    );
  }
}
