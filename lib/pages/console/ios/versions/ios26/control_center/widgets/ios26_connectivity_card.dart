import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/ios26_liquid_glass.dart';

/// iOS 26 리퀴드 글래스 연결성 (Connectivity) 2x2 카드
class Ios26ConnectivityCard extends StatefulWidget {
  const Ios26ConnectivityCard({super.key});

  @override
  State<Ios26ConnectivityCard> createState() => _Ios26ConnectivityCardState();
}

class _Ios26ConnectivityCardState extends State<Ios26ConnectivityCard> {
  bool _isAirplaneOn = false;
  bool _isAirDropOn = true;
  bool _isWifiOn = true;
  bool _isCellularOn = true;
  bool _isBluetoothOn = true;

  @override
  Widget build(BuildContext context) {
    return Ios26LiquidGlass(
      height: 154,
      borderRadius: 28,
      blurSigma: 36,
      padding: const EdgeInsets.all(12),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 1. 비행기 모드
          _buildToggleCircle(
            icon: CupertinoIcons.airplane,
            isActive: _isAirplaneOn,
            activeColor: const Color(0xFFFF9500),
            onTap: () => setState(() => _isAirplaneOn = !_isAirplaneOn),
          ),
          // 2. AirDrop
          _buildToggleCircle(
            icon: CupertinoIcons.radiowaves_right,
            isActive: _isAirDropOn,
            activeColor: const Color(0xFF007AFF),
            onTap: () => setState(() => _isAirDropOn = !_isAirDropOn),
          ),
          // 3. Wi-Fi
          _buildToggleCircle(
            icon: CupertinoIcons.wifi,
            isActive: _isWifiOn,
            activeColor: const Color(0xFF007AFF),
            onTap: () => setState(() => _isWifiOn = !_isWifiOn),
          ),
          // 4. 셀룰러 / 블루투스 / 핫스팟 / VPN 4단 미니 클러스터
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildMiniCircle(
                  icon: CupertinoIcons.antenna_radiowaves_left_right,
                  isActive: _isCellularOn,
                  activeColor: const Color(0xFF34C759),
                  onTap: () => setState(() => _isCellularOn = !_isCellularOn),
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.bluetooth,
                  isActive: _isBluetoothOn,
                  activeColor: const Color(0xFF007AFF),
                  onTap: () => setState(() => _isBluetoothOn = !_isBluetoothOn),
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.link,
                  isActive: false,
                  activeColor: const Color(0xFF34C759),
                  onTap: () {},
                ),
                _buildMiniCircle(
                  icon: CupertinoIcons.globe,
                  isActive: true,
                  activeColor: const Color(0xFF007AFF),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleCircle({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.16),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.4),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniCircle({
    required IconData icon,
    required bool isActive,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? activeColor : Colors.white.withValues(alpha: 0.15),
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 12),
        ),
      ),
    );
  }
}
