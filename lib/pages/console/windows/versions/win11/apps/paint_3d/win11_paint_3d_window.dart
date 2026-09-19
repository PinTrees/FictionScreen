import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../widgets/win11_window_frame.dart';

enum Paint3DTab { brushes, shapes2d, shapes3d, stickers, text, effects, canvas, library3d }
enum Paint3DMaterial { matte, gloss, dullMetal, polishedMetal }
enum Shape3DType { cube, sphere, cylinder, torus, star, capsule }

class Placed3DObject {
  final String id;
  final Shape3DType type;
  Offset position;
  double size;
  double rotX;
  double rotY;
  double rotZ;
  Color color;
  Paint3DMaterial material;

  Placed3DObject({
    required this.id,
    required this.type,
    required this.position,
    this.size = 90.0,
    this.rotX = 0.2,
    this.rotY = 0.4,
    this.rotZ = 0.0,
    required this.color,
    this.material = Paint3DMaterial.gloss,
  });
}

class Paint3DStroke {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  Paint3DStroke({required this.points, required this.color, required this.strokeWidth});
}

/// Windows 11 순정 그림판 3D (Paint 3D) 창
class Win11Paint3DWindow extends StatefulWidget {
  final VoidCallback onClose;
  final VoidCallback? onMinimize;
  final VoidCallback? onMaximize;
  final Function(int layoutType, int zoneIndex)? onSnapLayout;
  final Function(DragStartDetails)? onTitleDragStart;
  final Function(DragUpdateDetails)? onTitleDragUpdate;
  final double width;
  final double height;
  final bool isMaximized;

  const Win11Paint3DWindow({
    super.key,
    required this.onClose,
    this.onMinimize,
    this.onMaximize,
    this.onSnapLayout,
    this.onTitleDragStart,
    this.onTitleDragUpdate,
    this.width = 960,
    this.height = 620,
    this.isMaximized = false,
  });

  @override
  State<Win11Paint3DWindow> createState() => _Win11Paint3DWindowState();
}

class _Win11Paint3DWindowState extends State<Win11Paint3DWindow> {
  Paint3DTab _activeTab = Paint3DTab.shapes3d;
  bool _is3DViewMode = false;
  double _viewOrbitX = 0.15;
  double _viewOrbitY = -0.25;
  double _zoomLevel = 1.0;

  // 현재 브러시/오브젝트 속성
  Color _selectedColor = const Color(0xFF0078D7);
  double _thickness = 8.0;
  Paint3DMaterial _selectedMaterial = Paint3DMaterial.gloss;
  int _selectedBrushIndex = 0; // 0: 마커, 1: 캘리그래피, 2: 유화, 3: 수채화, 4: 크레용, 5: 스프레이, 6: 페인트통

  // 3D 오브젝트 컬렉션
  final List<Placed3DObject> _placedObjects = [
    Placed3DObject(
      id: 'default_cube',
      type: Shape3DType.cube,
      position: const Offset(200, 160),
      size: 95,
      rotX: 0.35,
      rotY: 0.55,
      color: const Color(0xFF0078D7),
      material: Paint3DMaterial.gloss,
    ),
    Placed3DObject(
      id: 'default_sphere',
      type: Shape3DType.sphere,
      position: const Offset(360, 200),
      size: 85,
      rotX: 0.1,
      rotY: 0.2,
      color: const Color(0xFFE91E63),
      material: Paint3DMaterial.polishedMetal,
    ),
    Placed3DObject(
      id: 'default_torus',
      type: Shape3DType.torus,
      position: const Offset(280, 280),
      size: 100,
      rotX: 0.6,
      rotY: 0.1,
      color: const Color(0xFFFFC107),
      material: Paint3DMaterial.matte,
    ),
  ];

  String? _selectedObjectId = 'default_cube';

  // 2D 브러시 드로잉 스트로크
  final List<Paint3DStroke> _strokes = [];
  final List<Paint3DStroke> _undoneStrokes = [];

  // 18색 Windows Paint 3D 표준 팔레트
  final List<Color> _palette = const [
    Color(0xFF000000), Color(0xFF7F7F7F), Color(0xFF880015), Color(0xFFED1C24), Color(0xFFFF7F27), Color(0xFFFFF200),
    Color(0xFF22B14C), Color(0xFF00A2E8), Color(0xFF3F48CC), Color(0xFFA349A4), Color(0xFFFFFFFF), Color(0xFFC3C3C3),
    Color(0xFFB97A57), Color(0xFFFFAEC9), Color(0xFFFFC90E), Color(0xFFEFE4B0), Color(0xFFB5E61D), Color(0xFF99D9EA),
  ];

