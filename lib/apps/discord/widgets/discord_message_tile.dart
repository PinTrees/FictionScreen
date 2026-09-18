import 'package:flutter/material.dart';
import '../data/discord_model.dart';

class DiscordMessageTile extends StatelessWidget {
  final DiscordMessage message;
  final ValueChanged<String>? onToggleReaction;

  const DiscordMessageTile({
    super.key,
    required this.message,
    this.onToggleReaction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply preview if present
          if (message.replyToAuthor != null) ...[
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 8,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFF4E5058), width: 1.5),
                        left: BorderSide(color: Color(0xFF4E5058), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '@${message.replyToAuthor}',
                    style: const TextStyle(
                      color: Color(0xFFB5BAC1),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      message.replyToContent ?? '',
                      style: const TextStyle(
                        color: Color(0xFF949BA4),
                        fontSize: 11.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: message.author.avatarColor,
                child: Text(
                  message.author.name.isNotEmpty ? message.author.name.characters.first : 'U',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 14),

              // Message Body Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Author Name + BOT Tag + Time
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          message.author.name,
                          style: TextStyle(
                            color: message.author.roleColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (message.author.isBot) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5865F2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: const Text(
                              '봇',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(width: 8),
                        Text(
                          message.timestamp,
                          style: const TextStyle(
                            color: Color(0xFF949BA4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Content text
                    _buildFormattedContent(message.content),

                    // Reactions bar
                    if (message.reactions.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: message.reactions.map((r) {
                          return InkWell(
                            onTap: () => onToggleReaction?.call(r.emoji),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: r.isReacted ? const Color(0xFF5865F2).withValues(alpha: 0.15) : const Color(0xFF2B2D31),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: r.isReacted ? const Color(0xFF5865F2) : const Color(0xFF3F4147),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(r.emoji, style: const TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${r.count}',
                                    style: TextStyle(
                                      color: r.isReacted ? const Color(0xFF5865F2) : const Color(0xFFB5BAC1),
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedContent(String content) {
    if (content.contains('@everyone') || content.contains('@DevMaster')) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFF5865F2).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          content,
          style: const TextStyle(
            color: Color(0xFFDBDEE1),
            fontSize: 14,
            height: 1.35,
          ),
        ),
      );
    }

    return Text(
      content,
      style: const TextStyle(
        color: Color(0xFFDBDEE1),
        fontSize: 14,
        height: 1.35,
      ),
    );
  }
}
