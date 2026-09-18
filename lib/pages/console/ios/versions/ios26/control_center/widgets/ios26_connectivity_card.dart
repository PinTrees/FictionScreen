import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';
import 'ios26_cc_icons.dart';

/// Apple iOS 26 리퀴드 글래스 연결성 (Connectivity) 2x2 카드
class Ios26ConnectivityCard extends StatefulWidget {
  final double cardSize;
  const Ios26ConnectivityCard({super.key, required this.cardSize});

  @override
  State<Ios26ConnectivityCard> createState() => _Ios26ConnectivityCardState();
}

class _Ios26ConnectivityCardState extends State<Ios26ConnectivityCard> {
  bool _isAirplaneOn = false;
  bool _isAirDropOn = true;
  bool _isWifiOn = false; // 레퍼런스: 와이파이 비활성 (슬래시 표시)
  bool _isCellularOn = true;
  bool _isBluetoothOn = true;

  @override
  Widget build(BuildContext context) {
    final size = widget.cardSize;
    final pad = size * (14.0 / 180.0);
    final innerGap = size * (10.0 / 180.0);
    final btnSize = (size - 2 * pad - innerGap) / 2.0;
    final miniBtnSize = (btnSize - 7.0) / 2.0;

    return Ios26LiquidGlass(
      width: size,
      height: size,
      borderRadius: size * 0.20,
      blurSigma: 36,
      tintColor: const Color(0xFF0F2644),
      padding: EdgeInsets.all(pad),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row 1: 비행기 모드 + AirDrop
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBigCircle(
                size: btnSize,
                child: Ios26AirplaneIcon(size: btnSize * 0.44),
                isActive: _isAirplaneOn,
                activeColor: const Color(0xFFFF9500),
                onTap: () => setState(() => _isAirplaneOn = !_isAirplaneOn),
              ),
              _buildBigCircle(
                size: btnSize,
                child: Ios26AirDropIcon(size: btnSize * 0.44),
                isActive: _isAirDropOn,
                activeColor: const Color(0xFF007AFF),
                onTap: () => setState(() => _isAirDropOn = !_isAirDropOn),
              ),
            ],
          ),

          // Row 2: Wi-Fi + 4단 미니 클러스터
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBigCircle(
                size: btnSize,
                child: Ios26WifiIcon(size: btnSize * 0.44, isSlashed: !_isWifiOn),
                isActive: _isWifiOn,
                activeColor: const Color(0xFF007AFF),
                onTap: () => setState(() => _isWifiOn = !_isWifiOn),
              ),
              _buildMiniCluster(size: btnSize, miniSize: miniBtnSize),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBigCircle({
    required double size,
    required Widget child,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.16),
          boxShadow: isActive ? [BoxShadow(color: activeColor.withValues(alpha: 0.45), blurRadius: 8, spreadRadius: 1)] : null,
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildMiniCluster({required double size, required double miniSize}) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.14), borderRadius: BorderRadius.circular(size * 0.32)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniIcon(size: miniSize, child: Ios26CellularIcon(size: miniSize * 0.56), isActive: _isCellularOn, activeColor: const Color(0xFF34C759), onTap: () => setState(() => _isCellularOn = !_isCellularOn)),
              _buildMiniIcon(size: miniSize, child: Ios26BluetoothIcon(size: miniSize * 0.56), isActive: _isBluetoothOn, activeColor: const Color(0xFF007AFF), onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniIcon(size: miniSize, child: Ios26HotspotIcon(size: miniSize * 0.56), isActive: false, activeColor: const Color(0xFF34C759), onTap: () {}),
              _buildMiniIcon(size: miniSize, child: Ios26GlobeIcon(size: miniSize * 0.56), isActive: true, activeColor: const Color(0xFF007AFF), onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIcon({required double size, required Widget child, required bool isActive, required Color activeColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeColor : Colors.white.withValues(alpha: 0.15)),
        child: Center(child: child),
      ),
    );
  }
}
