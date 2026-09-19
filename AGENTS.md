# FictionScreen Agent Rules

## 🚨 [CRITICAL RULE] ZERO OUTLINE - NO BORDERS, NO OUTLINES
- Do NOT use any outlines, borders, or stroke borders anywhere in this project.
- CSS: `border: ...`, `outline: ...` are strictly FORBIDDEN.
- Flutter: `border: Border.all(...)`, `side: BorderSide(...)`, `OutlinedButton` are strictly FORBIDDEN.
- Use surface tint contrasts, glassmorphism (`BackdropFilter`), and soft ambient shadows (`BoxShadow`) instead.

## 2. CupertinoIcons ONLY
- Material `Icons.*` are strictly FORBIDDEN.
- Only use `CupertinoIcons.*`.

## 3. Button Feedback: Scale Down (ScaleButton)
- Click/tap feedback must be physical scale-down animation (`ScaleButton`), not simple inkwell color ripple.

## 4. Global Theme Synchronization
- Always respect `AppThemeService.instance`.
