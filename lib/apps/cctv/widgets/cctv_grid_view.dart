import 'package:flutter/material.dart';
import '../data/cctv_model.dart';
import 'cctv_camera_feed.dart';

class CctvGridView extends StatelessWidget {
  final CctvConfig config;
  final DateTime currentDisplayTime;
  final ValueChanged<int> onSelectChannel;
  final ValueChanged<CctvGridMode> onGridModeChanged;

  const CctvGridView({
    super.key,
    required this.config,
    required this.currentDisplayTime,
    required this.onSelectChannel,
    required this.onGridModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    switch (config.gridMode) {
      case CctvGridMode.single:
        return _buildSingleView();
      case CctvGridMode.split4:
        return _buildSplit4View();
      case CctvGridMode.split9:
        return _buildSplit9View();
    }
  }

  // 1채널 단독 확대 뷰
  Widget _buildSingleView() {
    final channel = config.channels.firstWhere(
      (c) => c.id == config.selectedChannelId,
      orElse: () => config.channels.first,
    );

    return CctvCameraFeed(
      channel: channel,
      currentDisplayTime: currentDisplayTime,
      isSelected: true,
      showScanlines: config.showScanlines,
      showNoise: config.showNoise,
      showRecBlink: config.showRecBlink,
      onDoubleTap: () => onGridModeChanged(CctvGridMode.split4),
    );
  }

  // 4분할 (2x2)
  Widget _buildSplit4View() {
    final channels = config.channels.take(4).toList();

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildFeedItem(channels[0])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[1])),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildFeedItem(channels[2])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[3])),
            ],
          ),
        ),
      ],
    );
  }

  // 9분할 (3x3)
  Widget _buildSplit9View() {
    final channels = config.channels.take(9).toList();

    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildFeedItem(channels[0])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[1])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[2])),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildFeedItem(channels[3])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[4])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[5])),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _buildFeedItem(channels[6])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[7])),
              const SizedBox(width: 2),
              Expanded(child: _buildFeedItem(channels[8])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFeedItem(CctvChannel channel) {
    return CctvCameraFeed(
      channel: channel,
      currentDisplayTime: currentDisplayTime,
      isSelected: channel.id == config.selectedChannelId,
      showScanlines: config.showScanlines,
      showNoise: config.showNoise,
      showRecBlink: config.showRecBlink,
      onTap: () => onSelectChannel(channel.id),
      onDoubleTap: () {
        onSelectChannel(channel.id);
        onGridModeChanged(CctvGridMode.single);
      },
    );
  }
}
