import 'package:flutter/material.dart';
import '../../data/kakaobank_model.dart';
import '../../widgets/safebox_slider_modal.dart';
import 'widgets/credit_card_summary_card.dart';
import 'widgets/home_header.dart';
import 'widgets/main_account_card.dart';
import 'widgets/piggy_bank_card.dart';
import 'widgets/safebox_card.dart';
import 'widgets/savings_26weeks_card.dart';

class KakaoBankHomePage extends StatelessWidget {
  final KakaoBankConfig config;
  final VoidCallback onOpenEditDialog;
  final VoidCallback onAccountDetailTap;
  final VoidCallback onTransferTap;
  final ValueChanged<int> onSafeboxChanged;
  final VoidCallback? onSavingsTap;
  final VoidCallback? onPiggyBankTap;

  const KakaoBankHomePage({
    super.key,
    required this.config,
    required this.onOpenEditDialog,
    required this.onAccountDetailTap,
    required this.onTransferTap,
    required this.onSafeboxChanged,
    this.onSavingsTap,
    this.onPiggyBankTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 상단 헤더
        KakaoBankHomeHeader(
          userName: config.userName,
          onProfileTap: onOpenEditDialog,
          onNotificationTap: onOpenEditDialog,
        ),

        // 메인 스크롤 콘텐츠
        Expanded(
          child: Container(
            color: const Color(0xFF101014),
            child: ListView(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              children: [
                // 1. 시그니처 옐로우 메인 통장 카드
                KakaoBankMainAccountCard(
                  config: config,
                  onTap: onAccountDetailTap,
                  onTransfer: onTransferTap,
                  onBring: onOpenEditDialog,
                ),
                const SizedBox(height: 12),

                // 2. 세이프박스 서브 카드
                KakaoBankSafeboxCard(
                  balance: config.safeBoxBalance,
                  onTap: () {
                    KakaoBankSafeboxSliderModal.show(
                      context,
                      config.safeBoxBalance,
                      config.safeBoxTarget,
                      onSafeboxChanged,
                    );
                  },
                ),
                const SizedBox(height: 12),

                // 3. 26주 적금 카드
                KakaoBankSavings26WeeksCard(
                  savings: config.savings26,
                  onTap: onSavingsTap ?? onOpenEditDialog,
                ),
                const SizedBox(height: 12),

                // 4. 저금통 카드
                KakaoBankPiggyBankCard(
                  piggyBank: config.piggyBank,
                  onTap: onPiggyBankTap ?? onOpenEditDialog,
                ),
                const SizedBox(height: 12),

                // 5. 카드 이용금액 & 신용점수 요약 카드
                KakaoBankCreditCardSummaryCard(
                  cardInfo: config.cardInfo,
                  creditScore: config.creditScore,
                  onTap: onOpenEditDialog,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
