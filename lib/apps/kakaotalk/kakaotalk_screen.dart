import 'package:flutter/material.dart';
import 'data/friend_item_model.dart';
import 'data/kakaotalk_model.dart';
import 'pages/chat_room_page.dart';
import 'pages/chats_page.dart';
import 'pages/friends_page.dart';
import 'pages/more_page.dart';
import 'pages/open_chat_page.dart';
import 'pages/shopping_page.dart';
import 'widgets/kakaotalk_bottom_nav.dart';

class KakaoTalkScreen extends StatefulWidget {
  final KakaoRoomConfig config;
  final Function(KakaoFriend)? onTapFriend;
  final VoidCallback? onTapPay;
  final String? selectedElementId;
  final ValueChanged<String>? onSelectElement;

  const KakaoTalkScreen({
    super.key,
    required this.config,
    this.onTapFriend,
    this.onTapPay,
    this.selectedElementId,
    this.onSelectElement,
  });

  @override
  State<KakaoTalkScreen> createState() => _KakaoTalkScreenState();
}

class _KakaoTalkScreenState extends State<KakaoTalkScreen> {
  @override
  Widget build(BuildContext context) {
    final config = widget.config;

    // 만약 특정 대화방 내부 화면인 경우
    if (config.isInChatRoom) {
      return ChatRoomPage(
        config: config,
        selectedElementId: widget.selectedElementId,
        onSelectElement: widget.onSelectElement,
        onBackToChatList: () {
          setState(() {
            config.isInChatRoom = false;
            config.activeTabIndex = 1; // 채팅 탭으로 돌아감
          });
        },
      );
    }

    // 메인 카카오톡 탭 화면들
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 28), // 상태바 여백

          // 선택된 메인 탭 페이지
          Expanded(
            child: _buildActiveTabContent(config),
          ),

          // 하단 메인 탭바
          KakaoTalkBottomNav(
            activeIndex: config.activeTabIndex,
            totalUnreadChats: config.chatList.fold(0, (sum, item) => sum + item.unreadCount),
            onTabSelected: (index) {
              setState(() {
                config.activeTabIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveTabContent(KakaoRoomConfig config) {
    switch (config.activeTabIndex) {
      case 0:
        return FriendsPage(
          friends: config.friends,
          onTapFriend: widget.onTapFriend,
        );
      case 1:
        return ChatsPage(
          chatList: config.chatList,
          onSelectChatRoom: (selectedChat) {
            setState(() {
              config.roomTitle = selectedChat.roomTitle;
              config.memberCount = selectedChat.memberCount;
              config.isInChatRoom = true;
            });
          },
        );
      case 2:
        return const OpenChatPage();
      case 3:
        return const ShoppingPage();
      case 4:
        return MorePage(
          payBalance: config.kakaoPayBalance,
          onTapPay: widget.onTapPay,
        );
      default:
        return ChatsPage(
          chatList: config.chatList,
          onSelectChatRoom: (_) {},
        );
    }
  }
}
