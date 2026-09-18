import 'package:flutter/material.dart';

enum DiscordUserStatus { online, idle, dnd, offline }

enum DiscordChannelType { text, voice, announcement }

class DiscordUser {
  final String id;
  final String name;
  final String tag;
  final Color avatarColor;
  final DiscordUserStatus status;
  final String? statusText;
  final Color roleColor;
  final String roleName;
  final bool isBot;

  const DiscordUser({
    required this.id,
    required this.name,
    this.tag = '0001',
    this.avatarColor = const Color(0xFF5865F2),
    this.status = DiscordUserStatus.online,
    this.statusText,
    this.roleColor = const Color(0xFFF2F3F5),
    this.roleName = 'Member',
    this.isBot = false,
  });

  DiscordUser copyWith({
    String? id,
    String? name,
    String? tag,
    Color? avatarColor,
    DiscordUserStatus? status,
    String? statusText,
    Color? roleColor,
    String? roleName,
    bool? isBot,
  }) {
    return DiscordUser(
      id: id ?? this.id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      avatarColor: avatarColor ?? this.avatarColor,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
      roleColor: roleColor ?? this.roleColor,
      roleName: roleName ?? this.roleName,
      isBot: isBot ?? this.isBot,
    );
  }
}

class DiscordReaction {
  final String emoji;
  final int count;
  final bool isReacted;

  const DiscordReaction({
    required this.emoji,
    required this.count,
    this.isReacted = false,
  });

  DiscordReaction copyWith({
    String? emoji,
    int? count,
    bool? isReacted,
  }) {
    return DiscordReaction(
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
      isReacted: isReacted ?? this.isReacted,
    );
  }
}

class DiscordMessage {
  final String id;
  final DiscordUser author;
  final String content;
  final String timestamp;
  final List<DiscordReaction> reactions;
  final bool isPinned;
  final String? replyToAuthor;
  final String? replyToContent;

  const DiscordMessage({
    required this.id,
    required this.author,
    required this.content,
    required this.timestamp,
    this.reactions = const [],
    this.isPinned = false,
    this.replyToAuthor,
    this.replyToContent,
  });

  DiscordMessage copyWith({
    String? id,
    DiscordUser? author,
    String? content,
    String? timestamp,
    List<DiscordReaction>? reactions,
    bool? isPinned,
    String? replyToAuthor,
    String? replyToContent,
  }) {
    return DiscordMessage(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      reactions: reactions ?? this.reactions,
      isPinned: isPinned ?? this.isPinned,
      replyToAuthor: replyToAuthor ?? this.replyToAuthor,
      replyToContent: replyToContent ?? this.replyToContent,
    );
  }
}

class DiscordChannel {
  final String id;
  final String name;
  final DiscordChannelType type;
  final int unreadCount;
  final bool hasMention;

  const DiscordChannel({
    required this.id,
    required this.name,
    this.type = DiscordChannelType.text,
    this.unreadCount = 0,
    this.hasMention = false,
  });

  DiscordChannel copyWith({
    String? id,
    String? name,
    DiscordChannelType? type,
    int? unreadCount,
    bool? hasMention,
  }) {
    return DiscordChannel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      unreadCount: unreadCount ?? this.unreadCount,
      hasMention: hasMention ?? this.hasMention,
    );
  }
}

class DiscordServer {
  final String id;
  final String name;
  final String iconText;
  final Color iconColor;
  final bool hasNotification;
  final List<DiscordChannel> channels;

  const DiscordServer({
    required this.id,
    required this.name,
    required this.iconText,
    this.iconColor = const Color(0xFF5865F2),
    this.hasNotification = false,
    required this.channels,
  });

  DiscordServer copyWith({
    String? id,
    String? name,
    String? iconText,
    Color? iconColor,
    bool? hasNotification,
    List<DiscordChannel>? channels,
  }) {
    return DiscordServer(
      id: id ?? this.id,
      name: name ?? this.name,
      iconText: iconText ?? this.iconText,
      iconColor: iconColor ?? this.iconColor,
      hasNotification: hasNotification ?? this.hasNotification,
      channels: channels ?? this.channels,
    );
  }
}

