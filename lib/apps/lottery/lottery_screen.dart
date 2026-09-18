import 'package:flutter/material.dart';
import 'common/lottery_header.dart';
import 'data/lottery_model.dart';
import 'pages/lotto_result/lotto_result_page.dart';
import 'pages/paper_slip/lotto_slip_page.dart';
import 'pages/pension_lottery/pension_lottery_page.dart';
import 'pages/spito/spito_scratch_page.dart';

/// 동행복권 (로또 6/45) 메인 화면 오케스트레이터
class LotteryScreen extends StatefulWidget {
  final LotteryConfig? config;
  final ValueChanged<LotteryConfig>? onConfigChanged;

  const LotteryScreen({
    super.key,
    this.config,
    this.onConfigChanged,
  });

  @override
  State<LotteryScreen> createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  late LotteryConfig _config;
  int _currentTabIndex = 1; // 기본으로 크리에이터 핵심인 '내 로또 영수증 (QR 당첨확인)'으로 시작

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? LotteryConfig.defaultPreset();
  }

  @override
  void didUpdateWidget(covariant LotteryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.config != null && widget.config != _config) {
      _config = widget.config!;
    }
  }

  void _updateConfig(LotteryConfig newConfig) {
    setState(() => _config = newConfig);
    widget.onConfigChanged?.call(newConfig);
  }

  void _handleSelectFirstPrize() {
    _updateConfig(LotteryConfig.defaultPreset());
  }

  void _handleSelectSecondPrize() {
    _updateConfig(LotteryConfig.secondPrizePreset());
  }

  void _handleSelectLose() {
    _updateConfig(LotteryConfig.losePreset());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // 1. 상단 GNB & 서비스 탭
          LotteryHeader(
            currentTabIndex: _currentTabIndex,
            onTabChanged: (index) => setState(() => _currentTabIndex = index),
            onSelectFirstPrize: _handleSelectFirstPrize,
            onSelectSecondPrize: _handleSelectSecondPrize,
            onSelectLose: _handleSelectLose,
          ),

          // 2. 탭별 메인 뷰
          Expanded(
            child: IndexedStack(
              index: _currentTabIndex,
              children: [
                // 0. 로또 6/45 추첨 결과
                LottoResultPage(
                  config: _config,
                  onConfigChanged: _updateConfig,
                ),
                // 1. 내 로또 영수증 & QR 당첨 확인
                LottoSlipPage(
                  config: _config,
                  onConfigChanged: _updateConfig,
                ),
                // 2. 연금복권 720+
                PensionLotteryPage(
                  config: _config,
                  onConfigChanged: _updateConfig,
                ),
                // 3. 스피또 2000 즉석 복권
                SpitoScratchPage(
                  config: _config,
                  onConfigChanged: _updateConfig,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
