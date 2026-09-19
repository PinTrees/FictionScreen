import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/scale_button.dart';

class LegalPage extends StatefulWidget {
  final String initialTab; // 'terms' or 'privacy'

  const LegalPage({
    super.key,
    this.initialTab = 'terms',
  });

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  late String _activeTab;
  bool? _userThemeOverride;
  bool _isEnglish = false;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab == 'privacy' ? 'privacy' : 'terms';
  }

  void _toggleTheme(bool currentIsDark) {
    setState(() {
      _userThemeOverride = !currentIsDark;
    });
  }

  void _toggleLanguage() {
    setState(() {
      _isEnglish = !_isEnglish;
    });
  }

  @override
  Widget build(BuildContext context) {
    final systemIsDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    final isDarkMode = _userThemeOverride ?? systemIsDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    final bgColor = isDarkMode ? const Color(0xFF07090E) : const Color(0xFFF8FAFC);
    final cardBgColor = isDarkMode ? const Color(0xFF0F111A) : Colors.white;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final textSubColor = isDarkMode ? Colors.white.withValues(alpha: 0.7) : const Color(0xFF475569);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Ambient Background Aura
          Positioned(
            top: -120,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 700,
                height: 380,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.12 : 0.06),
                      const Color(0xFF38BDF8).withValues(alpha: isDarkMode ? 0.05 : 0.02),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Scrollable Content
          SafeArea(
            child: Column(
              children: [
                // 1. Top Navigation Bar
                _buildTopBar(context, isDarkMode, textColor, isMobile),

                // 2. Main Scrollable Document Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 18 : 32,
                      vertical: isMobile ? 24 : 40,
                    ),
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 880),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tab Selector
                            _buildTabSelector(isDarkMode),

                            const SizedBox(height: 28),

                            // Document Card (NO OUTLINE BORDER)
                            Container(
                              padding: EdgeInsets.all(isMobile ? 22 : 44),
                              decoration: BoxDecoration(
                                color: cardBgColor,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: isDarkMode ? 0.4 : 0.04),
                                    blurRadius: 30,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: _activeTab == 'terms'
                                  ? _buildTermsContent(textColor, textSubColor, isDarkMode)
                                  : _buildPrivacyContent(textColor, textSubColor, isDarkMode),
                            ),

                            const SizedBox(height: 50),

                            // Bottom Navigation Return (Zero outline, tactile scale)
                            Center(
                              child: ScaleButton(
                                onTap: () => context.go('/'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.15 : 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(CupertinoIcons.arrow_left, size: 16, color: Color(0xFF6366F1)),
                                      const SizedBox(width: 8),
                                      Text(
                                        _isEnglish ? 'Back to FictionScreen Home' : 'FictionScreen 홈으로 돌아가기',
                                        style: const TextStyle(
                                          color: Color(0xFF6366F1),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    bool isDarkMode,
    Color textColor,
    bool isMobile,
  ) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF07090E).withValues(alpha: 0.9) : Colors.white.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            children: [
              // Brand Logo
              InkWell(
                onTap: () => context.go('/'),
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00E5FF), Color(0xFF00B0FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(CupertinoIcons.square_stack_3d_up_fill, color: Colors.white, size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'FictionScreen',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Language Toggle
              TextButton(
                onPressed: _toggleLanguage,
                style: TextButton.styleFrom(
                  foregroundColor: textColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _isEnglish ? '한국어' : 'English',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Theme Toggle
              IconButton(
                onPressed: () => _toggleTheme(isDarkMode),
                icon: Icon(
                  isDarkMode ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                  size: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
                tooltip: isDarkMode ? '라이트 모드' : '다크 모드',
              ),

              if (!isMobile) ...[
                const SizedBox(width: 10),
                ScaleButton(
                  onTap: () => context.go('/'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.arrow_left, size: 14, color: textColor),
                        const SizedBox(width: 6),
                        Text(
                          _isEnglish ? 'Home' : '홈으로',
                          style: TextStyle(
                            color: textColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector(bool isDarkMode) {
    final activeBg = const Color(0xFF6366F1);
    final inactiveText = isDarkMode ? Colors.white.withValues(alpha: 0.6) : const Color(0xFF64748B);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0).withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabButton(
            id: 'terms',
            title: _isEnglish ? 'Terms of Service' : '이용약관',
            isActive: _activeTab == 'terms',
            activeBg: activeBg,
            inactiveText: inactiveText,
          ),
          const SizedBox(width: 4),
          _buildTabButton(
            id: 'privacy',
            title: _isEnglish ? 'Privacy Policy' : '개인정보 처리방침',
            isActive: _activeTab == 'privacy',
            activeBg: activeBg,
            inactiveText: inactiveText,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String id,
    required String title,
    required bool isActive,
    required Color activeBg,
    required Color inactiveText,
  }) {
    return ScaleButton(
      onTap: () {
        if (_activeTab != id) {
          setState(() {
            _activeTab = id;
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: activeBg.withValues(alpha: 0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : inactiveText,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ==========================================
  // TERMS OF SERVICE CONTENT
  // ==========================================
  Widget _buildTermsContent(Color textColor, Color textSubColor, bool isDarkMode) {
    if (_isEnglish) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms of Service',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Effective Date: September 19, 2026 | Last Updated: September 19, 2026',
            style: TextStyle(color: textSubColor, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildNoticeBox(
            title: 'Welcome to FictionScreen',
            desc:
                'FictionScreen is a virtual screen studio designed for novelists, webtoon authors, filmmakers, and creative storytellers to simulate and generate fiction user interfaces for storytelling purposes.',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 28),
          _buildSection(
            number: '1',
            title: 'Purpose',
            content:
                'These Terms of Service govern the rights, obligations, and responsibilities between FictionScreen ("the Service", "we") and users regarding all virtual OS simulations, template mockups, and related editing tools provided on the website.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '2',
            title: 'Definitions',
            content:
                '1. "Virtual Screen Studio" refers to simulated operating system and application interfaces rendered in web browsers.\n2. "Creator" or "User" refers to any individual or business entity accessing the service, whether signed in via Google account or as a guest.\n3. "Generated Output" refers to image captures, mockups, dialogues, and storyboard assets produced using FictionScreen tools.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '3',
            title: 'Creator Ownership & Intellectual Property Rights',
            content:
                '1. Full Creator Ownership: All dialogues, texts, story configurations, and exported images created by users using FictionScreen belong entirely to the user. You are free to use these assets in commercial or non-commercial creative works including webtoons, web novels, video productions, and publications.\n2. Platform Logos & Trademarks: UI elements resembling real-world platforms (e.g. KakaoTalk, YouTube, Steam) are provided under fair-use fiction mockup purposes. Creators must not use these trademarks to falsely impersonate actual corporate entities or deceive consumers in real commercial transactions.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '4',
            title: 'Prohibited Misuse & User Obligations',
            content:
                'Users strictly agree NOT to use FictionScreen for:\n• Financial fraud, voice phishing, fake banking slips, or unlawful impersonation\n• Defamation, libel, or malicious spread of forged fake news against real individuals or corporations\n• Any conduct that violates applicable local or international laws.\nViolation of these terms may result in immediate suspension of account access and referral to law enforcement agencies.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '5',
            title: 'Limitation of Liability & Warranty Disclaimer',
            content:
                'FictionScreen is provided "AS IS" as a creative simulation aid. The Service is not liable for any disputes, legal claims, or damages arising from illegal misuse, forgery, or malicious activities conducted by users with generated mockups.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '6',
            title: 'Governing Law & Jurisdiction',
            content:
                'These terms shall be governed by and construed in accordance with the laws of the Republic of Korea. Any disputes shall be submitted to the competent court with jurisdiction over the location of FictionScreen operations.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FictionScreen 서비스 이용약관',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '시행일자: 2026년 9월 19일 | 최종 개정일: 2026년 9월 19일',
          style: TextStyle(color: textSubColor, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _buildNoticeBox(
          title: 'FictionScreen을 이용해 주셔서 감사합니다',
          desc:
              'FictionScreen은 소설가, 웹툰 작가, 시나리오 라이터, 영상 크리에이터가 작품 속 가상 화면(메신저, SNS, OS 등)을 쉽고 정교하게 연출할 수 있도록 돕는 창작 보조 시뮬레이션 플랫폼입니다.',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 28),
        _buildSection(
          number: '제1조',
          title: '목적',
          content:
              '본 약관은 FictionScreen(이하 "서비스")이 웹사이트를 통해 제공하는 가상 OS 및 앱 스튜디오 시뮬레이션 서비스의 이용 조건 및 절차, 회사와 이용자 간의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제2조',
          title: '용어의 정의',
          content:
              '1. "가상 스크린"이란 서비스 내에서 웹 브라우저를 통해 시뮬레이션되는 가상 데스크톱 OS(Windows, macOS, SteamOS 등) 및 모바일/웹 애플리케이션 화면을 의미합니다.\n2. "이용자"란 본 약관에 동의하고 서비스를 이용하는 회원 및 비회원(게스트)을 통칭합니다.\n3. "창작 결과물"이란 이용자가 서비스의 에디터 기능을 활용하여 대사, 잔액, 상태 등을 편집하고 캡처 또는 다운로드한 이미지와 텍스트 일체를 의미합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제3조',
          title: '약관의 효력 및 변경',
          content:
              '1. 본 약관은 서비스 웹사이트에 게시함으로써 효력이 발생합니다.\n2. 회사는 관련 법령을 위배하지 않는 범위 내에서 약관을 개정할 수 있으며, 약관이 개정되는 경우 개정 약관의 적용일자 7일 전부터 웹사이트에 공지합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제4조',
          title: '창작물에 대한 저작권 및 이용 권리 (핵심 보장)',
          content:
              '1. 창작자 저작권 귀속: 이용자가 FictionScreen의 에디터를 활용하여 입력·배치·생성한 대화 내용, 스토리 구성 및 캡처 이미지의 지식재산권은 전적으로 창작자(이용자)에게 귀속됩니다.\n2. 상업적 이용 허용: 생성된 결과물은 웹툰 원고 콘티, 웹소설 삽화, 유튜브 영상 삽입, 출판물, 방송 시나리오 등 개인적·상업적 창작물에 제한 없이 자유롭게 활용하실 수 있습니다.\n3. 상표 및 로고 주의사항: 서비스 내에 제공되는 현실 속 앱/OS의 아이콘 및 상표는 창작물의 사실적 묘사를 위한 패러디 및 창작 보조 목적으로 제공되는 것으로, 실제 해당 기업을 사칭하거나 부당한 경제적 이익을 취하는 목적으로 오인되도록 사용하여서는 안 됩니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제5조',
          title: '이용자의 금지 행위 및 의무 (불법 오남용 엄금)',
          content:
              '이용자는 다음 각 호에 해당하는 행위를 하여서는 안 되며, 적발 시 사전 통보 없이 계정 정지 및 관계 기관에 고발 조치될 수 있습니다.\n• 금융 사기, 보이스피싱, 허위 입금증/송금증 조작 등 범죄 목적의 화면 생성 및 유포\n• 특정 실존 인물을 사칭하여 허위 사실을 날조하거나 명예를 훼손하는 악의적 가짜 대화 조작\n• 타인의 지식재산권, 초상권 또는 프라이버시를 부당하게 침해하는 행위\n• 서비스의 정상적 운영을 방해하거나 서버에 과도한 부하를 유발하는 자동화 매크로/스크래핑 행위',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제6조',
          title: '면책 조항 (서비스의 법적 한계)',
          content:
              '1. FictionScreen은 창작 시뮬레이션 도구로서, 이용자가 생성한 창작물의 구체적 내용과 그로 인해 발생하는 타인과의 법적 분쟁에 대하여 어떠한 보증이나 민·형사상 책임을 지지 않습니다.\n2. 회사는 천재지변, 인터넷 망 장애, 클라우드 호스팅 점검 등 불가항력적 사유로 인한 일시적 서비스 중단에 대해 책임을 면합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제7조',
          title: '준거법 및 관할법원',
          content:
              '본 약관의 해석 및 회사와 이용자 간의 분쟁에 대하여는 대한민국 법률을 적용하며, 분쟁 발생 시 회사의 소재지를 관할하는 법원을 전속 관할 법원으로 합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
      ],
    );
  }

  // ==========================================
  // PRIVACY POLICY CONTENT
  // ==========================================
  Widget _buildPrivacyContent(Color textColor, Color textSubColor, bool isDarkMode) {
    if (_isEnglish) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Privacy Policy',
            style: TextStyle(
              color: textColor,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Effective Date: September 19, 2026 | Last Updated: September 19, 2026',
            style: TextStyle(color: textSubColor, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _buildNoticeBox(
            title: 'Your Privacy Matters',
            desc:
                'FictionScreen values your privacy. We collect only minimal data required for authentication and state synchronization, and we do not sell your data to third parties.',
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 28),
          _buildSection(
            number: '1',
            title: 'Information Collected',
            content:
                '• Social Authentication (Google): Email address, display name, profile avatar URL, and user identifier (UID).\n• Guest Users: No personally identifiable information (PII) is collected.\n• Local Storage: Browser cache storing theme preferences (dark/light), selected language, and active editor configs.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '2',
            title: 'Purpose of Processing',
            content:
                '• User authentication and account state management\n• Synchronizing customized virtual OS preferences and saved studio mockups\n• Preventing service abuse, spam, and ensuring platform stability',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '3',
            title: 'Retention & Destruction',
            content:
                'User data is retained only while the account is active. Upon user request for account deletion or withdrawal, personal information is permanently erased without undue delay, except where retention is required by applicable law.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '4',
            title: 'Third-Party Services & Processing Delegation',
            content:
                'We do not provide or sell personal information to commercial third parties. We utilize secure global cloud infrastructure:\n• Google Firebase (Authentication & Cloud Hosting): Data encrypted in transit via SSL/TLS and secured by cloud security protocols.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
          _buildSection(
            number: '5',
            title: 'User Rights & Contact Information',
            content:
                'Users have the right to access, rectify, or request deletion of their personal information at any time. For privacy inquiries or requests, please contact our privacy team at privacy@fictionscreen.io.',
            textColor: textColor,
            textSubColor: textSubColor,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FictionScreen 개인정보 처리방침',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '시행일자: 2026년 9월 19일 | 최종 개정일: 2026년 9월 19일',
          style: TextStyle(color: textSubColor, fontSize: 13),
        ),
        const SizedBox(height: 24),
        _buildNoticeBox(
          title: '개인정보 보호에 대한 약속',
          desc:
              'FictionScreen은 「개인정보 보호법」 등 관련 법령을 준수하며, 이용자의 개인정보를 안전하게 보호하고 불필요한 개인 식별 정보는 일체 요구하거나 판매하지 않습니다.',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 28),
        _buildSection(
          number: '제1조',
          title: '수집하는 개인정보 항목 및 수집 방법',
          content:
              '1. 회원 가입 및 로그인 시 (Google 소셜 로그인):\n   - 수집 항목: 이메일 주소, 프로필 이름, 프로필 사진 URL, 고유 계정 식별자(UID)\n   - 수집 방법: Google OAuth 2.0 연동을 통한 자동 수집\n2. 비회원(게스트) 이용 시:\n   - 이름, 전화번호, 주민등록번호 등 일체의 개인 식별 정보를 수집하지 않습니다.\n3. 서비스 이용 과정에서 자동 생성·저장되는 항목:\n   - 브라우저 로컬 스토리지 데이터: 다크모드/라이트모드 설정, 언어 선택(KO/EN), 최근 작업 템플릿 상태',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제2조',
          title: '개인정보의 수집 및 이용 목적',
          content:
              '회사는 수집한 개인정보를 다음의 목적을 위해 활용합니다.\n• 회원 식별 및 본인 확인, 비정상적 로그인 감지\n• 이용자별 가상 OS 환경설정, 바탕화면 바로가기 및 커스텀 스튜디오 데이터의 클라우드 동기화\n• 서비스 문의 응대 및 운영상 필수적인 중요 공지사항 전달',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제3조',
          title: '개인정보의 보유 및 이용 기간',
          content:
              '1. 이용자의 개인정보는 회원 자격을 유지하는 기간 동안에 한하여 안전하게 보유 및 이용됩니다.\n2. 이용자가 회원 탈퇴를 요청하거나 개인정보 삭제를 요구하는 경우, 지체 없이 해당 정보를 영구 파기합니다.\n3. 단, 전자상거래 등에서의 소비자보호에 관한 법률 등 관련 법령의 규정에 의하여 보존할 필요가 있는 경우 법정 기간 동안 별도 보관합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제4조',
          title: '개인정보의 제3자 제공 및 처리 위탁',
          content:
              '1. 회사는 이용자의 사전 동의 없이 개인정보를 외부에 제공하거나 판매하지 않습니다.\n2. 원활하고 안전한 인프라 제공을 위해 다음과 같이 전문 클라우드 서비스에 처리를 위탁하고 있습니다.\n   • 수탁업체: Google LLC (Firebase)\n   • 위탁 업무 내용: 안전한 인증(Authentication) 처리 및 데이터베이스/호스팅 인프라 제공',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제5조',
          title: '이용자의 권리와 그 행사 방법',
          content:
              '1. 이용자는 언제든지 본인의 개인정보 열람, 수정, 처리 정지 및 회원 탈퇴(삭제)를 요구할 수 있습니다.\n2. 권리 행사는 서비스 내 프로필 관리 또는 개인정보 보호책임자 이메일(privacy@fictionscreen.io)을 통해 요청하실 수 있으며 지체 없이 조치합니다.',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제6조',
          title: '개인정보의 안전성 확보 조치',
          content:
              '회사는 이용자의 개인정보가 분실, 도난, 유출, 변조되지 않도록 다음과 같은 기술적·관리적 대책을 강구하고 있습니다.\n• 모든 데이터 전송 구간 SSL/TLS 256bit 암호화 프로토콜 적용\n• Firebase 보안 규칙(Security Rules)을 통한 비인가 접근 차단\n• 개인정보 접근 권한을 최소 인원으로 제한',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
        _buildSection(
          number: '제7조',
          title: '개인정보 보호책임자 및 고충 처리 연락처',
          content:
              '서비스 이용 중 발생하는 개인정보 보호 관련 모든 문의나 고충은 아래의 전담 부서로 접수해 주시면 신속하게 답변드리겠습니다.\n• 책임 부서: FictionScreen 개인정보보호팀\n• 문의 이메일: privacy@fictionscreen.io',
          textColor: textColor,
          textSubColor: textSubColor,
        ),
      ],
    );
  }

  Widget _buildNoticeBox({
    required String title,
    required String desc,
    required bool isDarkMode,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: isDarkMode ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(CupertinoIcons.info_circle_fill, color: Color(0xFF6366F1), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w800,
                    fontSize: 14.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white.withValues(alpha: 0.85) : const Color(0xFF334155),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
    required Color textColor,
    required Color textSubColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  number,
                  style: const TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w800,
                    fontSize: 12.5,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: textSubColor,
              fontSize: 14.5,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
