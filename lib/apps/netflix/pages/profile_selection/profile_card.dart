import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/netflix_model.dart';

/// 넷플릭스 프로필 개별 아바타 카드
class ProfileCard extends StatefulWidget {
  final NetflixProfile profile;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 14),
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.05, 1.05, 1.0)
              : Matrix4.identity(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: widget.profile.avatarBgColor,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isHovered ? Colors.white : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: _isHovered
                      ? [
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.3),
                            blurRadius: 16,
                          )
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: widget.profile.avatarAsset != null
                      ? Image.asset(widget.profile.avatarAsset!, fit: BoxFit.cover)
                      : Center(
                          child: Icon(
                            widget.profile.isKids
                                ? CupertinoIcons.sparkles
                                : CupertinoIcons.smiley_fill,
                            size: 54,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.profile.name,
                style: TextStyle(
                  color: _isHovered ? Colors.white : Colors.white70,
                  fontSize: 15,
                  fontWeight: _isHovered ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 프로필 추가 (+) 카드
class AddProfileCard extends StatefulWidget {
  final VoidCallback onTap;

  const AddProfileCard({super.key, required this.onTap});

  @override
  State<AddProfileCard> createState() => _AddProfileCardState();
}

class _AddProfileCardState extends State<AddProfileCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 14),
          transform: _isHovered
              ? Matrix4.diagonal3Values(1.05, 1.05, 1.0)
              : Matrix4.identity(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _isHovered ? Colors.white : Colors.white38,
                    width: 2.0,
                  ),
                ),
                child: Center(
                  child: Icon(
                    CupertinoIcons.add,
                    size: 48,
                    color: _isHovered ? Colors.white : Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '프로필 추가',
                style: TextStyle(
                  color: _isHovered ? Colors.white : Colors.white54,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
