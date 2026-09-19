# FictionScreen Global Rules (프로젝트 전역 필수 수칙)

## 🚨 [최우선 절대 원칙] ZERO OUTLINE - 아웃라인(외곽선/테두리선) 사용 전면 금지

**프로젝트의 모든 UI(로딩 화면, 랜딩 페이지, 로그인 페이지, 콘솔, 에디터, 스튜디오, 모달, 카드, 버튼, 뱃지, 입력창, 탭 등)에서 인위적인 테두리선(border, outline) 사용을 엄격히 금지합니다.**

### 1. 금지 대상 (Anti-Patterns - 전면 사용 금지)
- ❌ CSS: `border: 1px solid ...`, `border: ...`, `outline: ...`, `box-shadow: 0 0 0 1px ...` 절대 사용 금지.
- ❌ Flutter: `border: Border.all(...)` 사용 금지.
- ❌ Flutter: `side: BorderSide(...)` 사용 금지.
- ❌ Flutter: `OutlinedButton` 사용 금지.
- ❌ Flutter: `OutlineInputBorder`에 `borderSide` 유색 지정 금지 (반드시 `borderSide: BorderSide.none` 적용).
- ❌ Flutter: `ChoiceChip`이나 `Chip`에 테두리선 방치 금지 (`side: BorderSide.none` 적용).

### 2. 올바른 스타일링 가이드
- **Surface & Tint 분할**: 영역 구분은 테두리 선이 아닌, 배경색의 은은한 명도 차이나 소프트한 알파 틴트로 처리합니다.
- **Soft Ambient Shadows**: 깊이감과 층위 분리는 얇은 선이 아닌 부드러운 앰비언트 블러 그림자(`BoxShadow`)로 구현합니다.
- **Borderless Filled UI**: 버튼, 카드, 모달, 뱃지는 외곽선 없는 솔리드/글래스 면과 둥근 모서리(`BorderRadius.circular`)로만 디자인합니다.

---

## 2. Strict Icon Rule (아이콘 전용 규격)
- **[MANDATORY]** 모든 UI 컴포넌트의 아이콘은 반드시 `CupertinoIcons`만 사용합니다.
- Material Design의 `Icons.*` 사용은 프로젝트 전역에서 **전면 금지**됩니다.

---

## 3. 버튼 클릭 반응 = 스케일 축소 (ScaleButton)
- **[MANDATORY]** 버튼 클릭 시 단순한 잉크웰 색상 변경이 아닌, 물리적인 스케일 축소(`ScaleButton`) 바운스 피드백을 적용합니다.

---

## 4. 전역 테마 동기화 (AppThemeService)
- 기기 설정값(`ThemeMode.system`) 기본 적용.
- 사용자가 변경한 테마는 비로그인 세션 메모리/로컬스토리지 유지 및 로그인 유저 Firestore(`users/{uid}/settings/theme_config`) 영구 저장.
- 모든 화면에서 `AppThemeService.instance.isDarkMode(context)` 및 `AppThemeService.instance.toggleTheme(context)` 사용.
