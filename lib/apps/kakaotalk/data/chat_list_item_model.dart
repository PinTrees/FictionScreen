class KakaoChatListItem {
  String id;
  String roomTitle;
  String lastMessage;
  String lastTime;
  int unreadCount;
  int memberCount;
  bool isGroup;
  String? profileImage;

  KakaoChatListItem({
    required this.id,
    required this.roomTitle,
    required this.lastMessage,
    required this.lastTime,
    this.unreadCount = 0,
    this.memberCount = 0,
    this.isGroup = false,
    this.profileImage,
  });

  static List<KakaoChatListItem> defaultChats() {
    return [
      KakaoChatListItem(
        id: 'kakaotalk',
        roomTitle: '김철수',
        lastMessage: '별말을 다 하네~ 이따 밥이나 먹자',
        lastTime: '오후 2:30',
        unreadCount: 1,
      ),
      KakaoChatListItem(
        id: 'chat_2',
        roomTitle: '픽션스토어 개발팀',
        lastMessage: '최수현: 디자인 수정건 피그마에 올렸습니다!',
        lastTime: '오후 1:15',
        unreadCount: 5,
        memberCount: 6,
        isGroup: true,
      ),
      KakaoChatListItem(
        id: 'chat_3',
        roomTitle: '이영희',
        lastMessage: '선물 고마워 잘 쓸게!! 🎁',
        lastTime: '어제',
        unreadCount: 0,
      ),
      KakaoChatListItem(
        id: 'chat_4',
        roomTitle: '플러터 스터디 15기',
        lastMessage: '이번 주 스터디 장소 공유드립니다.',
        lastTime: '9월 16일',
        unreadCount: 0,
        memberCount: 12,
        isGroup: true,
      ),
    ];
  }
}
