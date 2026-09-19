import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../services/auth_service.dart';
import '../../../../widgets/pop_entrance.dart';
import '../../../../widgets/scale_button.dart';

class ProfileView extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onSignOut;
  final VoidCallback onBackToDashboard;

  const ProfileView({
    super.key,
    required this.isDarkMode,
    required this.onSignOut,
    required this.onBackToDashboard,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final User? _user = AuthService.currentUser;

  late final TextEditingController _nameCtrl;
  late final TextEditingController _bioCtrl;

  bool _isSaving = false;
  String? _savedSuccessMsg;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _user?.displayName ?? '크리에이터');
    _bioCtrl = TextEditingController();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (_user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['bio'] != null && mounted) {
          setState(() {
            _bioCtrl.text = data['bio'];
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;
    setState(() {
      _isSaving = true;
      _savedSuccessMsg = null;
    });

    try {
      final newName = _nameCtrl.text.trim().isEmpty ? '크리에이터' : _nameCtrl.text.trim();
      final newBio = _bioCtrl.text.trim();

      // 1. Update Firebase Auth displayName
      await _user.updateDisplayName(newName);

      // 2. Update Firestore users collection
      await FirebaseFirestore.instance.collection('users').doc(_user.uid).set({
        'displayName': newName,
        'bio': newBio,
        'email': _user.email,
        'photoURL': _user.photoURL,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _savedSuccessMsg = '프로필 정보가 성공적으로 저장되었습니다!';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('프로필 저장 중 오류가 발생했습니다: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDark ? Colors.white54 : const Color(0xFF64748B);
    final cardBgColor = isDark ? const Color(0xFF131722) : Colors.white;
    final fieldBgColor = isDark ? Colors.white.withValues(alpha: 0.06) : const Color(0xFFF1F5F9);

    final user = _user;
    final photoURL = user?.photoURL;
    final email = user?.email ?? '게스트 계정 (미연동)';
    final initial = (user?.displayName?.isNotEmpty == true
            ? user!.displayName![0]
            : (user?.email?.isNotEmpty == true ? user!.email![0] : 'U'))
        .toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back to Dashboard Row
          InkWell(
            onTap: widget.onBackToDashboard,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(CupertinoIcons.arrow_left, size: 14, color: textSubColor),
                  const SizedBox(width: 6),
                  Text('대시보드로 돌아가기', style: TextStyle(color: textSubColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Header
          Text(
            '내 프로필 & 계정 설정',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '스튜디오 및 생성된 프로젝트에 표시되는 활동명과 계정 정보를 관리하세요.',
            style: TextStyle(color: textSubColor, fontSize: 13.5),
          ),

          const SizedBox(height: 28),

          // Main Profile Card (ZERO OUTLINE, Pop Entrance)
          Expanded(
            child: SingleChildScrollView(
              child: PopEntrance(
                delay: const Duration(milliseconds: 80),
                startScale: 0.94,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 720),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar & Email Overview
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: const Color(0xFF00B0FF),
                          backgroundImage: photoURL != null ? NetworkImage(photoURL) : null,
                          child: photoURL == null
                              ? Text(initial, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold))
                              : null,
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.displayName ?? '크리에이터',
                                style: TextStyle(color: textColor, fontSize: 19, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: TextStyle(color: textSubColor, fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Firebase 인증 완료',
                                  style: TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    if (_savedSuccessMsg != null)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(CupertinoIcons.checkmark_circle_fill, size: 16, color: Color(0xFF10B981)),
                            const SizedBox(width: 8),
                            Text(_savedSuccessMsg!, style: const TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                    // Display Name Field
                    Text('활동명 / 크리에이터 닉네임', style: TextStyle(color: textColor, fontSize: 13.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(color: fieldBgColor, borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _nameCtrl,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          hintText: '이름 또는 닉네임을 입력하세요',
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bio Field
                    Text('크리에이터 소개 / 작업 분야', style: TextStyle(color: textColor, fontSize: 13.5, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(color: fieldBgColor, borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: _bioCtrl,
                        maxLines: 3,
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                          hintText: '예: 로맨스릴러 웹소설 작가, 유튜브 숏폼 영상 크리에이터 등',
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Save Button (Pops in growing)
                    Row(
                      children: [
                        PopEntrance(
                          delay: const Duration(milliseconds: 200),
                          startScale: 0.82,
                          child: ScaleButton(
                            onTap: _isSaving ? null : _saveProfile,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00E5FF).withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_isSaving)
                                    const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF003852)),
                                    )
                                  else
                                    const Icon(CupertinoIcons.check_mark, size: 16, color: Color(0xFF003852)),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '프로필 저장하기',
                                    style: TextStyle(
                                      color: Color(0xFF003852),
                                      fontWeight: FontWeight.w800,
                                      fontSize: 13.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: widget.onSignOut,
                          style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFFEF4444),
                          ),
                          icon: const Icon(Icons.logout_rounded, size: 16),
                          label: const Text('계정 로그아웃', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