class DiscordConfig {
  final String selectedServerId;
  final String selectedChannelId;
  final List<DiscordServer> servers;
  final List<DiscordMessage> messages;
  final List<DiscordUser> members;
  final DiscordUser currentUser;
  final bool isVoiceConnected;
  final String connectedVoiceChannelName;

  const DiscordConfig({
    required this.selectedServerId,
    required this.selectedChannelId,
    required this.servers,
    required this.messages,
    required this.members,
    required this.currentUser,
    this.isVoiceConnected = false,
    this.connectedVoiceChannelName = '일반 음성',
  });

  DiscordConfig copyWith({
    String? selectedServerId,
    String? selectedChannelId,
    List<DiscordServer>? servers,
    List<DiscordMessage>? messages,
    List<DiscordUser>? members,
    DiscordUser? currentUser,
    bool? isVoiceConnected,
    String? connectedVoiceChannelName,
  }) {
    return DiscordConfig(
      selectedServerId: selectedServerId ?? this.selectedServerId,
      selectedChannelId: selectedChannelId ?? this.selectedChannelId,
      servers: servers ?? this.servers,
      messages: messages ?? this.messages,
      members: members ?? this.members,
      currentUser: currentUser ?? this.currentUser,
      isVoiceConnected: isVoiceConnected ?? this.isVoiceConnected,
      connectedVoiceChannelName: connectedVoiceChannelName ?? this.connectedVoiceChannelName,
    );
  }

