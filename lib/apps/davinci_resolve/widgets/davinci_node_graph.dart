import 'package:flutter/material.dart';
import '../data/davinci_resolve_model.dart';

class DavinciNodeGraph extends StatelessWidget {
  final List<GradingNode> nodes;
  final ValueChanged<int> onToggleBypass;
  final ValueChanged<int> onSelectNode;

  const DavinciNodeGraph({
    super.key,
    required this.nodes,
    required this.onToggleBypass,
    required this.onSelectNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B1B1E),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.hub_outlined, size: 13, color: Color(0xFFE53935)),
              const SizedBox(width: 6),
              const Text(
                'NODES - COLOR GRAPH',
                style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(3)),
                child: const Text('Serial Nodes (3)', style: TextStyle(color: Colors.white38, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Green Input Dot
                  _buildConnectorDot(const Color(0xFF4CAF50), 'In'),
                  _buildWire(const Color(0xFF4CAF50)),

                  // Nodes List
                  ...List.generate(nodes.length, (idx) {
                    final node = nodes[idx];
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildNodeCard(node),
                        if (idx < nodes.length - 1) _buildWire(node.isBypassed ? Colors.white24 : const Color(0xFF4CAF50)),
                      ],
                    );
                  }),

                  _buildWire(const Color(0xFF4CAF50)),
                  // Red Output Dot
                  _buildConnectorDot(const Color(0xFFE53935), 'Out'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeCard(GradingNode node) {
    final isSelected = node.isSelected;
    final isBypassed = node.isBypassed;

    return InkWell(
      onTap: () => onSelectNode(node.id),
      child: Container(
        width: 130,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF222226),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? const Color(0xFFE53935) : (isBypassed ? Colors.white12 : const Color(0xFF3F3F46)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: const Color(0xFFE53935).withValues(alpha: 0.3), blurRadius: 8)]
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Node Header with number & bypass
            Container(
              height: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE53935).withValues(alpha: 0.3) : const Color(0xFF1B1B1E),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
              ),
              child: Row(
                children: [
                  Text(
                    '0${node.id}',
                    style: TextStyle(
                      color: isSelected ? const Color(0xFFFF8A80) : Colors.white70,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => onToggleBypass(node.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: isBypassed ? const Color(0xFFE53935) : const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        isBypassed ? 'BYP' : 'ON',
                        style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Node Thumbnail / Label preview
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(6),
                color: const Color(0xFF141416),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      node.id == 2 ? Icons.filter_vintage : (node.id == 3 ? Icons.auto_awesome : Icons.exposure),
                      size: 16,
                      color: isBypassed ? Colors.white24 : const Color(0xFF00BCD4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      node.label,
                      style: TextStyle(
                        color: isBypassed ? Colors.white30 : Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWire(Color color) {
    return Container(
      width: 24,
      height: 2.5,
      color: color,
    );
  }

  Widget _buildConnectorDot(Color color, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 4)],
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 9)),
      ],
    );
  }
}
