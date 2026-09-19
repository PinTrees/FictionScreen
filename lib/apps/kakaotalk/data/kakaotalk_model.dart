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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderName': senderName,
      'isMe': isMe,
      'text': text,
      'time': time,
      'showTime': showTime,
      'showProfile': showProfile,
      'unreadCount': unreadCount,
      'imageUrl': imageUrl,
    };
  }

  factory KakaoMessage.fromMap(Map<String, dynamic> map) {
    return KakaoMessage(
      id: map['id']?.toString() ?? 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderName: map['senderName']?.toString() ?? '',
      isMe: map['isMe'] == true,
      text: map['text']?.toString() ?? '',
      time: map['time']?.toString() ?? '오후 2:30',
      showTime: map['showTime'] != false,
      showProfile: map['showProfile'] != false,
      unreadCount: (map['unreadCount'] as num?)?.toInt() ?? 0,
      imageUrl: map['imageUrl']?.toString(),
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

  Map<String, dynamic> toMap() {
    return {
      'roomTitle': roomTitle,
      'memberCount': memberCount,
      'statusBarTime': statusBarTime,
      'batteryLevel': batteryLevel,
      'networkType': networkType,
      'isDarkTheme': isDarkTheme,
      'customBgColor': customBgColor?.toARGB32(),
      'showNotice': showNotice,
      'noticeText': noticeText,
      'inputText': inputText,
      'partnerProfileName': partnerProfileName,
      'partnerProfileImage': partnerProfileImage,
      'kakaoPayBalance': kakaoPayBalance,
      'messages': messages.map((m) => m.toMap()).toList(),
    };
  }

  factory KakaoRoomConfig.fromMap(Map<String, dynamic> map) {
    final preset = KakaoRoomConfig.defaultPreset();
    Color? customBg;
    if (map['customBgColor'] != null) {
      customBg = Color((map['customBgColor'] as num).toInt());
    }
    List<KakaoMessage> msgs = preset.messages;
    if (map['messages'] is List) {
      msgs = (map['messages'] as List)
          .map((item) => KakaoMessage.fromMap(Map<String, dynamic>.from(item as Map)))
          .toList();
    }
    return KakaoRoomConfig(
      roomTitle: map['roomTitle']?.toString() ?? preset.roomTitle,
      memberCount: (map['memberCount'] as num?)?.toInt() ?? preset.memberCount,
      statusBarTime: map['statusBarTime']?.toString() ?? preset.statusBarTime,
      batteryLevel: (map['batteryLevel'] as num?)?.toInt() ?? preset.batteryLevel,
      networkType: map['networkType']?.toString() ?? preset.networkType,
      isDarkTheme: map['isDarkTheme'] == true,
      customBgColor: customBg,
      showNotice: map['showNotice'] == true,
      noticeText: map['noticeText']?.toString() ?? preset.noticeText,
      inputText: map['inputText']?.toString() ?? preset.inputText,
      partnerProfileName: map['partnerProfileName']?.toString() ?? preset.partnerProfileName,
      partnerProfileImage: map['partnerProfileImage']?.toString(),
      kakaoPayBalance: (map['kakaoPayBalance'] as num?)?.toInt() ?? preset.kakaoPayBalance,
      friends: preset.friends,
      chatList: preset.chatList,
      messages: msgs,
    );
  }
}
