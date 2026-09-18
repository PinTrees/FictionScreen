import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/discord_model.dart';

class DiscordServerSidebar extends StatelessWidget {
  final List<DiscordServer> servers;
  final String selectedServerId;
  final ValueChanged<String> onSelectServer;
  final VoidCallback onHomeTap;

  const DiscordServerSidebar({
    super.key,
    required this.servers,
    required this.selectedServerId,
    required this.onSelectServer,
    required this.onHomeTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      color: const Color(0xFF1E1F22),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Discord DM Home Button
          _buildHomeButton(),
          const SizedBox(height: 8),
          // Server Separator
          Container(
            width: 32,
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFF35373C),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 8),

          // Server List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: servers.length,
              itemBuilder: (context, idx) {
                final server = servers[idx];
                final isSelected = server.id == selectedServerId;
                return _buildServerItem(server, isSelected);
              },
            ),
          ),

          // Bottom Action Buttons: Add Server & Compass
          _buildActionItem(CupertinoIcons.add, const Color(0xFF23A55A), () {}),
          _buildActionItem(CupertinoIcons.compass, const Color(0xFF23A55A), () {}),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHomeButton() {
    final isSelected = selectedServerId == 'dm';
    return InkWell(
      onTap: onHomeTap,
      borderRadius: BorderRadius.circular(24),
      child: SizedBox(
        width: 72,
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Left white pill indicator
            Positioned(
              left: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 4,
                height: isSelected ? 40 : 0,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF5865F2),
                borderRadius: BorderRadius.circular(isSelected ? 16 : 24),
              ),
              child: const Center(
                child: Icon(CupertinoIcons.game_controller_solid, color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServerItem(DiscordServer server, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () => onSelectServer(server.id),
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          width: 72,
          height: 48,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Left white pill indicator
              Positioned(
                left: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 4,
                  height: isSelected ? 40 : (server.hasNotification ? 8 : 0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(right: Radius.circular(4)),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected ? server.iconColor : const Color(0xFF313338),
                  borderRadius: BorderRadius.circular(isSelected ? 16 : 24),
                ),
                child: Center(
                  child: Text(
                    server.iconText,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFDBDEE1),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              if (server.hasNotification)
                Positioned(
                  right: 8,
                  bottom: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF23F43),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1E1F22), width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(IconData icon, Color hoverColor, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFF313338),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(icon, color: hoverColor, size: 20),
          ),
        ),
      ),
    );
  }
}
