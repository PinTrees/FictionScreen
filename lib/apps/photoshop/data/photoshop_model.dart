import 'package:flutter/material.dart';

enum PhotoshopTool {
  move('이동 도구', 'V', Icons.open_with),
  marquee('선택 윤곽 도구', 'M', Icons.crop_free),
  lasso('올가미 도구', 'L', Icons.gesture),
  crop('자르기 도구', 'C', Icons.crop),
  eyedropper('스포이트 도구', 'I', Icons.colorize),
  brush('브러시 도구', 'B', Icons.brush),
  cloneStamp('복제 도장 도구', 'S', Icons.control_point_duplicate),
  eraser('지우개 도구', 'E', Icons.auto_fix_normal),
  paintBucket('페인트통 도구', 'G', Icons.format_color_fill),
  pen('펜 도구', 'P', Icons.create),
  type('수평 문자 도구', 'T', Icons.title),
  shape('직사각형 도구', 'U', Icons.crop_square),
  hand('손 도구', 'H', Icons.pan_tool),
  zoom('돋보기 도구', 'Z', Icons.search);

  final String label;
  final String shortcut;
  final IconData icon;
  const PhotoshopTool(this.label, this.shortcut, this.icon);
}

class PhotoshopLayer {
  final String id;
  final String name;
  final bool isVisible;
  final bool isLocked;
  final double opacity; // 0.0 ~ 1.0
  final String blendMode; // '표준', '곱하기', '스크린', '오버레이'
  final String type; // 'pixel', 'text', 'shape', 'background'
  final Color color;
  final String? textContent;

  const PhotoshopLayer({
    required this.id,
    required this.name,
    this.isVisible = true,
    this.isLocked = false,
    this.opacity = 1.0,
    this.blendMode = '표준',
    this.type = 'pixel',
    this.color = const Color(0xFF31A8FF),
    this.textContent,
  });

  PhotoshopLayer copyWith({
    String? id,
    String? name,
    bool? isVisible,
    bool? isLocked,
    double? opacity,
    String? blendMode,
    String? type,
    Color? color,
    String? textContent,
  }) {
    return PhotoshopLayer(
      id: id ?? this.id,
      name: name ?? this.name,
      isVisible: isVisible ?? this.isVisible,
      isLocked: isLocked ?? this.isLocked,
      opacity: opacity ?? this.opacity,
      blendMode: blendMode ?? this.blendMode,
      type: type ?? this.type,
      color: color ?? this.color,
      textContent: textContent ?? this.textContent,
    );
  }
}

class PhotoshopHistoryItem {
  final String id;
  final String name;
  final IconData icon;

  const PhotoshopHistoryItem({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class PhotoshopConfig {
  final String documentTitle;
  final int zoomPercent;
  final String colorMode;
  final int widthPx;
  final int heightPx;
  final PhotoshopTool selectedTool;
  final Color foregroundColor;
  final Color backgroundColor;
  final double brushSize;
  final double brushOpacity;
  final List<PhotoshopLayer> layers;
  final String selectedLayerId;
  final List<PhotoshopHistoryItem> history;

  const PhotoshopConfig({
    required this.documentTitle,
    this.zoomPercent = 100,
    this.colorMode = 'RGB/8#',
    this.widthPx = 1920,
    this.heightPx = 1080,
    this.selectedTool = PhotoshopTool.move,
    this.foregroundColor = const Color(0xFF000000),
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.brushSize = 35.0,
    this.brushOpacity = 100.0,
    required this.layers,
    required this.selectedLayerId,
    required this.history,
  });

  PhotoshopConfig copyWith({
    String? documentTitle,
    int? zoomPercent,
    String? colorMode,
    int? widthPx,
    int? heightPx,
    PhotoshopTool? selectedTool,
    Color? foregroundColor,
    Color? backgroundColor,
    double? brushSize,
    double? brushOpacity,
    List<PhotoshopLayer>? layers,
    String? selectedLayerId,
    List<PhotoshopHistoryItem>? history,
  }) {
    return PhotoshopConfig(
      documentTitle: documentTitle ?? this.documentTitle,
      zoomPercent: zoomPercent ?? this.zoomPercent,
      colorMode: colorMode ?? this.colorMode,
      widthPx: widthPx ?? this.widthPx,
      heightPx: heightPx ?? this.heightPx,
      selectedTool: selectedTool ?? this.selectedTool,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      brushSize: brushSize ?? this.brushSize,
      brushOpacity: brushOpacity ?? this.brushOpacity,
      layers: layers ?? this.layers,
      selectedLayerId: selectedLayerId ?? this.selectedLayerId,
      history: history ?? this.history,
    );
  }

  static PhotoshopConfig defaultPreset() {
    final layers = [
      const PhotoshopLayer(
        id: 'layer-6',
        name: '텍스트: FictionScreen V3',
        type: 'text',
        color: Color(0xFFFFFFFF),
        textContent: 'FICTION SCREEN',
        opacity: 1.0,
      ),
      const PhotoshopLayer(
        id: 'layer-5',
        name: '빛 효과 (Lens Flare)',
        type: 'pixel',
        blendMode: '스크린',
        color: Color(0xFFFFD54F),
        opacity: 0.85,
      ),
      const PhotoshopLayer(
        id: 'layer-4',
        name: '메인 비주얼 그래픽',
        type: 'pixel',
        color: Color(0xFF5865F2),
        opacity: 1.0,
      ),
      const PhotoshopLayer(
        id: 'layer-3',
        name: '소프트 그림자',
        type: 'pixel',
        blendMode: '곱하기',
        color: Color(0xFF212121),
        opacity: 0.65,
      ),
      const PhotoshopLayer(
        id: 'layer-2',
        name: '네온 그라디언트 패턴',
        type: 'shape',
        color: Color(0xFFE91E63),
        opacity: 0.9,
      ),
      const PhotoshopLayer(
        id: 'layer-1',
        name: '배경 (Background)',
        type: 'background',
        color: Color(0xFF1E1E24),
        isLocked: true,
        opacity: 1.0,
      ),
    ];

    final history = [
      const PhotoshopHistoryItem(id: 'h-1', name: '열기', icon: Icons.folder_open),
      const PhotoshopHistoryItem(id: 'h-2', name: '새 레이어', icon: Icons.layers),
      const PhotoshopHistoryItem(id: 'h-3', name: '자유 변형 (Ctrl+T)', icon: Icons.transform),
      const PhotoshopHistoryItem(id: 'h-4', name: '문자 도구 입력', icon: Icons.title),
      const PhotoshopHistoryItem(id: 'h-5', name: '브러시 도구', icon: Icons.brush),
    ];

    return PhotoshopConfig(
      documentTitle: '진짜최종_시안_final_v4.psd',
      zoomPercent: 100,
      colorMode: 'RGB/8#',
      widthPx: 1920,
      heightPx: 1080,
      selectedTool: PhotoshopTool.move,
      foregroundColor: const Color(0xFF31A8FF),
      backgroundColor: const Color(0xFFFFFFFF),
      brushSize: 45.0,
      brushOpacity: 100.0,
      layers: layers,
      selectedLayerId: 'layer-6',
      history: history,
    );
  }
}