  static DiscordConfig defaultPreset() {
    const adminUser = DiscordUser(
      id: 'u-1',
      name: '팀장_DevMaster',
      avatarColor: Color(0xFFE91E63),
      status: DiscordUserStatus.online,
      statusText: 'Visual Studio Code',
      roleColor: Color(0xFFF1C40F),
      roleName: 'Server Admin',
    );

    const botUser = DiscordUser(
      id: 'u-bot',
      name: 'GitHub Alert Bot',
      avatarColor: Color(0xFF24292E),
      status: DiscordUserStatus.online,
      roleColor: Color(0xFF5865F2),
      roleName: 'Verified BOT',
      isBot: true,
    );

    const midjourneyBot = DiscordUser(
      id: 'u-mj',
      name: 'Midjourney Bot',
      avatarColor: Color(0xFF000000),
      status: DiscordUserStatus.online,
      roleColor: Color(0xFF5865F2),
      roleName: 'Verified BOT',
      isBot: true,
    );

    const seniorDev = DiscordUser(
      id: 'u-2',
      name: '판교_풀스택냥',
      avatarColor: Color(0xFF3498DB),
      status: DiscordUserStatus.idle,
      statusText: '음악 듣는 중 - NewJeans',
      roleColor: Color(0xFF9B59B6),
      roleName: 'Senior Dev',
    );

    const juniorDev = DiscordUser(
      id: 'u-3',
      name: '코딩꿈나무_철수',
      avatarColor: Color(0xFF2ECC71),
      status: DiscordUserStatus.dnd,
      statusText: '리그 오브 레전드 플레이 중',
      roleColor: Color(0xFF2ECC71),
      roleName: 'Developer',
    );

    const currentUser = DiscordUser(
      id: 'u-me',
      name: 'FictionUser',
      tag: '1337',
      avatarColor: Color(0xFF5865F2),
      status: DiscordUserStatus.online,
      statusText: 'FictionScreen 스튜디오 작업 중',
      roleColor: Color(0xFF00D26A),
      roleName: 'Member',
    );

    final members = [
      adminUser,
      seniorDev,
      juniorDev,
      currentUser,
      botUser,
      midjourneyBot,
      const DiscordUser(
        id: 'u-4',
        name: '디자이너_뽀또',
        avatarColor: Color(0xFFE67E22),
        status: DiscordUserStatus.offline,
        roleColor: Color(0xFFE67E22),
        roleName: 'Designer',
      ),
      const DiscordUser(
        id: 'u-5',
        name: 'QA_검수봇',
        avatarColor: Color(0xFF95A5A6),
        status: DiscordUserStatus.offline,
        roleColor: Color(0xFF95A5A6),
        roleName: 'Tester',
      ),
    ];

    final defaultChannels = [
      const DiscordChannel(id: 'ch-announcement', name: '공지사항', type: DiscordChannelType.announcement),
      const DiscordChannel(id: 'ch-general', name: '일반-채팅', type: DiscordChannelType.text, unreadCount: 0),
      const DiscordChannel(id: 'ch-dev', name: '개발-질문-토론', type: DiscordChannelType.text, unreadCount: 3, hasMention: true),
      const DiscordChannel(id: 'ch-memes', name: '짤방-유머', type: DiscordChannelType.text),
      const DiscordChannel(id: 'ch-bot', name: '봇-명령어', type: DiscordChannelType.text),
      const DiscordChannel(id: 'ch-voice-1', name: '🔊 회의실 1 (화면공유)', type: DiscordChannelType.voice),
      const DiscordChannel(id: 'ch-voice-2', name: '🔊 롤 드가자 (자유음성)', type: DiscordChannelType.voice),
    ];

    final servers = [
      DiscordServer(
        id: 'srv-1',
        name: 'PinTrees Dev & Gaming Hub',
        iconText: 'PT',
        iconColor: const Color(0xFF5865F2),
        channels: defaultChannels,
      ),
      const DiscordServer(
        id: 'srv-2',
        name: 'Flutter & Dart Korea',
        iconText: 'FL',
        iconColor: Color(0xFF02569B),
        hasNotification: true,
        channels: [
          DiscordChannel(id: 'fl-1', name: '질문답변'),
          DiscordChannel(id: 'fl-2', name: '쇼케이스'),
        ],
      ),
      const DiscordServer(
        id: 'srv-3',
        name: '롤 5인큐 내전방',
        iconText: 'LOL',
        iconColor: Color(0xFFC89B3C),
        channels: [
          DiscordChannel(id: 'lol-1', name: '파티모집'),
          DiscordChannel(id: 'lol-2', name: '칼바람-나락'),
        ],
      ),
    ];

    final defaultMessages = [
      const DiscordMessage(
        id: 'm-1',
        author: adminUser,
        content: '@everyone 오늘 배포 완료되었습니다! 모바일 & 데스크탑 둘 다 반응형 확인 부탁드립니다.',
        timestamp: '오늘 오후 2:15',
        reactions: [
          DiscordReaction(emoji: '🚀', count: 8, isReacted: true),
          DiscordReaction(emoji: '🔥', count: 12),
          DiscordReaction(emoji: '👍', count: 5),
        ],
      ),
      const DiscordMessage(
        id: 'm-2',
        author: botUser,
        content: '[PR #142] feat(core): implement responsive multi-window floating manager merged into main by @DevMaster',
        timestamp: '오늘 오후 2:16',
        reactions: [
          DiscordReaction(emoji: '🎉', count: 6),
        ],
      ),
      const DiscordMessage(
        id: 'm-3',
        author: seniorDev,
        content: '수고하셨습니다 ㅋㅋㅋ 드디어 블라인드랑 디스코드까지 들어갔네요. 성능 측정 돌려보니까 60fps 칼고정입니다.',
        timestamp: '오늘 오후 2:20',
        reactions: [
          DiscordReaction(emoji: '💯', count: 4),
        ],
      ),
      const DiscordMessage(
        id: 'm-4',
        author: juniorDev,
        content: '팀장님 오늘 야근 없으면 저 7시에 롤 5인큐 음성방 파놓겠습니다 드루오시죠',
        timestamp: '오늘 오후 2:23',
        replyToAuthor: '팀장_DevMaster',
        replyToContent: '오늘 배포 완료되었습니다! 모바일 & 데스크탑 둘 다 반응형 확인 부탁드립니다.',
        reactions: [
          DiscordReaction(emoji: '⚔️', count: 3, isReacted: true),
          DiscordReaction(emoji: '👀', count: 7),
        ],
      ),
      const DiscordMessage(
        id: 'm-5',
        author: adminUser,
        content: 'ㅋㅋㅋ 오늘은 칼퇴 각이라 무조건 갑니다. 미드 비워두세요.',
        timestamp: '오늘 오후 2:25',
        reactions: [
          DiscordReaction(emoji: '👑', count: 9),
        ],
      ),
    ];

    return DiscordConfig(
      selectedServerId: 'srv-1',
      selectedChannelId: 'ch-general',
      servers: servers,
      messages: defaultMessages,
      members: members,
      currentUser: currentUser,
      isVoiceConnected: false,
      connectedVoiceChannelName: '회의실 1 (화면공유)',
    );
  }
}
