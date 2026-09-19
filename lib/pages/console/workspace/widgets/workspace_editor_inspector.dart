import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../apps/screen_template.dart';
import '../../../../apps/daangn/data/daangn_model.dart';
import '../../../../apps/daangn/widgets/daangn_edit_dialog.dart';
import '../../../../apps/kakaobank/data/kakaobank_model.dart';
import '../../../../apps/kakaobank/widgets/kakaobank_edit_dialog.dart';
import '../../../../apps/kakaotalk/data/kakaotalk_model.dart';
import '../../../../apps/toss/data/toss_model.dart';
import '../../../../apps/youtube/data/youtube_model.dart';
import '../../../../apps/youtube/widgets/youtube_edit_dialog.dart';
import '../../../../apps/instagram/data/instagram_model.dart';
import '../../../../apps/blind/data/blind_model.dart';
import '../../../../apps/blind/widgets/blind_edit_dialog.dart';
import '../../../../apps/x_twitter/data/x_twitter_model.dart';
import '../../../../apps/steam/data/steam_model.dart';
import '../../../../apps/steam/widgets/steam_edit_dialog.dart';
import '../../../../apps/excel/data/excel_model.dart';
import '../../../../apps/excel/widgets/excel_edit_dialog.dart';
import '../../../../apps/powerpoint/data/powerpoint_model.dart';
import '../../../../apps/powerpoint/widgets/powerpoint_edit_dialog.dart';
import '../../../../apps/word/data/word_model.dart';
import '../../../../apps/word/widgets/word_edit_dialog.dart';
import '../../../../apps/windows_bsod/data/windows_bsod_model.dart';
import '../../../../apps/windows_update/data/windows_update_model.dart';

class WorkspaceEditorInspector extends StatefulWidget {
  final ScreenTemplate template;
  final VoidCallback onOpenInOs;

  // App configs
  final KakaoRoomConfig kakaoConfig;
  final ValueChanged<KakaoRoomConfig> onKakaoChanged;

  final TossConfig tossConfig;
  final ValueChanged<TossConfig> onTossChanged;

  final KakaoBankConfig kakaobankConfig;
  final ValueChanged<KakaoBankConfig> onKakaoBankChanged;

  final DaangnConfig daangnConfig;
  final ValueChanged<DaangnConfig> onDaangnChanged;

  final YoutubeConfig youtubeConfig;
  final ValueChanged<YoutubeConfig> onYoutubeChanged;

  final InstagramConfig instaConfig;
  final ValueChanged<InstagramConfig> onInstaChanged;

  final XTwitterConfig twitterConfig;
  final ValueChanged<XTwitterConfig> onTwitterChanged;

  final BlindConfig blindConfig;
  final ValueChanged<BlindConfig> onBlindChanged;

  final SteamConfig steamConfig;
  final ValueChanged<SteamConfig> onSteamChanged;

  final ExcelConfig excelConfig;
  final ValueChanged<ExcelConfig> onExcelChanged;

  final PowerPointConfig powerpointConfig;
  final ValueChanged<PowerPointConfig> onPowerPointChanged;

  final WordConfig wordConfig;
  final ValueChanged<WordConfig> onWordChanged;

  final WindowsBsodConfig bsodConfig;
  final ValueChanged<WindowsBsodConfig> onBsodChanged;

  final WindowsUpdateConfig winUpdateConfig;
  final ValueChanged<WindowsUpdateConfig> onWinUpdateChanged;
  final bool isDarkMode;

  const WorkspaceEditorInspector({
    super.key,
    required this.template,
    required this.onOpenInOs,
    required this.isDarkMode,
    required this.kakaoConfig,
    required this.onKakaoChanged,
    required this.tossConfig,
    required this.onTossChanged,
    required this.kakaobankConfig,
    required this.onKakaoBankChanged,
    required this.daangnConfig,
    required this.onDaangnChanged,
    required this.youtubeConfig,
    required this.onYoutubeChanged,
    required this.instaConfig,
    required this.onInstaChanged,
    required this.twitterConfig,
    required this.onTwitterChanged,
    required this.blindConfig,
    required this.onBlindChanged,
    required this.steamConfig,
    required this.onSteamChanged,
    required this.excelConfig,
    required this.onExcelChanged,
    required this.powerpointConfig,
    required this.onPowerPointChanged,
    required this.wordConfig,
    required this.onWordChanged,
    required this.bsodConfig,
    required this.onBsodChanged,
    required this.winUpdateConfig,
    required this.onWinUpdateChanged,
  });

