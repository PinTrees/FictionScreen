import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'desktop_mode/steamos_desktop_mode.dart';
import 'gaming_mode/steamos_gaming_mode.dart';
import 'widgets/steamos_quick_access_menu.dart';
import 'widgets/steamos_steam_menu.dart';

enum SteamOsMode {
  gaming,
  desktop,
}

class SteamOsView extends StatefulWidget {
  final User? user;
  final String timeString;
  final String dateString;
  final String currentWallpaper;
  final Function(String templateId) onOpenTemplate;
  final VoidCallback onOpenSettings;
  final VoidCallback onSignOut;
  final VoidCallback onGoHome;
  final Function(String osKey)? onSelectOs;

  const SteamOsView({
    super.key,
    required this.user,
    required this.timeString,
    required this.dateString,
    required this.currentWallpaper,
    required this.onOpenTemplate,
    required this.onOpenSettings,
    required this.onSignOut,
    required this.onGoHome,
    this.onSelectOs,
  });

  @override
  State<SteamOsView> createState() => _SteamOsViewState();
}

class _SteamOsViewState extends State<SteamOsView> {
  SteamOsMode _currentMode = SteamOsMode.gaming;
  bool _isSteamMenuOpen = false;
  bool _isQamOpen = false;

  void _switchToDesktop() {
    setState(() {
      _isSteamMenuOpen = false;
      _isQamOpen = false;
      _currentMode = SteamOsMode.desktop;
    });
  }

  void _returnToGamingMode() {
    setState(() {
      _currentMode = SteamOsMode.gaming;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Active Mode (Gaming Mode vs Desktop Mode)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          child: _currentMode == SteamOsMode.gaming
              ? SteamosGamingMode(
                  key: const ValueKey('gaming_mode'),
                  user: widget.user,
                  timeString: widget.timeString,
                  onToggleSteamMenu: () => setState(() {
                    _isQamOpen = false;
                    _isSteamMenuOpen = !_isSteamMenuOpen;
                  }),
                  onToggleQam: () => setState(() {
                    _isSteamMenuOpen = false;
                    _isQamOpen = !_isQamOpen;
                  }),
                  onSwitchToDesktop: _switchToDesktop,
                  onOpenTemplate: widget.onOpenTemplate,
                  onOpenSettings: widget.onOpenSettings,
                )
              : SteamosDesktopMode(
                  key: const ValueKey('desktop_mode'),
                  user: widget.user,
                  timeString: widget.timeString,
                  dateString: widget.dateString,
                  onReturnToGamingMode: _returnToGamingMode,
                  onOpenTemplate: widget.onOpenTemplate,
                  onOpenSettings: widget.onOpenSettings,
                  onSignOut: widget.onSignOut,
                  onGoHome: widget.onGoHome,
                  onSelectOs: widget.onSelectOs,
                ),
        ),

        // Left STEAM Sliding Drawer Menu
        if (_isSteamMenuOpen && _currentMode == SteamOsMode.gaming) ...[
          // Backdrop dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isSteamMenuOpen = false),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          SteamosSteamMenu(
            onClose: () => setState(() => _isSteamMenuOpen = false),
            onSwitchToDesktop: _switchToDesktop,
            onOpenTemplate: widget.onOpenTemplate,
            onOpenSettings: widget.onOpenSettings,
            onSignOut: widget.onSignOut,
            onGoHome: widget.onGoHome,
            onSelectOs: widget.onSelectOs,
          ),
        ],

        // Right Quick Access Sliding Drawer Menu
        if (_isQamOpen && _currentMode == SteamOsMode.gaming) ...[
          // Backdrop dismiss
          Positioned.fill(
            child: GestureDetector(
              onTap: () => setState(() => _isQamOpen = false),
              child: Container(color: Colors.black.withValues(alpha: 0.5)),
            ),
          ),
          SteamosQuickAccessMenu(
            onClose: () => setState(() => _isQamOpen = false),
          ),
        ],
      ],
    );
  }
}
