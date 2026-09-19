import 'package:flutter/material.dart';

class ExcelFormulaBar extends StatelessWidget {
  final String selectedCellKey;
  final String formulaText;
  final ValueChanged<String>? onFormulaChanged;

  const ExcelFormulaBar({
    super.key,
    required this.selectedCellKey,
    required this.formulaText,
    this.onFormulaChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE1DFDD))),
      ),
      child: Row(
        children: [
          // Cell Name Box
          Container(
            width: 60,
            height: 22,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFD2D0CE)),
            ),
            child: Text(
              selectedCellKey,
              style: const TextStyle(
                color: Color(0xFF323130),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 4),

          // Cancel & Check buttons
          const Icon(Icons.close, size: 14, color: Color(0xFFA19F9D)),
          const SizedBox(width: 4),
          const Icon(Icons.check, size: 14, color: Color(0xFFA19F9D)),
          const SizedBox(width: 6),

          // fx symbol
          const Text(
            'fx',
            style: TextStyle(
              color: Color(0xFF605E5C),
              fontSize: 13,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(width: 8),
          Container(width: 1, height: 18, color: const Color(0xFFE1DFDD)),
          const SizedBox(width: 8),

          // Formula Value
          Expanded(
            child: Container(
              height: 22,
              alignment: Alignment.centerLeft,
              child: Text(
                formulaText,
                style: const TextStyle(
                  color: Color(0xFF201F1E),
                  fontSize: 12,
                  fontFamily: 'Consolas',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
