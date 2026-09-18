import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'data/upbit_model.dart';
import 'pages/desktop/upbit_desktop_exchange_page.dart';
import 'pages/mobile/upbit_mobile_detail_page.dart';
import 'pages/mobile/upbit_mobile_exchange_page.dart';
import 'pages/mobile/upbit_mobile_investment_page.dart';
import 'widgets/upbit_bottom_nav.dart';
import 'widgets/upbit_edit_dialog.dart';

class UpbitScreen extends StatefulWidget {
  final UpbitConfig? config;
  final ValueChanged<UpbitConfig>? onConfigChanged;

  const UpbitScreen({
    super.key,
    this.config,
    this.onConfigChanged,
  });

  @override
  State<UpbitScreen> createState() => _UpbitScreenState();
}

class _UpbitScreenState extends State<UpbitScreen> {
  late UpbitConfig _config;
  int _mobileTab = 0; // 0: 거래소, 1: 코인정보, 2: 투자내역, 3: 입출금, 4: 더보기
  bool _isViewingDetail = false;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? UpbitConfig.defaultPreset();
  }

  @override
  void didUpdateWidget(covariant UpbitScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null && widget.config != oldWidget.config) {
      _config = widget.config!;
    }
  }

  void _openEditDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => UpbitEditDialog(
        config: _config,
        onSave: (updated) {
          setState(() => _config = updated);
          widget.onConfigChanged?.call(updated);
        },
      ),
    );
  }

  void _handleSelectCoin(String symbol) {
    setState(() {
      _config.selectedCoinSymbol = symbol;
      _isViewingDetail = true;
    });
    widget.onConfigChanged?.call(_config);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 700;
        if (isDesktop) {
          return _buildDesktopLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Stack(
      children: [
        UpbitDesktopExchangePage(
          config: _config,
          onSelectCoin: (symbol) {
            setState(() => _config.selectedCoinSymbol = symbol);
            widget.onConfigChanged?.call(_config);
          },
          onEdit: _openEditDialog,
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: FloatingActionButton.extended(
            backgroundColor: const Color(0xFF093687),
            foregroundColor: Colors.white,
            icon: const Icon(CupertinoIcons.slider_horizontal_3, size: 18),
            label: const Text('시세/자산 연출', style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: _openEditDialog,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    if (_isViewingDetail) {
      return UpbitMobileDetailPage(
        coin: _config.selectedCoin,
        onBack: () => setState(() => _isViewingDetail = false),
        onOpenEditDialog: _openEditDialog,
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: _mobileTab == 2
          ? UpbitMobileInvestmentPage(config: _config, onOpenEditDialog: _openEditDialog)
          : UpbitMobileExchangePage(
              config: _config,
              onSelectCoin: _handleSelectCoin,
              onOpenEditDialog: _openEditDialog,
            ),
      bottomNavigationBar: UpbitBottomNav(
        activeIndex: _mobileTab,
        onTap: (index) => setState(() => _mobileTab = index),
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: const Color(0xFF093687),
        foregroundColor: Colors.white,
        onPressed: _openEditDialog,
        child: const Icon(CupertinoIcons.slider_horizontal_3, size: 18),
      ),
    );
  }
}