  @override
  State<WorkspaceEditorInspector> createState() => _WorkspaceEditorInspectorState();
}

class _WorkspaceEditorInspectorState extends State<WorkspaceEditorInspector> {
  final TextEditingController _newKakaoMsgCtrl = TextEditingController();
  bool _newKakaoIsMe = true;

  bool get isDark => widget.isDarkMode;
  Color get textColor => isDark ? Colors.white : const Color(0xFF0F172A);
  Color get textSubColor => isDark ? Colors.white54 : const Color(0xFF64748B);

  @override
  void dispose() {
    _newKakaoMsgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.template;
    final bgColor = isDark ? const Color(0xFF0F1219) : Colors.white;
    final headerBgColor = isDark ? const Color(0xFF141822) : const Color(0xFFF8FAFC);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);

    return Container(
      width: 330,
      decoration: BoxDecoration(
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.03),
            blurRadius: 10,
            offset: const Offset(-2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. Inspector Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: headerBgColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: t.themeColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: t.themeColor.withValues(alpha: 0.6), blurRadius: 6),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        t.title,
                        style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        t.isDesktop ? 'DESKTOP' : 'MOBILE',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF475569),
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  t.description,
                  style: TextStyle(color: textSubColor, fontSize: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // Quick Action: Open in OS Window (NO OUTLINE)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFE0F2FE),
                      foregroundColor: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0284C7),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                    ),
                    icon: const Icon(CupertinoIcons.macwindow, size: 14),
                    label: const Text('가상 OS 창으로 실행하기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    onPressed: widget.onOpenInOs,
                  ),
                ),
              ],
            ),
          ),

          // 2. Scrollable App-Specific Form Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAppSpecificEditor(),
                const SizedBox(height: 20),
                _buildModalEditorButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSpecificEditor() {
    final id = widget.template.id;

    switch (id) {
      case 'kakaotalk':
        return _buildKakaoEditor();
      case 'toss':
        return _buildTossEditor();
      case 'kakaobank':
        return _buildKakaoBankEditor();
      case 'daangn':
        return _buildDaangnEditor();
      case 'youtube':
        return _buildYoutubeEditor();
      case 'instagram':
        return _buildInstagramEditor();
      case 'x_twitter':
        return _buildTwitterEditor();
      case 'blind':
        return _buildBlindEditor();
      case 'steam':
        return _buildSteamEditor();
      case 'excel':
        return _buildExcelEditor();
      case 'powerpoint':
        return _buildPowerpointEditor();
      case 'word':
        return _buildWordEditor();
      case 'windows_bsod':
        return _buildBsodEditor();
      case 'windows_update':
        return _buildWinUpdateEditor();
      default:
        return _buildGenericEditor();
    }
  }

  // ============================================================
  // KakaoTalk Editor
  // ============================================================
  Widget _buildKakaoEditor() {
    final cfg = widget.kakaoConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('대화방 기본 설정'),
        _buildTextField('대화방 / 상대방 이름', cfg.roomTitle, (val) {
          setState(() {
            cfg.roomTitle = val;
            cfg.partnerProfileName = val;
          });
          widget.onKakaoChanged(cfg);
        }),
        _buildTextField('상태바 시간', cfg.statusBarTime, (val) {
          setState(() => cfg.statusBarTime = val);
          widget.onKakaoChanged(cfg);
        }),
        _buildSliderField('배터리 잔량 (%)', cfg.batteryLevel.toDouble(), 1, 100, (val) {
          setState(() => cfg.batteryLevel = val.toInt());
          widget.onKakaoChanged(cfg);
        }),
        _buildSwitchField('다크 테마 적용', cfg.isDarkTheme, (val) {
          setState(() => cfg.isDarkTheme = val);
          widget.onKakaoChanged(cfg);
        }),
        _buildTextField('카카오페이 잔액 (원)', cfg.kakaoPayBalance.toString(), (val) {
          setState(() => cfg.kakaoPayBalance = int.tryParse(val) ?? cfg.kakaoPayBalance);
          widget.onKakaoChanged(cfg);
        }, isNumber: true),

        const SizedBox(height: 16),
        _buildSectionHeader('실시간 메시지 전송 / 추가'),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('내가 보냄')),
                selected: _newKakaoIsMe,
                side: BorderSide.none,
                selectedColor: const Color(0xFF6366F1),
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: _newKakaoIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (val) => setState(() => _newKakaoIsMe = true),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ChoiceChip(
                label: const Center(child: Text('상대방이 보냄')),
                selected: !_newKakaoIsMe,
                side: BorderSide.none,
                selectedColor: const Color(0xFF6366F1),
                backgroundColor: isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFF1F5F9),
                labelStyle: TextStyle(
                  color: !_newKakaoIsMe ? Colors.white : (isDark ? Colors.white70 : const Color(0xFF475569)),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (val) => setState(() => _newKakaoIsMe = false),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _newKakaoMsgCtrl,
                style: TextStyle(color: textColor, fontSize: 12.5),
                decoration: InputDecoration(
                  hintText: '메시지 내용 입력...',
                  hintStyle: TextStyle(color: textSubColor.withValues(alpha: 0.6), fontSize: 12),
                  filled: true,
                  fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: Colors.black,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final txt = _newKakaoMsgCtrl.text.trim();
                if (txt.isEmpty) return;
                setState(() {
                  cfg.messages.add(
                    KakaoMessage(
                      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
                      senderName: _newKakaoIsMe ? '나' : cfg.partnerProfileName,
                      isMe: _newKakaoIsMe,
                      text: txt,
                      time: cfg.statusBarTime,
                      unreadCount: _newKakaoIsMe ? 1 : 0,
                    ),
                  );
                  _newKakaoMsgCtrl.clear();
                });
                widget.onKakaoChanged(cfg);
              },
              child: const Text('추가', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // Toss Editor
  // ============================================================
  Widget _buildTossEditor() {
    final cfg = widget.tossConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('토스 송금 & 계좌 설정'),
        _buildTextField('송금 금액 (원)', cfg.sendAmount.toString(), (val) {
          setState(() {
            cfg.sendAmount = int.tryParse(val) ?? cfg.sendAmount;
            cfg.completionMessage = '${cfg.receiverName}님에게 ${cfg.sendAmount}원을 보냈어요';
          });
          widget.onTossChanged(cfg);
        }, isNumber: true),
        _buildTextField('받는 사람 이름', cfg.receiverName, (val) {
          setState(() {
            cfg.receiverName = val;
            cfg.completionMessage = '$val님에게 ${cfg.sendAmount}원을 보냈어요';
          });
          widget.onTossChanged(cfg);
        }),
        _buildTextField('내 통장 이름', cfg.bankName, (val) {
          setState(() => cfg.bankName = val);
          widget.onTossChanged(cfg);
        }),
        _buildTextField('계좌 번호', cfg.accountNumber, (val) {
          setState(() => cfg.accountNumber = val);
          widget.onTossChanged(cfg);
        }),
        _buildTextField('출금 후 잔액 (원)', cfg.balance.toString(), (val) {
          setState(() => cfg.balance = int.tryParse(val) ?? cfg.balance);
          widget.onTossChanged(cfg);
        }, isNumber: true),
        _buildTextField('거래 시간', cfg.transactionTime, (val) {
          setState(() => cfg.transactionTime = val);
          widget.onTossChanged(cfg);
        }),
        _buildSwitchField('다크 테마 적용', cfg.isDarkTheme, (val) {
          setState(() => cfg.isDarkTheme = val);
          widget.onTossChanged(cfg);
        }),
      ],
    );
  }

  // ============================================================
  // KakaoBank Editor
  // ============================================================
  Widget _buildKakaoBankEditor() {
    final cfg = widget.kakaobankConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('카카오뱅크 잔액 & 통장 설정'),
        _buildTextField('사용자 이름', cfg.userName, (val) {
          setState(() => cfg.userName = val);
          widget.onKakaoBankChanged(cfg);
        }),
        _buildTextField('통장 이름', cfg.accountName, (val) {
          setState(() => cfg.accountName = val);
          widget.onKakaoBankChanged(cfg);
        }),
        _buildTextField('계좌 번호', cfg.accountNumber, (val) {
          setState(() => cfg.accountNumber = val);
          widget.onKakaoBankChanged(cfg);
        }),
        _buildTextField('통장 잔액 (원)', cfg.balance.toString(), (val) {
          setState(() => cfg.balance = int.tryParse(val) ?? cfg.balance);
          widget.onKakaoBankChanged(cfg);
        }, isNumber: true),
        _buildTextField('세이프박스 잔액 (원)', cfg.safeBoxBalance.toString(), (val) {
          setState(() => cfg.safeBoxBalance = int.tryParse(val) ?? cfg.safeBoxBalance);
          widget.onKakaoBankChanged(cfg);
        }, isNumber: true),
      ],
    );
  }

  // ============================================================
  // Daangn Editor
  // ============================================================
  Widget _buildDaangnEditor() {
    final cfg = widget.daangnConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('당근마켓 상품 & 판매자 설정'),
        _buildTextField('상품명', cfg.productTitle, (val) {
          setState(() => cfg.productTitle = val);
          widget.onDaangnChanged(cfg);
        }),
        _buildTextField('판매 가격 (원)', cfg.productPrice.toString(), (val) {
          setState(() => cfg.productPrice = int.tryParse(val) ?? cfg.productPrice);
          widget.onDaangnChanged(cfg);
        }, isNumber: true),
        _buildTextField('판매자 닉네임', cfg.sellerName, (val) {
          setState(() => cfg.sellerName = val);
          widget.onDaangnChanged(cfg);
        }),
        _buildTextField('동네 (지역명)', cfg.sellerLocation, (val) {
          setState(() => cfg.sellerLocation = val);
          widget.onDaangnChanged(cfg);
        }),
        _buildSliderField('매너온도 (°C)', cfg.mannerTemp, 20.0, 99.0, (val) {
          setState(() => cfg.mannerTemp = double.parse(val.toStringAsFixed(1)));
          widget.onDaangnChanged(cfg);
        }),
        _buildDropdownField('거래 상태', cfg.tradeStatus, ['판매중', '예약중', '거래완료'], (val) {
          if (val != null) {
            setState(() => cfg.tradeStatus = val);
            widget.onDaangnChanged(cfg);
          }
        }),
      ],
    );
  }

  // ============================================================
  // YouTube Editor
  // ============================================================
  Widget _buildYoutubeEditor() {
    final cfg = widget.youtubeConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('유튜브 영상 & 채널 설정'),
        _buildTextField('영상 제목', cfg.title, (val) {
          setState(() => cfg.title = val);
          widget.onYoutubeChanged(cfg);
        }),
        _buildTextField('채널 이름', cfg.channelName, (val) {
          setState(() => cfg.channelName = val);
          widget.onYoutubeChanged(cfg);
        }),
        _buildTextField('구독자 수 문구', cfg.subscriberCount, (val) {
          setState(() => cfg.subscriberCount = val);
          widget.onYoutubeChanged(cfg);
        }),
        _buildTextField('조회수', cfg.viewCount, (val) {
          setState(() => cfg.viewCount = val);
          widget.onYoutubeChanged(cfg);
        }),
        _buildTextField('좋아요 수', cfg.likeCount, (val) {
          setState(() => cfg.likeCount = val);
          widget.onYoutubeChanged(cfg);
        }),
      ],
    );
  }

  // ============================================================
  // Instagram Editor
  // ============================================================
  Widget _buildInstagramEditor() {
    final cfg = widget.instaConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('인스타그램 피드 설정'),
        _buildTextField('사용자 ID', cfg.username, (val) {
          setState(() => cfg.username = val);
          widget.onInstaChanged(cfg);
        }),
        _buildTextField('좋아요 문구', cfg.likes, (val) {
          setState(() => cfg.likes = val);
          widget.onInstaChanged(cfg);
        }),
        _buildTextField('본문 캡션', cfg.caption, (val) {
          setState(() => cfg.caption = val);
          widget.onInstaChanged(cfg);
        }, maxLines: 3),
        _buildTextField('위치 태그', cfg.location, (val) {
          setState(() => cfg.location = val);
          widget.onInstaChanged(cfg);
        }),
        _buildTextField('댓글 수', cfg.commentCount.toString(), (val) {
          setState(() => cfg.commentCount = int.tryParse(val) ?? cfg.commentCount);
          widget.onInstaChanged(cfg);
        }, isNumber: true),
      ],
    );
  }

  // ============================================================
  // Twitter (X) Editor
  // ============================================================
  Widget _buildTwitterEditor() {
    final cfg = widget.twitterConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('X (트위터) 포스트 설정'),
        _buildTextField('표시 이름', cfg.displayName, (val) {
          setState(() => cfg.displayName = val);
          widget.onTwitterChanged(cfg);
        }),
        _buildTextField('핸들 (@아이디)', cfg.username, (val) {
          setState(() => cfg.username = val);
          widget.onTwitterChanged(cfg);
        }),
        _buildTextField('포스트 내용', cfg.tweetText, (val) {
          setState(() => cfg.tweetText = val);
          widget.onTwitterChanged(cfg);
        }, maxLines: 3),
        _buildSwitchField('블루 인증 마크', cfg.isVerified, (val) {
          setState(() => cfg.isVerified = val);
          widget.onTwitterChanged(cfg);
        }),
        _buildTextField('재게시 (리트윗) 수', cfg.retweets, (val) {
          setState(() => cfg.retweets = val);
          widget.onTwitterChanged(cfg);
        }),
        _buildTextField('마음에 들어요 (좋아요) 수', cfg.likes, (val) {
          setState(() => cfg.likes = val);
          widget.onTwitterChanged(cfg);
        }),
      ],
    );
  }

  // ============================================================
  // Blind Editor
  // ============================================================
  Widget _buildBlindEditor() {
    final cfg = widget.blindConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('블라인드 게시글 설정'),
        _buildTextField('회사명', cfg.currentPost.authorCompany, (val) {
          final updated = cfg.copyWith(
            currentPost: cfg.currentPost.copyWith(authorCompany: val),
          );
          widget.onBlindChanged(updated);
        }),
        _buildTextField('글 제목', cfg.currentPost.title, (val) {
          final updated = cfg.copyWith(
            currentPost: cfg.currentPost.copyWith(title: val),
          );
          widget.onBlindChanged(updated);
        }),
        _buildTextField('글 본문', cfg.currentPost.content, (val) {
          final updated = cfg.copyWith(
            currentPost: cfg.currentPost.copyWith(content: val),
          );
          widget.onBlindChanged(updated);
        }, maxLines: 3),
        _buildTextField('좋아요 수', cfg.currentPost.likeCount.toString(), (val) {
          final count = int.tryParse(val) ?? cfg.currentPost.likeCount;
          final updated = cfg.copyWith(
            currentPost: cfg.currentPost.copyWith(likeCount: count),
          );
          widget.onBlindChanged(updated);
        }, isNumber: true),
        _buildTextField('댓글 수', cfg.currentPost.commentCount.toString(), (val) {
          final count = int.tryParse(val) ?? cfg.currentPost.commentCount;
          final updated = cfg.copyWith(
            currentPost: cfg.currentPost.copyWith(commentCount: count),
          );
          widget.onBlindChanged(updated);
        }, isNumber: true),
      ],
    );
  }

  // ============================================================
  // Steam Editor
  // ============================================================
  // Steam Editor
  // ============================================================
  Widget _buildSteamEditor() {
    final cfg = widget.steamConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('스팀 사용자 & 지갑 설정'),
        _buildTextField('사용자 계정명', cfg.username, (val) {
          final updated = cfg.copyWith(username: val);
          widget.onSteamChanged(updated);
        }),
        _buildTextField('지갑 잔액', cfg.walletBalance, (val) {
          final updated = cfg.copyWith(walletBalance: val);
          widget.onSteamChanged(updated);
        }),
        _buildTextField('알림 개수', cfg.notificationCount.toString(), (val) {
          final count = int.tryParse(val) ?? cfg.notificationCount;
          final updated = cfg.copyWith(notificationCount: count);
          widget.onSteamChanged(updated);
        }, isNumber: true),
        if (cfg.activeToast != null) ...[
          _buildTextField('도전과제 알림 타이틀', cfg.activeToast!.title, (val) {
            final updated = cfg.copyWith(
              activeToast: SteamToastData(
                title: val,
                subtitle: cfg.activeToast!.subtitle,
                type: cfg.activeToast!.type,
              ),
            );
            widget.onSteamChanged(updated);
          }),
          _buildTextField('도전과제 내용', cfg.activeToast!.subtitle, (val) {
            final updated = cfg.copyWith(
              activeToast: SteamToastData(
                title: cfg.activeToast!.title,
                subtitle: val,
                type: cfg.activeToast!.type,
              ),
            );
            widget.onSteamChanged(updated);
          }),
        ],
      ],
    );
  }

  // ============================================================
  // Office Editors (Excel, PowerPoint, Word)
  // ============================================================
  Widget _buildExcelEditor() {
    final cfg = widget.excelConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('엑셀 스프레드시트 설정'),
        _buildTextField('문서 파일명', cfg.fileName, (val) {
          cfg.fileName = val;
          widget.onExcelChanged(cfg);
        }),
        _buildTextField('작성자', cfg.author, (val) {
          cfg.author = val;
          widget.onExcelChanged(cfg);
        }),
        _buildTextField('수식 내용', cfg.formulaText, (val) {
          cfg.formulaText = val;
          widget.onExcelChanged(cfg);
        }),
        _buildTextField('합계 금액 표기', cfg.sumText, (val) {
          cfg.sumText = val;
          widget.onExcelChanged(cfg);
        }),
      ],
    );
  }

  Widget _buildPowerpointEditor() {
    final cfg = widget.powerpointConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('파워포인트 프리젠테이션 설정'),
        _buildTextField('프리젠테이션 제목', cfg.presentationTitle, (val) {
          cfg.presentationTitle = val;
          widget.onPowerPointChanged(cfg);
        }),
        _buildTextField('작성자', cfg.author, (val) {
          cfg.author = val;
          widget.onPowerPointChanged(cfg);
        }),
      ],
    );
  }

  Widget _buildWordEditor() {
    final cfg = widget.wordConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('워드 문서 설정'),
        _buildTextField('문서 제목', cfg.documentTitle, (val) {
          cfg.documentTitle = val;
          widget.onWordChanged(cfg);
        }),
        _buildTextField('문서 관리 번호', cfg.documentCode, (val) {
          cfg.documentCode = val;
          widget.onWordChanged(cfg);
        }),
        _buildTextField('담당 부서', cfg.department, (val) {
          cfg.department = val;
          widget.onWordChanged(cfg);
        }),
        _buildTextField('작성자', cfg.author, (val) {
          cfg.author = val;
          widget.onWordChanged(cfg);
        }),
      ],
    );
  }

  // ============================================================
  // Windows BSOD & Update Editors
  // ============================================================
  Widget _buildBsodEditor() {
    final cfg = widget.bsodConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('블루스크린 (BSOD) 설정'),
        _buildTextField('중지 코드 (Stop Code)', cfg.stopCode, (val) {
          cfg.stopCode = val;
          widget.onBsodChanged(cfg);
        }),
        _buildTextField('실패한 항목 (What Failed)', cfg.whatFailed, (val) {
          cfg.whatFailed = val;
          widget.onBsodChanged(cfg);
        }),
        _buildSliderField('진행률 (%)', cfg.percentage.toDouble(), 0, 100, (val) {
          cfg.percentage = val.toInt();
          widget.onBsodChanged(cfg);
        }),
      ],
    );
  }

  Widget _buildWinUpdateEditor() {
    final cfg = widget.winUpdateConfig;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('가짜 윈도우 업데이트 설정'),
        _buildSliderField('진행 퍼센트 (%)', cfg.progress.toDouble(), 0, 100, (val) {
          cfg.progress = val.toInt();
          widget.onWinUpdateChanged(cfg);
        }),
        _buildTextField('업데이트 기본 문구', cfg.primaryMessage, (val) {
          cfg.primaryMessage = val;
          widget.onWinUpdateChanged(cfg);
        }),
      ],
    );
  }

  Widget _buildGenericEditor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('앱 에디터'),
        Text(
          '${widget.template.title}의 세부 데이터와 콘텐츠를 터치하거나 아래 상세 편집 모달을 통해 변경할 수 있습니다.',
          style: const TextStyle(color: Colors.white54, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }

  // ============================================================
  // Bottom Modal Editor Trigger Button
  // ============================================================
  Widget _buildModalEditorButton() {
    final id = widget.template.id;
    final isDark = widget.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(CupertinoIcons.slider_horizontal_3, size: 14, color: Color(0xFF6366F1)),
              const SizedBox(width: 6),
              Text(
                '세부 모달 편집기',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '더 많은 옵션과 세부 스타일을 풀스크린 모달 다이얼로그로 정밀하게 조정할 수 있습니다.',
            style: TextStyle(
              color: isDark ? Colors.white54 : const Color(0xFF64748B),
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF6366F1).withValues(alpha: 0.2) : const Color(0xFF6366F1),
                foregroundColor: isDark ? const Color(0xFFA5B4FC) : Colors.white,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 9),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _openSpecificEditDialog(id),
              child: const Text('상세 편집창 열기', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _openSpecificEditDialog(String templateId) {
    if (templateId == 'daangn') {
      DaangnEditDialog.show(context, widget.daangnConfig, (cfg) {
        setState(() {});
        widget.onDaangnChanged(cfg);
      });
    } else if (templateId == 'kakaobank') {
      KakaoBankEditDialog.show(context, widget.kakaobankConfig, (cfg) {
        setState(() {});
        widget.onKakaoBankChanged(cfg);
      });
    } else if (templateId == 'youtube') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => YouTubeEditDialog(
          config: widget.youtubeConfig,
          onApply: (cfg) {
            setState(() {});
            widget.onYoutubeChanged(cfg);
          },
        ),
      );
    } else if (templateId == 'blind') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => BlindEditDialog(
          post: widget.blindConfig.currentPost,
          onSave: (post) {
            setState(() {});
            final updated = widget.blindConfig.copyWith(currentPost: post);
            widget.onBlindChanged(updated);
          },
        ),
      );
    } else if (templateId == 'steam') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SteamEditDialog(
          config: widget.steamConfig,
          onSave: (cfg) {
            setState(() {});
            widget.onSteamChanged(cfg);
          },
          onTriggerToast: (t, s, tp) {},
        ),
      );
    } else if (templateId == 'excel') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ExcelEditDialog(
          config: widget.excelConfig,
          onApply: (cfg) {
            setState(() {});
            widget.onExcelChanged(cfg);
          },
        ),
      );
    } else if (templateId == 'powerpoint') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => PowerPointEditDialog(
          config: widget.powerpointConfig,
          onApply: (cfg) {
            setState(() {});
            widget.onPowerPointChanged(cfg);
          },
        ),
      );
    } else if (templateId == 'word') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => WordEditDialog(
          config: widget.wordConfig,
          onApply: (cfg) {
            setState(() {});
            widget.onWordChanged(cfg);
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.template.title} 화면의 요소를 직접 터치하여 편집할 수 있습니다.'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ============================================================
  // Reusable UI Builder Helpers
  // ============================================================
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6366F1),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String initialVal, ValueChanged<String> onChanged, {bool isNumber = false, int maxLines = 1}) {
    final isDark = widget.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            initialValue: initialVal,
            maxLines: maxLines,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12.5),
            decoration: InputDecoration(
              filled: true,
              fillColor: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderField(String label, double value, double min, double max, ValueChanged<double> onChanged) {
    final isDark = widget.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white70 : const Color(0xFF475569),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${value.toInt()}',
                style: const TextStyle(color: Color(0xFF6366F1), fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              activeColor: const Color(0xFF6366F1),
              inactiveColor: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchField(String label, bool value, ValueChanged<bool> onChanged) {
    final isDark = widget.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          CupertinoSwitch(
            value: value,
            activeTrackColor: const Color(0xFF6366F1),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    final isDark = widget.isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white70 : const Color(0xFF475569),
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                dropdownColor: isDark ? const Color(0xFF1B202D) : Colors.white,
                style: TextStyle(color: isDark ? Colors.white : const Color(0xFF0F172A), fontSize: 12.5),
                items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
