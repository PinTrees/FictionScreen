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
