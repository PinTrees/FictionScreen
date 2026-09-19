import 'package:flutter/material.dart';
import 'data/excel_model.dart';
import 'widgets/excel_edit_dialog.dart';
import 'widgets/excel_formula_bar.dart';
import 'widgets/excel_grid.dart';
import 'widgets/excel_ribbon.dart';
import 'widgets/excel_sheet_bar.dart';

class ExcelScreen extends StatefulWidget {
  final ExcelConfig config;
  final ValueChanged<ExcelConfig>? onConfigChanged;

  const ExcelScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<ExcelScreen> createState() => _ExcelScreenState();
}

class _ExcelScreenState extends State<ExcelScreen> {
  late ExcelConfig _config;

  @override
  void initState() {
    super.initState();
    _config = widget.config;
  }

  @override
  void didUpdateWidget(covariant ExcelScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _config = widget.config;
    }
  }

  void _updateConfig(ExcelConfig newConfig) {
    setState(() {
      _config = newConfig;
    });
    widget.onConfigChanged?.call(newConfig);
  }

  void _openEditDialog() {
    showDialog(
      context: context,
      builder: (ctx) => ExcelEditDialog(
        config: _config,
        onApply: _updateConfig,
      ),
    );
  }

  void _onSelectCell(String cellKey) {
    final cell = _config.activeSheet.getCell(cellKey);
    final formula = cell != null ? (cell.value.startsWith('=') ? cell.value : cell.value) : '';
    _updateConfig(_config.copyWith(
      selectedCellKey: cellKey,
      formulaText: formula.isNotEmpty ? formula : _config.formulaText,
    ));
  }

  void _onSelectSheet(int index) {
    _updateConfig(_config.copyWith(activeSheetIndex: index));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // 1. Ribbon Bar
          ExcelRibbon(
            fileName: _config.fileName,
            onOpenEdit: _openEditDialog,
          ),

          // 2. Formula Bar
          ExcelFormulaBar(
            selectedCellKey: _config.selectedCellKey,
            formulaText: _config.formulaText,
          ),

          // 3. Main Spreadsheet Grid
          Expanded(
            child: ExcelGrid(
              sheet: _config.activeSheet,
              selectedCellKey: _config.selectedCellKey,
              onSelectCell: _onSelectCell,
            ),
          ),

          // 4. Sheet Bar & Status Statistics
          ExcelSheetBar(
            sheets: _config.sheets,
            activeSheetIndex: _config.activeSheetIndex,
            onSelectSheet: _onSelectSheet,
            statusMessage: _config.statusMessage,
            sumText: _config.sumText,
            avgText: _config.avgText,
            countText: _config.countText,
          ),
        ],
      ),
    );
  }
}
