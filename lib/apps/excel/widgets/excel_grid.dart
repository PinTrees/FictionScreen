import 'package:flutter/material.dart';
import '../data/excel_model.dart';

class ExcelGrid extends StatefulWidget {
  final ExcelSheet sheet;
  final String selectedCellKey;
  final ValueChanged<String> onSelectCell;

  const ExcelGrid({
    super.key,
    required this.sheet,
    required this.selectedCellKey,
    required this.onSelectCell,
  });

  @override
  State<ExcelGrid> createState() => _ExcelGridState();
}

class _ExcelGridState extends State<ExcelGrid> {
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();

  static const List<String> _colLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'];

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sheet = widget.sheet;
    final rowCount = sheet.rowCount;
    final colCount = sheet.colCount.clamp(1, _colLetters.length);

    // Parse active column and row from selectedCellKey (e.g. "D7")
    final selCol = widget.selectedCellKey.isNotEmpty ? widget.selectedCellKey[0] : 'A';
    final selRow = int.tryParse(widget.selectedCellKey.substring(1)) ?? 1;

    return Container(
      color: Colors.white,
      child: Scrollbar(
        controller: _verticalController,
        thumbVisibility: true,
        child: Scrollbar(
          controller: _horizontalController,
          thumbVisibility: true,
          notificationPredicate: (notif) => notif.depth == 1,
          child: SingleChildScrollView(
            controller: _verticalController,
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              controller: _horizontalController,
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Column Header Row (Top)
                  Row(
                    children: [
                      // Top-Left Corner Box
                      Container(
                        width: 42,
                        height: 24,
                        color: const Color(0xFFF3F2F1),
                        alignment: Alignment.center,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFF8A8886), width: 1.5),
                              right: BorderSide(color: Color(0xFF8A8886), width: 1.5),
                            ),
                          ),
                        ),
                      ),
                      // Column Headers (A, B, C...)
                      ...List.generate(colCount, (cIdx) {
                        final letter = _colLetters[cIdx];
                        final isColActive = letter == selCol;
                        final colWidth = cIdx < sheet.colWidths.length ? sheet.colWidths[cIdx] : 120.0;

                        return Container(
                          width: colWidth,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isColActive ? const Color(0xFFC7E0F4) : const Color(0xFFF3F2F1),
                            border: Border(
                              right: const BorderSide(color: Color(0xFFD2D0CE)),
                              bottom: BorderSide(
                                color: isColActive ? const Color(0xFF107C41) : const Color(0xFFD2D0CE),
                                width: isColActive ? 2 : 1,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            letter,
                            style: TextStyle(
                              color: isColActive ? const Color(0xFF107C41) : const Color(0xFF605E5C),
                              fontSize: 11,
                              fontWeight: isColActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  // 2. Data Rows (1, 2, 3...)
                  ...List.generate(rowCount, (rIdx) {
                    final rowNum = rIdx + 1;
                    final isRowActive = rowNum == selRow;

                    return Row(
                      children: [
                        // Row Header (Number 1, 2, 3...)
                        Container(
                          width: 42,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isRowActive ? const Color(0xFFC7E0F4) : const Color(0xFFF3F2F1),
                            border: Border(
                              bottom: const BorderSide(color: Color(0xFFD2D0CE)),
                              right: BorderSide(
                                color: isRowActive ? const Color(0xFF107C41) : const Color(0xFFD2D0CE),
                                width: isRowActive ? 2 : 1,
                              ),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '$rowNum',
                            style: TextStyle(
                              color: isRowActive ? const Color(0xFF107C41) : const Color(0xFF605E5C),
                              fontSize: 11,
                              fontWeight: isRowActive ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),

                        // Cells in this Row
                        ...List.generate(colCount, (cIdx) {
                          final letter = _colLetters[cIdx];
                          final cellKey = '$letter$rowNum';
                          final isSelected = cellKey == widget.selectedCellKey;
                          final cell = sheet.getCell(cellKey);
                          final colWidth = cIdx < sheet.colWidths.length ? sheet.colWidths[cIdx] : 120.0;

                          return GestureDetector(
                            onTap: () => widget.onSelectCell(cellKey),
                            child: Container(
                              width: colWidth,
                              height: 24,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (cell?.bgColor ?? Colors.white)
                                    : (cell?.bgColor ?? Colors.white),
                                border: isSelected
                                    ? Border.all(color: const Color(0xFF107C41), width: 2)
                                    : const Border(
                                        right: BorderSide(color: Color(0xFFE1DFDD)),
                                        bottom: BorderSide(color: Color(0xFFE1DFDD)),
                                      ),
                              ),
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: _getAlignment(cell?.align ?? TextAlign.left),
                                    child: Text(
                                      cell?.value ?? '',
                                      style: TextStyle(
                                        color: cell?.textColor ?? const Color(0xFF201F1E),
                                        fontSize: 11,
                                        fontWeight: cell?.isBold == true ? FontWeight.bold : FontWeight.normal,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Excel selection drag handle in bottom right corner
                                  if (isSelected)
                                    Positioned(
                                      right: -1,
                                      bottom: -1,
                                      child: Container(
                                        width: 5,
                                        height: 5,
                                        color: const Color(0xFF107C41),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment(TextAlign align) {
    switch (align) {
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.center:
        return Alignment.center;
      default:
        return Alignment.centerLeft;
    }
  }
}