  void _add3DShape(Shape3DType type) {
    final newObj = Placed3DObject(
      id: 'obj_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      position: Offset(220 + (_placedObjects.length * 15.0), 180 + (_placedObjects.length * 15.0)),
      color: _selectedColor,
      material: _selectedMaterial,
      size: 90,
      rotX: 0.3,
      rotY: 0.4,
    );
    setState(() {
      _placedObjects.add(newObj);
      _selectedObjectId = newObj.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Win11WindowFrame(
      title: '그림판 3D',
      iconAsset: 'assets/images/windows/paint.png',
      width: widget.width,
      height: widget.height,
      isMaximized: widget.isMaximized,
      onClose: widget.onClose,
      onMinimize: widget.onMinimize,
      onMaximize: widget.onMaximize,
      onSnapLayout: widget.onSnapLayout,
      onTitleDragStart: widget.onTitleDragStart,
      onTitleDragUpdate: widget.onTitleDragUpdate,
      child: Container(
        color: const Color(0xFF1F1F1F),
        child: Column(
          children: [
            // 상단 Paint 3D 리본 탭 바
            _buildRibbonTabBar(),
            const Divider(height: 1, color: Color(0xFF2E2E2E)),

            // 작업 영역: 좌측 3D 뷰포트 + 우측 도구 패널
            Expanded(
              child: Row(
                children: [
                  // 중앙 3D 캔버스 & 뷰포트
                  Expanded(
                    child: _build3DViewportArea(),
                  ),

                  // 우측 도구 및 속성 사이드바 패널
                  Container(
                    width: 250,
                    decoration: const BoxDecoration(
                      color: Color(0xFF262626),
                      border: Border(left: BorderSide(color: Color(0xFF333333))),
                    ),
                    child: _buildRightPropertiesPanel(),
                  ),
                ],
              ),
            ),

            // 하단 줌 & 보기 상태바
            _buildBottomStatusBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRibbonTabBar() {
    final tabs = [
      {'tab': Paint3DTab.brushes, 'label': '브러시', 'icon': CupertinoIcons.paintbrush},
      {'tab': Paint3DTab.shapes2d, 'label': '2D 모양', 'icon': CupertinoIcons.circle},
      {'tab': Paint3DTab.shapes3d, 'label': '3D 모양', 'icon': CupertinoIcons.cube_box_fill},
      {'tab': Paint3DTab.stickers, 'label': '스티커', 'icon': CupertinoIcons.sparkles},
      {'tab': Paint3DTab.text, 'label': '텍스트', 'icon': CupertinoIcons.textformat},
      {'tab': Paint3DTab.effects, 'label': '효과', 'icon': CupertinoIcons.sun_max},
      {'tab': Paint3DTab.canvas, 'label': '캔버스', 'icon': CupertinoIcons.square_on_square},
      {'tab': Paint3DTab.library3d, 'label': '3D 라이브러리', 'icon': CupertinoIcons.folder},
    ];

    return Container(
      height: 52,
      color: const Color(0xFF2B2B2B),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          // 메뉴 버튼
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: const Row(
                children: [
                  Icon(CupertinoIcons.bars, size: 16, color: Colors.white70),
                  SizedBox(width: 6),
                  Text('메뉴', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 24, color: Colors.white24),
          const SizedBox(width: 8),

          // 리본 탭 목록
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((t) {
                  final tabEnum = t['tab'] as Paint3DTab;
                  final isCur = _activeTab == tabEnum;
                  return InkWell(
                    onTap: () => setState(() => _activeTab = tabEnum),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: isCur ? const Color(0xFF383838) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: isCur ? Border.all(color: const Color(0xFF0078D7)) : null,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(t['icon'] as IconData, size: 16, color: isCur ? const Color(0xFF60CDFF) : Colors.white70),
                          const SizedBox(height: 2),
                          Text(
                            t['label'] as String,
                            style: TextStyle(
                              color: isCur ? Colors.white : Colors.white60,
                              fontSize: 10.5,
                              fontWeight: isCur ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // 3D 보기 토글 버튼
          InkWell(
            onTap: () => setState(() => _is3DViewMode = !_is3DViewMode),
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _is3DViewMode ? const Color(0xFF0078D7) : const Color(0xFF383838),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Icon(CupertinoIcons.cube_box, size: 14, color: _is3DViewMode ? Colors.white : Colors.white70),
                  const SizedBox(width: 6),
                  Text(
                    '3D 보기',
                    style: TextStyle(
                      color: _is3DViewMode ? Colors.white : Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _build3DViewportArea() {
    return Container(
      color: const Color(0xFF141414),
      child: Stack(
        children: [
          // 3D Perspective Canvas or 2D Plane
          Positioned.fill(
            child: GestureDetector(
              onPanUpdate: (details) {
                if (_is3DViewMode) {
                  setState(() {
                    _viewOrbitY += details.delta.dx * 0.006;
                    _viewOrbitX = (_viewOrbitX - details.delta.dy * 0.006).clamp(-0.8, 0.8);
                  });
                }
              },
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateX(_is3DViewMode ? _viewOrbitX : 0)
                    ..rotateY(_is3DViewMode ? _viewOrbitY : 0)
                    ..scaleByDouble(_zoomLevel, _zoomLevel, 1.0, 1.0),
                  child: Container(
                    width: 580,
                    height: 420,
                    decoration: BoxDecoration(
                      color: const Color(0xFF242424),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: _is3DViewMode ? const Color(0xFF0078D7) : const Color(0xFF3E3E42)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.6),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // 3D 뷰포트 배경 그리드
                        if (_is3DViewMode)
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _Grid3DPainter(),
                            ),
                          ),

                        // 2D 브러시 스트로크 드로잉 레이어
                        Positioned.fill(
                          child: GestureDetector(
                            onPanStart: (details) {
                              if (_is3DViewMode) return;
                              setState(() {
                                _strokes.add(Paint3DStroke(
                                  points: [details.localPosition],
                                  color: _selectedColor,
                                  strokeWidth: _thickness,
                                ));
                                _undoneStrokes.clear();
                              });
                            },
                            onPanUpdate: (details) {
                              if (_is3DViewMode || _strokes.isEmpty) return;
                              setState(() {
                                _strokes.last.points.add(details.localPosition);
                              });
                            },
                            child: CustomPaint(
                              painter: _Paint2DStrokePainter(strokes: _strokes),
                            ),
                          ),
                        ),

                        // 배치된 3D 오브젝트들
                        ..._placedObjects.map((obj) => _build3DObjectWidget(obj)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3D 회전 제어 오버레이 안내 팁
          if (_is3DViewMode)
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF0078D7)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.rotate_right, size: 12, color: Color(0xFF60CDFF)),
                    SizedBox(width: 6),
                    Text('마우스 드래그로 3D 공간을 자유롭게 회전하세요', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _build3DObjectWidget(Placed3DObject obj) {
    final isSelected = _selectedObjectId == obj.id;

    return Positioned(
      left: obj.position.dx,
      top: obj.position.dy,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedObjectId = obj.id;
            _selectedColor = obj.color;
            _selectedMaterial = obj.material;
          });
        },
        onPanUpdate: (details) {
          setState(() {
            obj.position += details.delta;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            border: isSelected ? Border.all(color: const Color(0xFF0078D7), width: 1.5) : null,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // 3D 셰이프 렌더링
              CustomPaint(
                size: Size(obj.size, obj.size),
                painter: _Shape3DPainter(
                  type: obj.type,
                  color: obj.color,
                  material: obj.material,
                  rotX: obj.rotX,
                  rotY: obj.rotY,
                  rotZ: obj.rotZ,
                ),
              ),

              // 선택 핸들 (3D 회전 제어 앵커)
              if (isSelected) ...[
                Positioned(
                  top: -18,
                  right: -18,
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        obj.rotY += details.delta.dx * 0.02;
                        obj.rotX += details.delta.dy * 0.02;
                      });
                    },
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0078D7),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black45, blurRadius: 4)],
                      ),
                      child: const Icon(CupertinoIcons.rotate_right, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPropertiesPanel() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 탭별 주요 컨트롤
          if (_activeTab == Paint3DTab.shapes3d) ...[
            const Text('3D 모델 삽입', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: [
                _buildShapeBtn('정육면체', CupertinoIcons.cube_box, () => _add3DShape(Shape3DType.cube)),
                _buildShapeBtn('구', CupertinoIcons.circle_fill, () => _add3DShape(Shape3DType.sphere)),
                _buildShapeBtn('도넛', CupertinoIcons.circle, () => _add3DShape(Shape3DType.torus)),
                _buildShapeBtn('원통', CupertinoIcons.archivebox, () => _add3DShape(Shape3DType.cylinder)),
                _buildShapeBtn('캡슐', CupertinoIcons.capsule, () => _add3DShape(Shape3DType.capsule)),
                _buildShapeBtn('3D 별', CupertinoIcons.star_fill, () => _add3DShape(Shape3DType.star)),
              ],
            ),
            const SizedBox(height: 20),
          ] else if (_activeTab == Paint3DTab.brushes) ...[
            const Text('브러시 종류', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                '마커', '캘리그래피', '유화', '수채화', '크레용', '스프레이', '페인트통'
              ].asMap().entries.map((e) {
                final isSel = _selectedBrushIndex == e.key;
                return ChoiceChip(
                  label: Text(e.value, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : Colors.white70)),
                  selected: isSel,
                  selectedColor: const Color(0xFF0078D7),
                  backgroundColor: const Color(0xFF333333),
                  onSelected: (val) => setState(() => _selectedBrushIndex = e.key),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // 재질 선택 (Material)
          const Text('재질 (Material)', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF333333),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF444444)),
            ),
            child: DropdownButton<Paint3DMaterial>(
              value: _selectedMaterial,
              isExpanded: true,
              dropdownColor: const Color(0xFF2C2C2C),
              underline: const SizedBox.shrink(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
              items: const [
                DropdownMenuItem(value: Paint3DMaterial.matte, child: Text('무광택 (Matte)')),
                DropdownMenuItem(value: Paint3DMaterial.gloss, child: Text('광택 (Gloss)')),
                DropdownMenuItem(value: Paint3DMaterial.dullMetal, child: Text('무광 금속 (Dull Metal)')),
                DropdownMenuItem(value: Paint3DMaterial.polishedMetal, child: Text('광택 금속 (Polished Metal)')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _selectedMaterial = val;
                    if (_selectedObjectId != null) {
                      _placedObjects.firstWhere((o) => o.id == _selectedObjectId).material = val;
                    }
                  });
                }
              },
            ),
          ),
          const SizedBox(height: 18),

          // 두께 / 크기 슬라이더
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('두께 / 크기', style: TextStyle(color: Colors.white, fontSize: 12)),
              Text('${_thickness.toInt()}px', style: const TextStyle(color: Color(0xFF60CDFF), fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _thickness,
            min: 2,
            max: 50,
            activeColor: const Color(0xFF0078D7),
            inactiveColor: Colors.white24,
            onChanged: (val) {
              setState(() {
                _thickness = val;
                if (_selectedObjectId != null) {
                  _placedObjects.firstWhere((o) => o.id == _selectedObjectId).size = val * 5.0 + 40;
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // 컬러 팔레트
          const Text('색상 팔레트', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: _palette.length,
            itemBuilder: (context, index) {
              final color = _palette[index];
              final isCur = _selectedColor == color;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedColor = color;
                    if (_selectedObjectId != null) {
                      _placedObjects.firstWhere((o) => o.id == _selectedObjectId).color = color;
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCur ? const Color(0xFF60CDFF) : Colors.white24,
                      width: isCur ? 2.5 : 1,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 선택된 오브젝트 삭제 버튼
          if (_selectedObjectId != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(CupertinoIcons.trash, size: 14, color: Colors.white),
                label: const Text('선택한 3D 모델 삭제', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                onPressed: () {
                  setState(() {
                    _placedObjects.removeWhere((o) => o.id == _selectedObjectId);
                    _selectedObjectId = null;
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShapeBtn(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF333333),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF444444)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: const Color(0xFF60CDFF)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomStatusBar() {
    return Container(
      height: 28,
      color: const Color(0xFF222222),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Text('100% 캔버스', style: TextStyle(color: Colors.white54, fontSize: 11)),
          const SizedBox(width: 14),
          Text('오브젝트: ${_placedObjects.length}개', style: const TextStyle(color: Colors.white38, fontSize: 11)),
          const Spacer(),

          // 줌 컨트롤
          IconButton(
            icon: const Icon(CupertinoIcons.minus, size: 12, color: Colors.white60),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => setState(() => _zoomLevel = (_zoomLevel - 0.1).clamp(0.5, 2.0)),
          ),
          const SizedBox(width: 8),
          Text('${(_zoomLevel * 100).toInt()}%', style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(CupertinoIcons.plus, size: 12, color: Colors.white60),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => setState(() => _zoomLevel = (_zoomLevel + 0.1).clamp(0.5, 2.0)),
          ),
        ],
      ),
    );
  }
}

/// 3D 원근 셰이프 커스텀 페인터
class _Shape3DPainter extends CustomPainter {
  final Shape3DType type;
  final Color color;
  final Paint3DMaterial material;
  final double rotX;
  final double rotY;
  final double rotZ;

  _Shape3DPainter({
    required this.type,
    required this.color,
    required this.material,
    required this.rotX,
    required this.rotY,
    required this.rotZ,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;

    switch (type) {
      case Shape3DType.sphere:
        // 3D 입체 구 렌더링
        final shadowPaint = Paint()
          ..color = Colors.black45
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
        canvas.drawOval(Rect.fromCenter(center: Offset(cx + 8, cy + r * 0.8), width: r * 1.6, height: r * 0.6), shadowPaint);

        final spherePaint = Paint()
          ..shader = RadialGradient(
            center: const Alignment(-0.35, -0.4),
            radius: 0.85,
            colors: [
              Colors.white.withValues(alpha: material == Paint3DMaterial.polishedMetal ? 0.9 : 0.6),
              color,
              Color.lerp(color, Colors.black, 0.65)!,
            ],
            stops: const [0.0, 0.45, 1.0],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
        canvas.drawCircle(Offset(cx, cy), r, spherePaint);
        break;

      case Shape3DType.cube:
        // 3D 입체 큐브 렌더링
        final side = r * 1.3;
        final dx = math.cos(rotY) * (side * 0.4);
        final dy = math.sin(rotX) * (side * 0.35);

        // 앞면
        final frontPath = Path()
          ..moveTo(cx - side / 2, cy - side / 2)
          ..lineTo(cx + side / 2, cy - side / 2)
          ..lineTo(cx + side / 2, cy + side / 2)
          ..lineTo(cx - side / 2, cy + side / 2)
          ..close();
        canvas.drawPath(frontPath, Paint()..color = color);

        // 윗면
        final topPath = Path()
          ..moveTo(cx - side / 2, cy - side / 2)
          ..lineTo(cx - side / 2 + dx, cy - side / 2 - dy)
          ..lineTo(cx + side / 2 + dx, cy - side / 2 - dy)
          ..lineTo(cx + side / 2, cy - side / 2)
          ..close();
        canvas.drawPath(topPath, Paint()..color = Color.lerp(color, Colors.white, 0.35)!);

        // 오른쪽 면
        final rightPath = Path()
          ..moveTo(cx + side / 2, cy - side / 2)
          ..lineTo(cx + side / 2 + dx, cy - side / 2 - dy)
          ..lineTo(cx + side / 2 + dx, cy + side / 2 - dy)
          ..lineTo(cx + side / 2, cy + side / 2)
          ..close();
        canvas.drawPath(rightPath, Paint()..color = Color.lerp(color, Colors.black, 0.35)!);
        break;

      case Shape3DType.torus:
        // 3D 도넛 렌더링
        final torusPaint = Paint()
          ..shader = SweepGradient(
            colors: [
              Color.lerp(color, Colors.white, 0.4)!,
              color,
              Color.lerp(color, Colors.black, 0.5)!,
              color,
              Color.lerp(color, Colors.white, 0.4)!,
            ],
          ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.45;
        canvas.drawCircle(Offset(cx, cy), r * 0.7, torusPaint);
        break;

      default:
        // 일반 3D 폴리곤 형태
        final paint = Paint()
          ..color = color
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(cx, cy), r, paint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _Shape3DPainter oldDelegate) => true;
}

/// 3D 뷰포트 바닥 그리드 페인터
class _Grid3DPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..strokeWidth = 1.0;

    const step = 30.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2D 캔버스 드로잉 스트로크 페인터
class _Paint2DStrokePainter extends CustomPainter {
  final List<Paint3DStroke> strokes;

  _Paint2DStrokePainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in strokes) {
      if (s.points.length < 2) continue;

      final paint = Paint()
        ..color = s.color
        ..strokeWidth = s.strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(s.points.first.dx, s.points.first.dy);
      for (int i = 1; i < s.points.length; i++) {
        path.lineTo(s.points[i].dx, s.points[i].dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _Paint2DStrokePainter oldDelegate) => true;
}
