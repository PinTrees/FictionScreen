import 'package:flutter/material.dart';

enum SteamFriendStatus {
  inGame('게임 중', Color(0xFF90BA3C)),
  online('온라인', Color(0xFF57CBDE)),
  away('자리 비움', Color(0xFFFFB84D)),
  offline('오프라인', Color(0xFF898989));

  final String label;
  final Color color;
  const SteamFriendStatus(this.label, this.color);
}

class SteamAchievement {
  final String id;
  final String title;
  final String description;
  final bool isUnlocked;
  final String? unlockedDate;
  final double rarityPercent; // 0 ~ 100

  const SteamAchievement({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = true,
    this.unlockedDate,
    this.rarityPercent = 14.5,
  });

  SteamAchievement copyWith({
    String? id,
    String? title,
    String? description,
    bool? isUnlocked,
    String? unlockedDate,
    double? rarityPercent,
  }) {
    return SteamAchievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
      rarityPercent: rarityPercent ?? this.rarityPercent,
    );
  }
}

class SteamGame {
  final String id;
  final String title;
  final String category; // '즐겨찾기' or '모든 게임'
  final double hoursPlayed;
  final String lastPlayed;
  final bool isInstalled;
  final bool isRunning;
  final Color themeColor;
  final String heroBannerType; // cyberpunk, elden, pubg, wukong, monster_hunter, palworld, cs2
  final List<SteamAchievement> achievements;

  const SteamGame({
    required this.id,
    required this.title,
    required this.category,
    required this.hoursPlayed,
    required this.lastPlayed,
    this.isInstalled = true,
    this.isRunning = false,
    required this.themeColor,
    required this.heroBannerType,
    required this.achievements,
  });

  int get unlockedAchievementsCount =>
      achievements.where((a) => a.isUnlocked).length;

  SteamGame copyWith({
    String? id,
    String? title,
    String? category,
    double? hoursPlayed,
    String? lastPlayed,
    bool? isInstalled,
    bool? isRunning,
    Color? themeColor,
    String? heroBannerType,
    List<SteamAchievement>? achievements,
  }) {
    return SteamGame(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      hoursPlayed: hoursPlayed ?? this.hoursPlayed,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      isInstalled: isInstalled ?? this.isInstalled,
      isRunning: isRunning ?? this.isRunning,
      themeColor: themeColor ?? this.themeColor,
      heroBannerType: heroBannerType ?? this.heroBannerType,
      achievements: achievements ?? this.achievements,
    );
  }
}

class SteamFriend {
  final String id;
  final String name;
  final SteamFriendStatus status;
  final String? gameTitle;
  final String? lastSeenText;
  final Color avatarColor;

  const SteamFriend({
    required this.id,
    required this.name,
    required this.status,
    this.gameTitle,
    this.lastSeenText,
    this.avatarColor = const Color(0xFF2A475E),
  });

