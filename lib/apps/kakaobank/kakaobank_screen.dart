import 'package:flutter/material.dart';
import 'data/kakaobank_model.dart';
import 'pages/benefits/kakaobank_benefits_page.dart';
import 'pages/home/kakaobank_home_page.dart';
import 'pages/more/kakaobank_more_page.dart';
import 'pages/products/kakaobank_products_page.dart';
import 'pages/transfer/kakaobank_account_detail_page.dart';
import 'pages/transfer/kakaobank_transfer_complete_page.dart';
import 'pages/transfer/kakaobank_transfer_page.dart';
import 'widgets/kakaobank_bottom_nav.dart';
import 'widgets/kakaobank_edit_dialog.dart';

enum KakaoBankSubView { none, accountDetail, transfer, transferComplete }

/// 카카오뱅크 메인 스크린 쉘 위젯
class KakaoBankScreen extends StatefulWidget {
  final KakaoBankConfig config;
  final ValueChanged<KakaoBankConfig>? onConfigChanged;

  const KakaoBankScreen({
    super.key,
    required this.config,
    this.onConfigChanged,
  });

  @override
  State<KakaoBankScreen> createState() => _KakaoBankScreenState();
}

class _KakaoBankScreenState extends State<KakaoBankScreen> {
  int _activeNavIndex = 0;
  KakaoBankSubView _subView = KakaoBankSubView.none;

  // 이체 완료 화면용 임시 데이터
  String _lastTransferRecipient = '';
  int _lastTransferAmount = 0;

  void _openEditDialog() {
    KakaoBankEditDialog.show(context, widget.config, (updated) {
      setState(() {});
      widget.onConfigChanged?.call(updated);
    });
  }

  void _handleTransferComplete(String recipient, int amount) {
    setState(() {
      _lastTransferRecipient = recipient;
      _lastTransferAmount = amount;
      widget.config.balance -= amount;
      widget.config.transactions.insert(
        0,
        KakaoBankTransactionItem(
          id: '${DateTime.now().millisecondsSinceEpoch}',
          title: recipient,
          date: '방금 전',
          amount: amount,
          isIncome: false,
          balanceAfter: widget.config.balance,
          category: '이체',
        ),
      );
      _subView = KakaoBankSubView.transferComplete;
    });
    widget.onConfigChanged?.call(widget.config);
  }

  @override
  Widget build(BuildContext context) {
    // 1. 서브 뷰가 활성화된 경우 (이체, 통장 상세, 이체 완료)
    if (_subView == KakaoBankSubView.accountDetail) {
      return KakaoBankAccountDetailPage(
        config: widget.config,
        onBack: () => setState(() => _subView = KakaoBankSubView.none),
        onTransfer: () => setState(() => _subView = KakaoBankSubView.transfer),
        onEdit: _openEditDialog,
      );
    }

    if (_subView == KakaoBankSubView.transfer) {
      return KakaoBankTransferPage(
        config: widget.config,
        onClose: () => setState(() => _subView = KakaoBankSubView.none),
        onTransferComplete: _handleTransferComplete,
      );
    }

    if (_subView == KakaoBankSubView.transferComplete) {
      return KakaoBankTransferCompletePage(
        recipient: _lastTransferRecipient,
        amount: _lastTransferAmount,
        balanceAfter: widget.config.balance,
        onConfirm: () => setState(() => _subView = KakaoBankSubView.none),
      );
    }

    // 2. 메인 4대 탭 네비게이션
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: _buildActiveTabContent()),
            KakaoBankBottomNav(
              activeIndex: _activeNavIndex,
              onTap: (idx) => setState(() => _activeNavIndex = idx),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent() {
    switch (_activeNavIndex) {
      case 0:
        return KakaoBankHomePage(
          config: widget.config,
          onOpenEditDialog: _openEditDialog,
          onAccountDetailTap: () => setState(() => _subView = KakaoBankSubView.accountDetail),
          onTransferTap: () => setState(() => _subView = KakaoBankSubView.transfer),
          onSafeboxChanged: (newBal) {
            setState(() => widget.config.safeBoxBalance = newBal);
            widget.onConfigChanged?.call(widget.config);
          },
        );
      case 1:
        return const KakaoBankProductsPage();
      case 2:
        return const KakaoBankBenefitsPage();
      case 3:
        return KakaoBankMorePage(
          config: widget.config,
          onEditProfile: _openEditDialog,
        );
      default:
        return Container();
    }
  }
}
