import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../apps/coupang/data/coupang_model.dart';
import '../../../apps/daangn/data/daangn_model.dart';
import '../../../apps/delivery/data/delivery_model.dart';
import '../../../apps/instagram/data/instagram_model.dart';
import '../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../apps/netflix/data/netflix_model.dart';
import '../../../apps/pinterest/data/pinterest_model.dart';
import '../../../apps/toss/data/toss_model.dart';
import '../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../apps/windows_update/data/windows_update_model.dart';
import '../../../apps/x_twitter/data/x_twitter_model.dart';
import '../../../apps/youtube/data/youtube_model.dart';

/// 스튜디오 템플릿별 실시간 다이얼로그 모달 모듈
class StudioQuickDialogs {
  static void openQuickEditDialog({
    required BuildContext context,
    required String title,
    required List<Widget> children,
    VoidCallback? onConfirm,
    VoidCallback? onUpdated,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1E202C),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              const Icon(CupertinoIcons.pencil_circle_fill, color: Color(0xFF818CF8), size: 22),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 360,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: children),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소', style: TextStyle(color: Colors.white54))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(context);
                onUpdated?.call();
              },
              child: const Text('적용하기', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  static Widget buildDialogInput(String label, TextEditingController controller, {int maxLines = 1, TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: type,
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF12141D),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF6366F1))),
            ),
          ),
        ],
      ),
    );
  }

  static void editTossHeader(BuildContext context, TossConfig config, VoidCallback onUpdated) {
    final nameCtrl = TextEditingController(text: config.userName);
    openQuickEditDialog(
      context: context,
      title: '토스 사용자 정보 수정',
      children: [buildDialogInput('사용자 이름', nameCtrl)],
      onConfirm: () => config.userName = nameCtrl.text,
      onUpdated: onUpdated,
    );
  }

  static void editTossSendCard(BuildContext context, TossConfig config, VoidCallback onUpdated) {
    final msgCtrl = TextEditingController(text: config.completionMessage);
    final receiverCtrl = TextEditingController(text: config.receiverName);
    final amountCtrl = TextEditingController(text: config.sendAmount.toString());
    final timeCtrl = TextEditingController(text: config.transactionTime);
    openQuickEditDialog(
      context: context,
      title: '송금 완료 내역 수정',
      children: [
        buildDialogInput('송금 완료 메시지', msgCtrl),
        buildDialogInput('받으시는 분 이름', receiverCtrl),
        buildDialogInput('보낸 금액 (원)', amountCtrl, type: TextInputType.number),
        buildDialogInput('거래 일시', timeCtrl),
      ],
      onConfirm: () {
        config.completionMessage = msgCtrl.text;
        config.receiverName = receiverCtrl.text;
        config.sendAmount = int.tryParse(amountCtrl.text) ?? config.sendAmount;
        config.transactionTime = timeCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editTossBalanceCard(BuildContext context, TossConfig config, VoidCallback onUpdated) {
    final bankCtrl = TextEditingController(text: config.bankName);
    final accCtrl = TextEditingController(text: config.accountNumber);
    final balanceCtrl = TextEditingController(text: config.balance.toString());
    openQuickEditDialog(
      context: context,
      title: '계좌 및 잔액 수정',
      children: [
        buildDialogInput('은행명', bankCtrl),
        buildDialogInput('계좌번호', accCtrl),
        buildDialogInput('출금 가능 잔액 (원)', balanceCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        config.bankName = bankCtrl.text;
        config.accountNumber = accCtrl.text;
        config.balance = int.tryParse(balanceCtrl.text) ?? config.balance;
      },
      onUpdated: onUpdated,
    );
  }

  static void editTossHistoryItem(BuildContext context, TossTransaction item, VoidCallback onUpdated) {
    final titleCtrl = TextEditingController(text: item.title);
    final amountCtrl = TextEditingController(text: item.amount.toString());
    final timeCtrl = TextEditingController(text: item.time);
    openQuickEditDialog(
      context: context,
      title: '거래 내역 항목 수정',
      children: [
        buildDialogInput('거래처 / 이름', titleCtrl),
        buildDialogInput('거래 금액 (원)', amountCtrl, type: TextInputType.number),
        buildDialogInput('거래 시간 (예: 14:30)', timeCtrl),
      ],
      onConfirm: () {
        item.title = titleCtrl.text;
        item.amount = int.tryParse(amountCtrl.text) ?? item.amount;
        item.time = timeCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editKakaoHeader(BuildContext context, KakaoRoomConfig config, VoidCallback onUpdated) {
    final roomNameCtrl = TextEditingController(text: config.roomTitle);
    final countCtrl = TextEditingController(text: config.memberCount.toString());
    final statusTimeCtrl = TextEditingController(text: config.statusBarTime);
    final batteryCtrl = TextEditingController(text: config.batteryLevel.toString());
    openQuickEditDialog(
      context: context,
      title: '카카오톡 채팅방 헤더 수정',
      children: [
        buildDialogInput('채팅방 이름', roomNameCtrl),
        buildDialogInput('참여자 수', countCtrl, type: TextInputType.number),
        buildDialogInput('상태바 시각 (예: 14:35)', statusTimeCtrl),
        buildDialogInput('배터리 잔량 (%)', batteryCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        config.roomTitle = roomNameCtrl.text;
        config.memberCount = int.tryParse(countCtrl.text) ?? config.memberCount;
        config.statusBarTime = statusTimeCtrl.text;
        config.batteryLevel = int.tryParse(batteryCtrl.text) ?? config.batteryLevel;
      },
      onUpdated: onUpdated,
    );
  }

  static void addOrEditKakaoMessage(BuildContext context, KakaoRoomConfig config, VoidCallback onUpdated, [KakaoMessage? existingMsg]) {
    final isEdit = existingMsg != null;
    final senderCtrl = TextEditingController(text: isEdit ? existingMsg.senderName : '상대방');
    final textCtrl = TextEditingController(text: isEdit ? existingMsg.text : '');
    final timeCtrl = TextEditingController(text: isEdit ? existingMsg.time : '오후 2:35');
    bool isMe = isEdit ? existingMsg.isMe : false;
    int unread = isEdit ? existingMsg.unreadCount : 1;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E202C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(isEdit ? '메시지 수정' : '새 메시지 추가', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: 360,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          ChoiceChip(label: const Text('상대방 메시지'), selected: !isMe, onSelected: (val) => setDialogState(() => isMe = !val)),
                          const SizedBox(width: 8),
                          ChoiceChip(label: const Text('내 메시지'), selected: isMe, onSelected: (val) => setDialogState(() => isMe = val)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (!isMe) buildDialogInput('발신자 이름', senderCtrl),
                      buildDialogInput('메시지 내용', textCtrl, maxLines: 3),
                      buildDialogInput('시각', timeCtrl),
                      Row(
                        children: [
                          const Text('안읽음 표시 (1):', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(width: 8),
                          Switch(value: unread == 1, onChanged: (val) => setDialogState(() => unread = val ? 1 : 0)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                if (isEdit)
                  TextButton(
                    onPressed: () {
                      config.messages.removeWhere((m) => m.id == existingMsg.id);
                      Navigator.pop(context);
                      onUpdated();
                    },
                    child: const Text('삭제', style: TextStyle(color: Colors.redAccent)),
                  ),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('취소', style: TextStyle(color: Colors.white54))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6366F1)),
                  onPressed: () {
                    if (isEdit) {
                      existingMsg.senderName = senderCtrl.text;
                      existingMsg.text = textCtrl.text;
                      existingMsg.time = timeCtrl.text;
                      existingMsg.isMe = isMe;
                      existingMsg.unreadCount = unread;
                    } else {
                      config.messages.add(
                        KakaoMessage(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          senderName: senderCtrl.text,
                          isMe: isMe,
                          text: textCtrl.text,
                          time: timeCtrl.text,
                          unreadCount: unread,
                        ),
                      );
                    }
                    Navigator.pop(context);
                    onUpdated();
                  },
                  child: const Text('저장', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static void editInstagram(BuildContext context, InstagramConfig config, VoidCallback onUpdated) {
    final userCtrl = TextEditingController(text: config.username);
    final locCtrl = TextEditingController(text: config.location);
    final likesCtrl = TextEditingController(text: config.likes);
    final captionCtrl = TextEditingController(text: config.caption);
    final timeCtrl = TextEditingController(text: config.timeAgo);
    openQuickEditDialog(
      context: context,
      title: '인스타그램 피드 수정',
      children: [
        buildDialogInput('사용자 ID', userCtrl),
        buildDialogInput('위치 태그', locCtrl),
        buildDialogInput('좋아요 수', likesCtrl),
        buildDialogInput('게시물 캡션 글', captionCtrl, maxLines: 3),
        buildDialogInput('업로드 시간', timeCtrl),
      ],
      onConfirm: () {
        config.username = userCtrl.text;
        config.location = locCtrl.text;
        config.likes = likesCtrl.text;
        config.caption = captionCtrl.text;
        config.timeAgo = timeCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editYoutube(BuildContext context, YoutubeConfig config, ValueChanged<YoutubeConfig> onConfigChanged) {
    final videoIdCtrl = TextEditingController(text: config.videoId);
    final titleCtrl = TextEditingController(text: config.videoTitle);
    final channelCtrl = TextEditingController(text: config.channelName);
    final subCtrl = TextEditingController(text: config.subscriberCount);
    final viewCtrl = TextEditingController(text: config.viewCount);
    final timeCtrl = TextEditingController(text: config.uploadTime);
    openQuickEditDialog(
      context: context,
      title: '유튜브 영상 및 정보 수정',
      children: [
        buildDialogInput('유튜브 영상 ID 또는 링크 (IFrame 재생)', videoIdCtrl),
        buildDialogInput('동영상 제목', titleCtrl, maxLines: 2),
        buildDialogInput('채널 이름', channelCtrl),
        buildDialogInput('구독자 수', subCtrl),
        buildDialogInput('조회수', viewCtrl),
        buildDialogInput('업로드 일자', timeCtrl),
      ],
      onConfirm: () {
        String vid = videoIdCtrl.text.trim();
        if (vid.contains('v=')) {
          vid = vid.split('v=')[1].split('&')[0];
        } else if (vid.contains('youtu.be/')) {
          vid = vid.split('youtu.be/')[1].split('?')[0];
        } else if (vid.contains('embed/')) {
          vid = vid.split('embed/')[1].split('?')[0];
        }
        onConfigChanged(
          config.copyWith(
            videoId: vid.isNotEmpty ? vid : config.videoId,
            title: titleCtrl.text,
            channelName: channelCtrl.text,
            subscriberCount: subCtrl.text,
            viewCount: viewCtrl.text,
            uploadTime: timeCtrl.text,
          ),
        );
      },
    );
  }

  static void editDelivery(BuildContext context, DeliveryConfig config, VoidCallback onUpdated) {
    final storeCtrl = TextEditingController(text: config.storeName);
    final orderNumCtrl = TextEditingController(text: config.orderNumber);
    final timeCtrl = TextEditingController(text: config.estimatedTime);
    final menuCtrl = TextEditingController(text: config.menuSummary);
    final priceCtrl = TextEditingController(text: config.totalPrice.toString());
    openQuickEditDialog(
      context: context,
      title: '배달 플랫폼 정보 수정',
      children: [
        buildDialogInput('가게 이름', storeCtrl),
        buildDialogInput('주문 번호', orderNumCtrl),
        buildDialogInput('예상 도착 시간', timeCtrl),
        buildDialogInput('메뉴 요약', menuCtrl, maxLines: 2),
        buildDialogInput('총 결제금액 (원)', priceCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        config.storeName = storeCtrl.text;
        config.orderNumber = orderNumCtrl.text;
        config.estimatedTime = timeCtrl.text;
        config.menuSummary = menuCtrl.text;
        config.totalPrice = int.tryParse(priceCtrl.text) ?? config.totalPrice;
      },
      onUpdated: onUpdated,
    );
  }

  static void editTwitter(BuildContext context, XTwitterConfig config, VoidCallback onUpdated) {
    final nameCtrl = TextEditingController(text: config.displayName);
    final handleCtrl = TextEditingController(text: config.username);
    final textCtrl = TextEditingController(text: config.tweetText);
    final timeCtrl = TextEditingController(text: config.postTime);
    final viewsCtrl = TextEditingController(text: config.views);
    final retweetsCtrl = TextEditingController(text: config.retweets);
    final likesCtrl = TextEditingController(text: config.likes);
    openQuickEditDialog(
      context: context,
      title: 'X (트위터) 트윗 수정',
      children: [
        buildDialogInput('표시 이름', nameCtrl),
        buildDialogInput('아이디 (@username)', handleCtrl),
        buildDialogInput('트윗 내용', textCtrl, maxLines: 4),
        buildDialogInput('작성 시각 (예: 오전 11:20 · 2026년 3월 29일)', timeCtrl),
        buildDialogInput('조회수', viewsCtrl),
        buildDialogInput('리트윗 수', retweetsCtrl),
        buildDialogInput('마음에 들어요 수', likesCtrl),
      ],
      onConfirm: () {
        config.displayName = nameCtrl.text;
        config.username = handleCtrl.text;
        config.tweetText = textCtrl.text;
        config.postTime = timeCtrl.text;
        config.views = viewsCtrl.text;
        config.retweets = retweetsCtrl.text;
        config.likes = likesCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editPinterest(BuildContext context, PinterestConfig config, VoidCallback onUpdated) {
    final titleCtrl = TextEditingController(text: config.pinTitle);
    final creatorCtrl = TextEditingController(text: config.creatorName);
    final descCtrl = TextEditingController(text: config.description);
    final savedCtrl = TextEditingController(text: config.savedCount);
    openQuickEditDialog(
      context: context,
      title: '핀터레스트 핀 수정',
      children: [
        buildDialogInput('핀 제목', titleCtrl, maxLines: 2),
        buildDialogInput('크리에이터 이름', creatorCtrl),
        buildDialogInput('핀 설명', descCtrl, maxLines: 3),
        buildDialogInput('저장 수', savedCtrl),
      ],
      onConfirm: () {
        config.pinTitle = titleCtrl.text;
        config.creatorName = creatorCtrl.text;
        config.description = descCtrl.text;
        config.savedCount = savedCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editBsod(BuildContext context, WindowsBsodConfig config, VoidCallback onUpdated) {
    final percentCtrl = TextEditingController(text: config.percentage.toString());
    final stopCodeCtrl = TextEditingController(text: config.stopCode);
    final failedCtrl = TextEditingController(text: config.whatFailed);
    openQuickEditDialog(
      context: context,
      title: 'Windows BSOD 오류 화면 수정',
      children: [
        buildDialogInput('진행률 퍼센트 (%)', percentCtrl, type: TextInputType.number),
        buildDialogInput('중지 코드 (Stop Code)', stopCodeCtrl),
        buildDialogInput('실패 항목 (whatFailed)', failedCtrl),
      ],
      onConfirm: () {
        config.percentage = int.tryParse(percentCtrl.text) ?? config.percentage;
        config.stopCode = stopCodeCtrl.text;
        config.whatFailed = failedCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editWindowsUpdate(BuildContext context, WindowsUpdateConfig config, VoidCallback onUpdated) {
    final progressCtrl = TextEditingController(text: config.progress.toString());
    final primaryCtrl = TextEditingController(text: config.primaryMessage);
    final secondaryCtrl = TextEditingController(text: config.secondaryMessage);
    openQuickEditDialog(
      context: context,
      title: 'Windows 업데이트 화면 수정',
      children: [
        buildDialogInput('업데이트 진행률 (%)', progressCtrl, type: TextInputType.number),
        buildDialogInput('주요 안내 문구', primaryCtrl),
        buildDialogInput('보조 안내 문구', secondaryCtrl, maxLines: 3),
      ],
      onConfirm: () {
        config.progress = int.tryParse(progressCtrl.text) ?? config.progress;
        config.primaryMessage = primaryCtrl.text;
        config.secondaryMessage = secondaryCtrl.text;
      },
      onUpdated: onUpdated,
    );
  }

  static void editDaangn(BuildContext context, DaangnConfig config, VoidCallback onUpdated) {
    final sellerCtrl = TextEditingController(text: config.sellerName);
    final locationCtrl = TextEditingController(text: config.sellerLocation);
    final mannerCtrl = TextEditingController(text: config.mannerTemp.toString());
    final titleCtrl = TextEditingController(text: config.productTitle);
    final priceCtrl = TextEditingController(text: config.productPrice.toString());
    openQuickEditDialog(
      context: context,
      title: '당근마켓 정보 수정',
      children: [
        buildDialogInput('판매자 닉네임', sellerCtrl),
        buildDialogInput('동네 위치', locationCtrl),
        buildDialogInput('매너온도 (°C)', mannerCtrl, type: TextInputType.number),
        buildDialogInput('상품 제목', titleCtrl, maxLines: 2),
        buildDialogInput('상품 가격 (원)', priceCtrl, type: TextInputType.number),
      ],
      onConfirm: () {
        config.sellerName = sellerCtrl.text;
        config.sellerLocation = locationCtrl.text;
        config.mannerTemp = double.tryParse(mannerCtrl.text) ?? config.mannerTemp;
        config.productTitle = titleCtrl.text;
        config.productPrice = int.tryParse(priceCtrl.text) ?? config.productPrice;
      },
      onUpdated: onUpdated,
    );
  }

  static void editCoupang(BuildContext context, CoupangConfig config, ValueChanged<CoupangConfig> onConfigChanged) {
    final firstProd = config.products.isNotEmpty
        ? config.products.first
        : const CoupangProductItem(
            id: 'p1',
            title: '상품명',
            price: 33900,
            originalPrice: 45000,
            discountPercent: 24,
            rating: 4.8,
            reviewCount: 1200,
            badgeType: RocketBadgeType.rocket,
            deliveryNotice: '내일(토) 새벽 7시 전 도착 보장',
            imageUrl: '',
          );

    final titleCtrl = TextEditingController(text: firstProd.title);
    final priceCtrl = TextEditingController(text: firstProd.price.toString());
    final origPriceCtrl = TextEditingController(text: firstProd.originalPrice.toString());
    final discountCtrl = TextEditingController(text: firstProd.discountPercent.toString());
    final deliveryCtrl = TextEditingController(text: firstProd.deliveryNotice);
    final searchCtrl = TextEditingController(text: config.searchKeyword);

    openQuickEditDialog(
      context: context,
      title: '쿠팡 상품 및 검색어 수정',
      children: [
        buildDialogInput('검색창 키워드', searchCtrl),
        buildDialogInput('메인 상품명', titleCtrl, maxLines: 2),
        buildDialogInput('판매 가격 (원)', priceCtrl, type: TextInputType.number),
        buildDialogInput('정상가 (원)', origPriceCtrl, type: TextInputType.number),
        buildDialogInput('할인율 (%)', discountCtrl, type: TextInputType.number),
        buildDialogInput('도착 예정 안내문', deliveryCtrl),
      ],
      onConfirm: () {
        final newPrice = int.tryParse(priceCtrl.text) ?? firstProd.price;
        final newOrig = int.tryParse(origPriceCtrl.text) ?? firstProd.originalPrice;
        final newDisc = int.tryParse(discountCtrl.text) ?? firstProd.discountPercent;
        final updatedFirst = firstProd.copyWith(
          title: titleCtrl.text,
          price: newPrice,
          originalPrice: newOrig,
          discountPercent: newDisc,
          deliveryNotice: deliveryCtrl.text,
        );
        final list = List<CoupangProductItem>.from(config.products);
        if (list.isNotEmpty) {
          list[0] = updatedFirst;
        } else {
          list.add(updatedFirst);
        }
        onConfigChanged(config.copyWith(searchKeyword: searchCtrl.text, products: list));
      },
    );
  }

  static void editNetflix(BuildContext context, NetflixConfig config, ValueChanged<NetflixConfig> onConfigChanged) {
    final hero = config.heroMedia;
    final titleCtrl = TextEditingController(text: hero.title);
    final taglineCtrl = TextEditingController(text: hero.tagline);
    final descCtrl = TextEditingController(text: hero.description);
    final matchCtrl = TextEditingController(text: hero.matchPercentage.toString());
    final ageCtrl = TextEditingController(text: hero.ageRating);
    final seasonsCtrl = TextEditingController(text: hero.durationOrSeasons);

    openQuickEditDialog(
      context: context,
      title: '넷플릭스 메인 히어로 및 설정 수정',
      children: [
        buildDialogInput('메인 작품 타이틀', titleCtrl),
        buildDialogInput('작품 한 줄 카피 (태그라인)', taglineCtrl),
        buildDialogInput('줄거리 (시놉시스)', descCtrl, maxLines: 3),
        buildDialogInput('일치율 (%) (예: 99)', matchCtrl, type: TextInputType.number),
        buildDialogInput('연령 등급 (19, 15, 12, ALL)', ageCtrl),
        buildDialogInput('시즌 또는 러닝타임 (예: 시즌 3개)', seasonsCtrl),
      ],
      onConfirm: () {
        final match = int.tryParse(matchCtrl.text) ?? hero.matchPercentage;
        final updatedHero = hero.copyWith(
          title: titleCtrl.text,
          tagline: taglineCtrl.text,
          description: descCtrl.text,
          matchPercentage: match,
          ageRating: ageCtrl.text,
          durationOrSeasons: seasonsCtrl.text,
        );
        final top10 = List<NetflixMediaItem>.from(config.top10Series);
        if (top10.isNotEmpty) top10[0] = updatedHero;
        onConfigChanged(config.copyWith(heroMedia: updatedHero, top10Series: top10));
      },
    );
  }
}