  SteamFriend copyWith({
    String? id,
    String? name,
    SteamFriendStatus? status,
    String? gameTitle,
    String? lastSeenText,
    Color? avatarColor,
  }) {
    return SteamFriend(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      gameTitle: gameTitle ?? this.gameTitle,
      lastSeenText: lastSeenText ?? this.lastSeenText,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}

class SteamToastData {
  final String title;
  final String subtitle;
  final String type; // achievement, friend_playing
  final DateTime? timestamp;

  const SteamToastData({
    required this.title,
    required this.subtitle,
    this.type = 'achievement',
    this.timestamp,
  });
}

class SteamConfig {
  final String username;
  final String walletBalance;
  final int notificationCount;
  final String selectedGameId;
  final bool showFriendsPanel;
  final List<SteamGame> games;
  final List<SteamFriend> friends;
  final SteamToastData? activeToast;

  const SteamConfig({
    required this.username,
    required this.walletBalance,
    required this.notificationCount,
    required this.selectedGameId,
    required this.showFriendsPanel,
    required this.games,
    required this.friends,
    this.activeToast,
  });

  static SteamConfig defaultPreset() {
    return SteamConfig(
      username: 'FictionPlayer_KR',
      walletBalance: '₩ 84,500',
      notificationCount: 3,
      selectedGameId: 'cyberpunk2077',
      showFriendsPanel: true,
      activeToast: const SteamToastData(
        title: '도전 과제 달성!',
        subtitle: '전설의 용병: 나이트 시티의 모든 의뢰 완료',
        type: 'achievement',
      ),
      games: [
        const SteamGame(
          id: 'cyberpunk2077',
          title: 'Cyberpunk 2077',
          category: '즐겨찾기',
          hoursPlayed: 328.4,
          lastPlayed: '오늘',
          isInstalled: true,
          isRunning: true,
          themeColor: Color(0xFFFCEE09),
          heroBannerType: 'cyberpunk',
          achievements: [
            SteamAchievement(id: 'c1', title: '전설의 용병', description: '나이트 시티의 모든 사이버웨어 및 의뢰 완료', isUnlocked: true, unlockedDate: '오늘 22:15', rarityPercent: 4.2),
            SteamAchievement(id: 'c2', title: '조니의 흔적', description: '조니 실버핸드의 유품을 모두 수집하십시오.', isUnlocked: true, unlockedDate: '어제', rarityPercent: 12.8),
            SteamAchievement(id: 'c3', title: '시티 라이프', description: '나이트 시티에서 100시간 이상 생존', isUnlocked: true, unlockedDate: '9월 12일', rarityPercent: 35.1),
            SteamAchievement(id: 'c4', title: '넷러너 마스터', description: '적 50명을 퀵핵으로 무력화하십시오.', isUnlocked: false, rarityPercent: 8.7),
          ],
        ),
        const SteamGame(
          id: 'elden_ring',
          title: 'ELDEN RING',
          category: '즐겨찾기',
          hoursPlayed: 452.1,
          lastPlayed: '2일 전',
          isInstalled: true,
          isRunning: false,
          themeColor: Color(0xFFC5A059),
          heroBannerType: 'elden',
          achievements: [
            SteamAchievement(id: 'e1', title: '엘든의 왕', description: '엘든의 왕 엔딩을 달성했습니다.', isUnlocked: true, unlockedDate: '8월 28일', rarityPercent: 18.2),
            SteamAchievement(id: 'e2', title: '파편의 군주 말레니아', description: '미켈라의 칼날 말레니아를 격파했습니다.', isUnlocked: true, unlockedDate: '8월 24일', rarityPercent: 22.4),
            SteamAchievement(id: 'e3', title: '전설의 무기', description: '모든 전설의 무기를 획득했습니다.', isUnlocked: false, rarityPercent: 11.5),
          ],
        ),
        const SteamGame(
          id: 'pubg',
          title: 'PUBG: BATTLEGROUNDS',
          category: '즐겨찾기',
          hoursPlayed: 894.2,
          lastPlayed: '어제',
          isInstalled: true,
          isRunning: false,
          themeColor: Color(0xFFF3A000),
          heroBannerType: 'pubg',
          achievements: [
            SteamAchievement(id: 'p1', title: '이겼닭! 오늘 저녁은 치킨이닭!', description: '배틀로얄 솔로/스쿼드 1위 달성', isUnlocked: true, unlockedDate: '어제 23:30', rarityPercent: 42.0),
            SteamAchievement(id: 'p2', title: '헤드샷 마스터', description: '스나이퍼 라이플로 100회 헤드샷 킬', isUnlocked: true, unlockedDate: '9월 5일', rarityPercent: 15.6),
          ],
        ),
        const SteamGame(
          id: 'wukong',
          title: 'Black Myth: Wukong',
          category: '모든 게임',
          hoursPlayed: 78.5,
          lastPlayed: '3일 전',
          isInstalled: true,
          isRunning: false,
          themeColor: Color(0xFFD4AF37),
          heroBannerType: 'wukong',
          achievements: [
            SteamAchievement(id: 'w1', title: '천명인(天命人)', description: '서유기의 첫 번째 여정을 완수하십시오.', isUnlocked: true, unlockedDate: '9월 10일', rarityPercent: 62.1),
          ],
        ),
        const SteamGame(
          id: 'palworld',
          title: 'Palworld (팰월드)',
          category: '모든 게임',
          hoursPlayed: 145.0,
          lastPlayed: '지난 주',
          isInstalled: true,
          isRunning: false,
          themeColor: Color(0xFF48CAE4),
          heroBannerType: 'palworld',
          achievements: [
            SteamAchievement(id: 'pal1', title: '팰 도감 완성가', description: '100종 이상의 팰을 포획하십시오.', isUnlocked: true, unlockedDate: '8월 15일', rarityPercent: 28.5),
          ],
        ),
        const SteamGame(
          id: 'cs2',
          title: 'Counter-Strike 2',
          category: '모든 게임',
          hoursPlayed: 1240.6,
          lastPlayed: '5일 전',
          isInstalled: true,
          isRunning: false,
          themeColor: Color(0xFFDE9B35),
          heroBannerType: 'cs2',
          achievements: [
            SteamAchievement(id: 'cs1', title: '새로운 시작', description: 'CS2 첫 매치 플레이', isUnlocked: true, unlockedDate: '2025년', rarityPercent: 88.0),
          ],
        ),
      ],
      friends: [
        const SteamFriend(
          id: 'f1',
          name: '김철수',
          status: SteamFriendStatus.inGame,
          gameTitle: 'Cyberpunk 2077',
          avatarColor: Color(0xFFE53935),
        ),
        const SteamFriend(
          id: 'f2',
          name: '박민우',
          status: SteamFriendStatus.inGame,
          gameTitle: 'ELDEN RING',
          avatarColor: Color(0xFFC5A059),
        ),
        const SteamFriend(
          id: 'f3',
          name: '이지은',
          status: SteamFriendStatus.online,
          avatarColor: Color(0xFF2563EB),
        ),
        const SteamFriend(
          id: 'f4',
          name: '서지원',
          status: SteamFriendStatus.away,
          lastSeenText: '자리 비움 (18분)',
          avatarColor: Color(0xFF9333EA),
        ),
        const SteamFriend(
          id: 'f5',
          name: '최동욱',
          status: SteamFriendStatus.offline,
          lastSeenText: '오프라인 (마지막 접속 2일 전)',
          avatarColor: Color(0xFF475569),
        ),
      ],
    );
  }

  SteamGame get selectedGame => games.firstWhere(
        (g) => g.id == selectedGameId,
        orElse: () => games.first,
      );

  SteamConfig copyWith({
    String? username,
    String? walletBalance,
    int? notificationCount,
    String? selectedGameId,
    bool? showFriendsPanel,
    List<SteamGame>? games,
    List<SteamFriend>? friends,
    SteamToastData? activeToast,
    bool clearToast = false,
  }) {
    return SteamConfig(
      username: username ?? this.username,
      walletBalance: walletBalance ?? this.walletBalance,
      notificationCount: notificationCount ?? this.notificationCount,
      selectedGameId: selectedGameId ?? this.selectedGameId,
      showFriendsPanel: showFriendsPanel ?? this.showFriendsPanel,
      games: games ?? this.games,
      friends: friends ?? this.friends,
      activeToast: clearToast ? null : (activeToast ?? this.activeToast),
    );
  }
}
