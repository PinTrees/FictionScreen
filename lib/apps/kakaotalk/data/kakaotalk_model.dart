import 'package:flutter/material.dart';
import 'chat_list_item_model.dart';
import 'friend_item_model.dart';

class KakaoMessage {
  String id;
  String senderName;
  bool isMe;
  String text;
  String time;
  bool showTime;
  bool showProfile;
  int unreadCount; // 1이면 '1', 0이면 표시 안함
  String? imageUrl;

  KakaoMessage({
    required this.id,
    required this.senderName,
    required this.isMe,
    required this.text,
    required this.time,
    this.showTime = true,
    this.showProfile = true,
    this.unreadCount = 1,
    this.imageUrl,
  });

  KakaoMessage copyWith({
    String? id,
    String? senderName,
    bool? isMe,
    String? text,
    String? time,
    bool? showTime,
    bool? showProfile,
    int? unreadCount,
    String? imageUrl,
  }) {
    return KakaoMessage(
      id: id ?? this.id,
      senderName: senderName ?? this.senderName,
      isMe: isMe ?? this.isMe,
      text: text ?? this.text,
      time: time ?? this.time,
      showTime: showTime ?? this.showTime,
      showProfile: showProfile ?? this.showProfile,
      unreadCount: unreadCount ?? this.unreadCount,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class KakaoRoomConfig {
  String roomTitle;
  int memberCount; // 0이면 1:1 대화, >2이면 단톡방
  String statusBarTime;
  int batteryLevel;
  String networkType; // '5G', 'LTE', 'Wi-Fi'
  bool isDarkTheme;
  Color? customBgColor;
  bool showNotice;
  String noticeText;
  String inputText;
  String partnerProfileName;
  String? partnerProfileImage;
  List<KakaoMessage> messages;

  // 탭 상태 및 서브 페이지들 데이터
  int activeTabIndex; // 0: 친구, 1: 채팅, 2: 오픈채팅, 3: 쇼핑, 4: 더보기
  bool isInChatRoom; // 특정 대화방 내부 들어와 있는지 여부
  List<KakaoFriend> friends;
  List<KakaoChatListItem> chatList;
  int kakaoPayBalance;

  KakaoRoomConfig({
    this.roomTitle = '김철수',
    this.memberCount = 0,
    this.statusBarTime = '오후 2:30',
    this.batteryLevel = 85,
    this.networkType = '5G',
    this.isDarkTheme = false,
    this.customBgColor,
    this.showNotice = false,
    this.noticeText = '공지사항: 이번 주 프로젝트 마감일은 금요일입니다.',
    this.inputText = '',
    this.partnerProfileName = '김철수',
    this.partnerProfileImage,
    required this.messages,
    this.activeTabIndex = 1, // 기본: 채팅 탭
    this.isInChatRoom = true, // 기본: 대화방 뷰
    required this.friends,
    required this.chatList,
    this.kakaoPayBalance = 248000,
  });

  static KakaoRoomConfig defaultPreset() {
    return KakaoRoomConfig(
      roomTitle: '김철수',
      memberCount: 0,
      statusBarTime: '오후 2:30',
      batteryLevel: 82,
      networkType: '5G',
      partnerProfileName: '김철수',
      activeTabIndex: 1,
      isInChatRoom: true,
      friends: KakaoFriend.defaultFriends(),
      chatList: KakaoChatListItem.defaultChats(),
      kakaoPayBalance: 248000,
      messages: [
        KakaoMessage(
          id: '1',
          senderName: '김철수',
          isMe: false,
          text: '혹시 오늘 그 자료 다 끝났어?',
          time: '오후 2:28',
          unreadCount: 0,
        ),
        KakaoMessage(
          id: '2',
          senderName: '나',
          isMe: true,
          text: '응 방금 메일로 보냈어! 확인해봐',
          time: '오후 2:29',
          unreadCount: 0,
        ),
        KakaoMessage(
          id: '3',
          senderName: '김철수',
          isMe: false,
          text: '대박 빠르네 ㅋㅋㅋ 진짜 고맙다!!',
          time: '오후 2:30',
          unreadCount: 0,
        ),
        KakaoMessage(
          id: '4',
          senderName: '나',
          isMe: true,
          text: '별말을 다 하네~ 이따 밥이나 먹자',
          time: '오후 2:30',
          unreadCount: 1, // 안읽음 1
        ),
      ],
    );
  }
}
