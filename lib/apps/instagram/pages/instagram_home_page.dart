import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../data/instagram_model.dart';
import '../widgets/instagram_post_card.dart';

class InstagramHomePage extends StatelessWidget {
  final InstagramConfig config;
  final Function(InstagramStoryItem) onOpenStory;
  final VoidCallback onOpenDm;
  final VoidCallback onOpenProfile;

  const InstagramHomePage({
    super.key,
    required this.config,
    required this.onOpenStory,
    required this.onOpenDm,
    required this.onOpenProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6), width: 0.8)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                // Instagram wordmark
                const Text(
                  'Instagram',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                    letterSpacing: -0.5,
                    color: Colors.black,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_down, size: 14, color: Colors.black87),
                const Spacer(),
                // Heart (Notifications)
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.heart, size: 24, color: Colors.black87),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('새로운 활동 알림이 없습니다.'), duration: Duration(seconds: 1)),
                        );
                      },
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                // DM Paperplane with unread count
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(CupertinoIcons.paperplane, size: 24, color: Colors.black87),
                      onPressed: onOpenDm,
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '2',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Stories Tray
            _buildStoriesTray(context),
            const Divider(height: 1, thickness: 0.5, color: Color(0xFFE5E7EB)),

            // Post Cards
            ...config.posts.map((post) => InstagramPostCard(
                  post: post,
                  onProfileTap: onOpenProfile,
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesTray(BuildContext context) {
    return Container(
      height: 102,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: config.stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            // My Story item
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.shade300, width: 1.5),
                        ),
                        child: const CircleAvatar(
                          radius: 27,
                          backgroundColor: Color(0xFFF97316),
                          child: Text(
                            'S',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0095F6),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: const Icon(CupertinoIcons.plus, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '내 스토리',
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ],
              ),
            );
          }

          final story = config.stories[index - 1];
          return GestureDetector(
            onTap: () => onOpenStory(story),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2.5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: story.avatarBg,
                        child: Text(
                          story.avatarLetter,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 68,
                    child: Text(
                      story.username,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 11, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
