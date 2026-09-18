import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciPageBar extends StatelessWidget {
  final DavinciPage activePage;
  final ValueChanged<DavinciPage> onSelectPage;

  const DavinciPageBar({
    super.key,
    required this.activePage,
    required this.onSelectPage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      color: const Color(0xFF101012),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF28282C), width: 1)),
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: DavinciPage.values.map((page) {
            final isSelected = page == activePage;
            return InkWell(
              onTap: () => onSelectPage(page),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                height: double.infinity,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? const Color(0xFFE53935) : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      page.icon,
                      size: 13,
                      color: isSelected ? Colors.white : const Color(0xFF888890),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      page.label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF888890),
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
