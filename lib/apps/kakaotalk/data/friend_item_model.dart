class KakaoFriend {
  String id;
  String name;
  String statusMessage;
  String? profileImage;
  bool isMe;
  bool isFavorite;
  bool isBirthday;

  KakaoFriend({
    required this.id,
    required this.name,
    this.statusMessage = '',
    this.profileImage,
    this.isMe = false,
    this.isFavorite = false,
    this.isBirthday = false,
  });

  static List<KakaoFriend> defaultFriends() {
    return [
      KakaoFriend(
        id: 'me',
        name: '김토스 (나)',
        statusMessage: '오늘도 파이팅! 🚀',
        isMe: true,
      ),
      KakaoFriend(
        id: '1',
        name: '김철수',
        statusMessage: '열심히 프로젝트 제작 중',
        isFavorite: true,
      ),
      KakaoFriend(
        id: '2',
        name: '이영희',
        statusMessage: '생일축하해 주셔서 감사합니다🎂',
        isFavorite: true,
        isBirthday: true,
      ),
      KakaoFriend(
        id: '3',
        name: '박지민 팀장님',
        statusMessage: '부재 시 문자 남겨주세요',
      ),
      KakaoFriend(
        id: '4',
        name: '최수현 디자이너',
        statusMessage: '피그마 시안 작업 중 🎨',
      ),
    ];
  }
}
