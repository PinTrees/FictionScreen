import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// Apple iOS 26 공식 리퀴드 글래스 연결성 (Connectivity) 2x2 카드
class Ios26ConnectivityCard extends StatefulWidget {
  const Ios26ConnectivityCard({super.key});

  @override
  State<Ios26ConnectivityCard> createState() => _Ios26ConnectivityCardState();
}

class _Ios26ConnectivityCardState extends State<Ios26ConnectivityCard> {
  bool _isAirplaneOn = false;
  bool _isAirDropOn = true;
  bool _isWifiOn = false;
  bool _isCellularOn = true;
  bool _isBluetoothOn = true;

  @override
  Widget build(BuildContext context) {
    return Ios26LiquidGlass(
      height: 160,
      borderRadius: 28,
      blurSigma: 36,
      tintColor: const Color(0xFF0F2644),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row 1: 비행기 모드 + AirDrop
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBigCircle(
                icon: CupertinoIcons.airplane,
                isActive: _isAirplaneOn,
                activeColor: const Color(0xFFFF9500),
                onTap: () => setState(() => _isAirplaneOn = !_isAirplaneOn),
              ),
              _buildBigCircle(
                icon: CupertinoIcons.radiowaves_right,
                isActive: _isAirDropOn,
                activeColor: const Color(0xFF007AFF),
                onTap: () => setState(() => _isAirDropOn = !_isAirDropOn),
              ),
            ],
          ),

          // Row 2: Wi-Fi + 4단 미니 클러스터 (셀룰러, 블루투스, 핫스팟, VPN)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildBigCircle(
                icon: _isWifiOn ? CupertinoIcons.wifi : CupertinoIcons.wifi_slash,
                isActive: _isWifiOn,
                activeColor: const Color(0xFF007AFF),
                onTap: () => setState(() => _isWifiOn = !_isWifiOn),
              ),
              _buildMiniCluster(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBigCircle({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.16),
          boxShadow: isActive ? [BoxShadow(color: activeColor.withValues(alpha: 0.4), blurRadius: 8, spreadRadius: 1)] : null,
        ),
        child: Center(child: Icon(icon, color: Colors.white, size: 24)),
      ),
    );
  }

  Widget _buildMiniCluster() {
    return Container(
      width: 54,
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniIcon(
                icon: CupertinoIcons.antenna_radiowaves_left_right,
                isActive: _isCellularOn,
                activeColor: const Color(0xFF34C759),
                onTap: () => setState(() => _isCellularOn = !_isCellularOn),
              ),
              _buildMiniIcon(
                icon: CupertinoIcons.bluetooth,
                isActive: _isBluetoothOn,
                activeColor: const Color(0xFF007AFF),
                onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniIcon(icon: CupertinoIcons.link, isActive: false, activeColor: const Color(0xFF34C759), onTap: () {}),
              _buildMiniIcon(icon: CupertinoIcons.globe, isActive: true, activeColor: const Color(0xFF007AFF), onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniIcon({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 21,
        height: 21,
        decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? activeColor : Colors.white.withValues(alpha: 0.15)),
        child: Center(child: Icon(icon, color: Colors.white, size: 11.5)),
      ),
    );
  }
}
