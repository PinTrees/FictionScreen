import 'package:flutter/material.dart';
import '../../data/upbit_model.dart';
import 'deposit_withdraw/upbit_desktop_deposit_page.dart';
import 'exchange/upbit_desktop_exchange_view.dart';
import 'investment/upbit_desktop_investment_page.dart';
import 'staking/upbit_desktop_staking_page.dart';
import 'support/upbit_desktop_support_page.dart';
import 'trends/upbit_desktop_trends_page.dart';
import 'upbit_desktop_header.dart';

class UpbitDesktopExchangePage extends StatefulWidget {
  final UpbitConfig config;
  final Function(String symbol) onSelectCoin;
  final VoidCallback onEdit;

  const UpbitDesktopExchangePage({
    super.key,
    required this.config,
    required this.onSelectCoin,
    required this.onEdit,
  });

  @override
  State<UpbitDesktopExchangePage> createState() => _UpbitDesktopExchangePageState();
}

class _UpbitDesktopExchangePageState extends State<UpbitDesktopExchangePage> {
  String _activeGnbTab = '거래소';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9ECF1),
      body: Column(
        children: [
          // 1. 데스크탑 GNB 헤더
          UpbitDesktopHeader(
            activeTab: _activeGnbTab,
            onSelectTab: (tab) => setState(() => _activeGnbTab = tab),
            onEdit: widget.onEdit,
          ),

          // 2. 메인 페이지 콘텐츠 (GNB 탭에 따른 동적 라우팅)
          Expanded(
            child: _buildCurrentTabContent(),
          ),

          // 3. 하단 공식 푸터
          _buildDesktopFooter(),
        ],
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_activeGnbTab) {
      case '입출금':
        return UpbitDesktopDepositPage(config: widget.config, onEdit: widget.onEdit);
      case '투자내역':
        return UpbitDesktopInvestmentPage(config: widget.config, onEdit: widget.onEdit);
      case '코인동향':
        return UpbitDesktopTrendsPage(config: widget.config, onSelectCoin: widget.onSelectCoin);
      case '스테이킹':
        return UpbitDesktopStakingPage(config: widget.config, onEdit: widget.onEdit);
      case '고객센터':
        return UpbitDesktopSupportPage(config: widget.config, onEdit: widget.onEdit);
      case '거래소':
      default:
        return UpbitDesktopExchangeView(
          config: widget.config,
          onSelectCoin: widget.onSelectCoin,
          onEdit: widget.onEdit,
        );
    }
  }

  Widget _buildDesktopFooter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '두나무(주) | 대표이사 이석우 | 사업자등록번호: 119-86-54968 | 서울특별시 강남구 테헤란로 4길 14 | 고객센터 1588-5682\n'
            '가상자산은 고위험 상품으로서 투자금의 전부 또는 일부 손실을 초래할 수 있습니다.',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, height: 1.4),
          ),
          Text('Copyright © 2017 - 2026 Dunamu Inc. All rights reserved.', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}
