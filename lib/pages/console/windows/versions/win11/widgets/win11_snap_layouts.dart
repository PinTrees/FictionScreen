import 'package:flutter/material.dart';

/// Windows 11 최대화 버튼 호버 시 나타나는 스냅 레이아웃(Snap Layouts) 팝업
class Win11SnapLayoutsPopup extends StatelessWidget {
  final Function(int layoutType, int zoneIndex) onSelectZone;

  const Win11SnapLayoutsPopup({
    super.key,
    required this.onSelectZone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF282A36).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // 1. 2분할 50:50
              Expanded(
                child: _buildLayoutOption(
                  zones: [
                    _buildZone(0, 0, '좌 1/2', flex: 1),
                    _buildZone(0, 1, '우 1/2', flex: 1),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 2. 2분할 비대칭 67:33
              Expanded(
                child: _buildLayoutOption(
                  zones: [
                    _buildZone(1, 0, '2/3', flex: 2),
                    _buildZone(1, 1, '1/3', flex: 1),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // 3. 3분할 (좌 50%, 우상 25%, 우하 25%)
              Expanded(
                child: _buildLayoutOption(
                  zones: [
                    _buildZone(2, 0, '1/2', flex: 1),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildZone(2, 1, '우상', flex: 1),
                          const SizedBox(height: 2),
                          _buildZone(2, 2, '우하', flex: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 4. 4분할 균등 그리드
              Expanded(
                child: _buildLayoutOption(
                  zones: [
                    Expanded(
                      child: Column(
                        children: [
                          _buildZone(3, 0, '좌상', flex: 1),
                          const SizedBox(height: 2),
                          _buildZone(3, 1, '좌하', flex: 1),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Column(
                        children: [
                          _buildZone(3, 2, '우상', flex: 1),
                          const SizedBox(height: 2),
                          _buildZone(3, 3, '우하', flex: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLayoutOption({required List<Widget> zones}) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: zones,
      ),
    );
  }

  Widget _buildZone(int layoutType, int zoneIndex, String label, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: _ZoneTile(
        onTap: () => onSelectZone(layoutType, zoneIndex),
      ),
    );
  }
}

class _ZoneTile extends StatefulWidget {
  final VoidCallback onTap;

  const _ZoneTile({required this.onTap});

  @override
  State<_ZoneTile> createState() => _ZoneTileState();
}

class _ZoneTileState extends State<_ZoneTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          margin: const EdgeInsets.all(1.5),
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFF0067C0) : Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(3),
            border: Border.all(
              color: _isHovered ? const Color(0xFF60A5FA) : Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
