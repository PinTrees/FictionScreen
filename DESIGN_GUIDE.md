# FictionScreen Design Specification & Guidelines

## 1. Strict Icon Rule (규격 필수 수칙)
> **[MANDATORY] 모든 UI 컴포넌트의 아이콘은 반드시 `CupertinoIcons`만 사용해야 합니다.**
> - Material Design의 `Icons.*` 사용은 프로젝트 전역에서 **전면 금지**됩니다.
> - 사유: 일관된 iOS/macOS 정밀 라인아트 및 모던 미니멀리즘 감성을 유지하고, 픽션 화면의 디테일(상태바, 안읽음 표시, 독 바, 윈도우/맥 작업표시줄 등)을 정확하게 시뮬레이션하기 위함입니다.

### Icon Mapping Reference
| 기능 / 용도 | 허용 아이콘 (`CupertinoIcons`) | 금지 아이콘 (`Icons.*`) |
| :--- | :--- | :--- |
| 채팅 / 메시지 | `CupertinoIcons.chat_bubble_2_fill`, `CupertinoIcons.chat_bubble_fill` | `Icons.chat`, `Icons.message` |
| 데스크톱 / 모니터 | `CupertinoIcons.device_desktop` | `Icons.computer`, `Icons.desktop_windows` |
| 미디어 재생 | `CupertinoIcons.play_circle_fill`, `CupertinoIcons.play_arrow_solid` | `Icons.play_arrow`, `Icons.play_circle` |
| 카메라 / 사진 | `CupertinoIcons.camera_fill`, `CupertinoIcons.photo` | `Icons.camera`, `Icons.photo` |
| 쇼핑 / 배달 | `CupertinoIcons.bag_fill`, `CupertinoIcons.cart_fill` | `Icons.shopping_bag`, `Icons.delivery_dining` |
| 검색 | `CupertinoIcons.search` | `Icons.search` |
| 홈 | `CupertinoIcons.house_fill` | `Icons.home` |
| 타이포그래피 | `CupertinoIcons.textformat` | `Icons.text_fields` |
| 퀄리티 / 스파클 | `CupertinoIcons.sparkles` | `Icons.high_quality`, `Icons.star` |
| 스마트폰 디바이스 | `CupertinoIcons.device_phone_portrait` | `Icons.smartphone` |
| 보안 / 검증 | `CupertinoIcons.shield_fill` | `Icons.verified_user`, `Icons.shield` |
| 화살표 / 링크 | `CupertinoIcons.arrow_right`, `CupertinoIcons.chevron_forward` | `Icons.arrow_forward` |
| 레이어 / 스택 | `CupertinoIcons.square_stack_3d_up_fill` | `Icons.layers` |
| 배터리 / 전원 / 상태 | `CupertinoIcons.battery_full`, `CupertinoIcons.wifi`, `CupertinoIcons.power` | `Icons.battery_full`, `Icons.wifi`, `Icons.power_settings_new` |

---

## 2. Typography & Pixel Perfection
- 시스템 글꼴 매핑:
  - KakaoTalk: Pretendard / Noto Sans KR
  - iOS / macOS: Apple SD Gothic Neo / San Francisco (SF Pro)
  - Windows: Segoe UI
  - Android: Roboto
- 말풍선 곡률, 1 안읽음 카운트, 시간 표시 포맷의 실물 100% 일치 원칙.

---

## 3. Mock Workspace OS Environment
- **데스크톱 환경 (PC / Web)**:
  - Windows 11 Fluent Taskbar (중앙 정렬 시작 메뉴, 코파일럿 스타일 트레이)
  - macOS Sonoma/Sequoia 메뉴바 + 플로팅 독(Dock) 인터페이스
- **모바일 환경 (Mobile Browser / App)**:
  - iPhone iOS Lockscreen / Dynamic Island / Homescreen Dock
  - Samsung Galaxy OneUI 상태바 및 제스처 홈 인디케이터

---

## 4. Strict "No-Outline" Rule (아웃라인/외곽선 전면 금지 원칙)
> **[CRITICAL] 사이트 UI(헤더, 내비게이션 바, 사이드바, 버튼, 카드, 뱃지, 탭, 입력 폼 등) 전반에서 딱딱하고 인위적인 아웃라인(외곽선/테두리선) 사용을 전면 금지합니다.**
> - 세련되고 현대적인 감성의 모던 플랫 & 소프트 글래스모피즘(Modern Flat & Glassmorphism)을 지향하며, UI 요소를 얇은 테두리 선으로 가두는 행위를 엄격히 배제합니다.

### 1) 금지 대상 패턴 (Anti-Patterns)
- `border: Border.all(...)` (버튼, 카드, 입력창, 컨테이너 테두리)
- `side: BorderSide(...)` (버튼 또는 다이얼로그 테두리)
- `OutlinedButton` 사용 (반드시 `ElevatedButton`, `TextButton`, 또는 커스텀 `InkWell` 사용)
- `OutlineInputBorder`에 `borderSide`를 지정하는 행위 (입력 필드는 무외곽선 `borderSide: BorderSide.none` 적용)
- `ChoiceChip`의 기본 외곽선 방치 (반드시 `side: BorderSide.none` 명시)
- 모바일 디바이스의 불필요한 하드웨어 목업 섀시(노치/아일랜드가 포함된 두꺼운 검은색 스마트폰 테두리)

### 2) 권장 및 필수 대체 가이드
- **Surface & Tint 분할**: 
  - 영역 구분은 테두리 선이 아닌, 배경색의 은은한 명도 차이나 소프트한 알파 틴트로 처리합니다.
  - 다크 모드: `Colors.white.withValues(alpha: 0.05 ~ 0.08)`, `Color(0xFF141822)`, `Color(0xFF1E293B)` 등
  - 라이트 모드: `Color(0xFFF1F5F9)`, `Color(0xFFE2E8F0)`, `Color(0xFFEFF2F6)` 등
- **Soft Elevation & Ambient Shadow**:
  - 입체감과 깊이감이 필요한 경우 얇은 외곽선 대신 자연스러운 소프트 앰비언트 그림자를 사용합니다.
  - 예: `BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04), blurRadius: 16~36, offset: Offset(0, 8))`
- **Borderless Filled Buttons**:
  - 버튼은 외곽선 없이 면 색상과 둥근 모서리(`BorderRadius.circular(8~12)`)로만 명확한 계층을 형성합니다.
- **Seamless Backdrop Blur**:
  - 블러 필터(`BackdropFilter` + `ImageFilter.blur`)와 투명도 그라데이션을 조합하여 경계선 없이 배경과 부드럽게 융합되도록 연출합니다.

