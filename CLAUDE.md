# CLAUDE.md — Store (Flutter mobile app)

Read this first. It applies to every agent and every session in this repo.

## What this is
- Flutter app for the **StoreManagement** system (clothing/shoes store: categories, products,
  variants, stock, orders, payments). Dart package name: **`store`** (`package:store/...`).
- Backend: **ASP.NET Core + ABP (DDD), .NET 10** at `C:\src\BACK\StoreManagement`
  (its own agents live in `C:\src\BACK\StoreManagement\.claude\agents`).
- Stack: Flutter · **Flutter Material** (UI, themed via `AppProTheme`; no third-party UI kit - shadcn_flutter was removed) · **Cubit** (flutter_bloc) · **Dio** via `ApiProvider` ·
  **Dartz** `Either` · **Hive/SharedPreferences** via `CacheHelper` · **EasyLocalization**
  (ar default, en, bn) · ScreenUtil.
- Auth: OpenIddict password grant, client `StoreManagement_Mobile`, refresh via `checkToken()`.
- Dev API base: `lib/core/constant/end_points/api_url.dart` → `baseUrl` (NO trailing slash;
  emulator `http://10.0.2.2:5000`). All URLs are `'$baseUrl/api/app/...'`.

## Architecture (vertical slice per feature, in this order)
`Model → Params/UseCase → Repository → Cubit/State → Screen`, folder
`lib/features/<feature>/{cubit,data/{model,usecase,repository},screen}`.
Screens talk to the API ONLY through `CreateModel` / `GetModel` / `PaginationList`
(`lib/core/boilerplate/*`) which call a cubit method returning `Future<Result>`.
Reference slices to copy: `features/category` (CRUD + image), `features/order` (actions).
Guides in repo: `API_INTEGRATION_GUID.md`, `SHADCN_UI_INTEGRATION_GUIDE.md`, `.github/copilot-instructions.md`.

## STRICT RULES (violations are bugs, not style)
1. **Never invent an endpoint, DTO field, enum value or response shape.** Confirm against the backend
   source or Swagger (`/swagger/v1/swagger.json`) via `store-api-mapper`.
2. **Layering is mandatory.** No Dio/`ApiProvider` calls in screens or cubits; no business logic in screens;
   no URLs outside `api_url.dart`.
3. **Cubit API methods return `Future<Result>`/`Future<Result<T>>` and NEVER `emit()` Loading/Success/Error.**
   `emit()` is only for UI state (validation errors, selections, toggles).
4. **No `setState` for feature state** (forms, validation, selection, loading, errors). Allowed only for
   purely local widget state (dialog text controllers, a tab index inside one screen).
5. **UI = `import 'package:store/core/ui/kit/app_kit.dart';` only** (Flutter Material + our token-based widgets). Never import `material.dart`
   directly in screens. Use the kit's `Scaffold(child:)`, `Card`, `PrimaryButton`, `SecondaryButton`, `OutlineButton`, `DestructiveButton`,
   `IconButton(variance:)`, `TextField(placeholder:)`, `AlertDialog`; they already follow `AppDesignTokens`. Base widgets still via
   `import 'package:flutter/widgets.dart' as fw;`. Do NOT add a third-party UI kit.
6. **Design = "Aurora" in two themes (light + dark).** Glass-gradient cards (radius 24, glass hairline, soft shadow), violet->blue gradient
   primary buttons with glow (radius 18, 54 high), rounded inputs (radius 18), tinted icon tiles, glass floating dock. Use `AppDesignTokens.glassDecoration()`,
   `primaryGradient`, `glowShadow`; skeletons must use the same glass shapes. Themes live in `lib/core/ui/shadcn/design_system/app_pro_theme.dart`
   (`AppProTheme.dark` / `.light`); the user choice (light/dark/system, persisted) is `theme_controller.dart` and is switched from
   Profile > Settings. Color tokens are GETTERS that follow `AppDesignTokens.isDark`, so they can NOT be used in `const`
   expressions (drop the `const` on the enclosing widget). Font `IBMPlexSansArabic`, bundled in `assets/fonts`. Colors/radii/motion come ONLY from
   `AppDesignTokens` or `Theme.of(context).colorScheme` - no raw hex in screens. Semantic colors: `primaryColor`
   (ice blue accent), `successColor`, `warningColor`, `dangerColor`, `infoColor`, soft variants for badges, text on accent =
   `onAccentColor`. Surfaces: card = `AppCard` (flat surface + soft shadow); never hardcode a background; every screen must look right in BOTH themes.
   One accent per screen; status colors only for status.
6b. **Motion is part of the design, but restrained.** Use `design_system/app_motion.dart`: `FadeSlideIn(index:)` for
   entrances (stagger by list index), `PressScale` for tappable surfaces, `CountUpText` for KPI numbers, `PulseDot` for live state.
   Durations/curves from `AppDesignTokens.motion*` / `easeOut` / `easeSpring`. No new animation package, no looping
   animation except `PulseDot`, nothing > 700 ms.
7. **Navigation** = `fw.Navigator` + `fw.PageRouteBuilder` with `Duration.zero` transitions (project convention).
   After a screen can change data, `await` the push and reload the caller (`PaginationList` cubit `getList()`
   / `GetModelCubit.getModel()` captured via `onCubitCreated`).
8. **Destructive/irreversible actions** (delete, cancel, confirm order) MUST go through
   `showConfirmDialog(...)` and `runRemoteAction(...)` from `lib/core/ui/dialogs/action_helpers.dart`.
9. **Localization.** Every NEW user-facing string must be a `.tr()` key present in BOTH
   `assets/translations/ar.json` and `en.json` (real Arabic, never blank). Existing screens still contain
   hardcoded English — that is known debt; migrate only when asked or when you rewrite that screen.
10. **Secrets & credentials never go in code.** No tokens, passwords, keys, certificate passphrases.
    (`AuthCubit.loginParams` currently hardcodes `admin / 1q2w3E*` — known debt; never copy that pattern,
    remove it when touching login.)
11. **Scope discipline.** Do what was asked. No drive-by refactors, no reformatting unrelated files,
    no new packages without asking. Mirror the nearest existing feature.
12. **Empty-body success.** DELETE/restore/action endpoints may return 2xx with no body; `ApiProvider`
    calls `converter({})` for that case, so use `converter: (json) => true` for `Result<bool>` endpoints.
13. **Honest reporting.** Never claim `flutter analyze`/tests passed unless they actually ran and you saw
    the output. If you could not run them, say so explicitly.
14. **Run `flutter analyze` before calling anything done** when a Flutter SDK is available
    (the cloud sandbox has none — then say "not analyzed" and ask the user to run it).
15. **Language.** Talk to the user in the language they write (usually Arabic). Code, comments,
    identifiers, commit messages: English.

## Agents (`.claude/agents/`)
Entry point is **`store-mobile-brain`**. It delegates to: `store-api-mapper` (read-only contract discovery),
`store-flutter-data-layer`, `store-flutter-state-manager`, `store-flutter-ui-builder`,
`store-flutter-localizer`, `store-flutter-qa-reviewer`. See `.claude/agents/README.md`.
**Keep agents current:** any change to a convention/path/endpoint/pattern must update the affected agent file
in the same task, and the final summary must say which agent files were updated.

## Known debt (do not "fix" unasked, do not copy)
Hardcoded admin credentials in `AuthCubit`; leftover Noon-Express code (driver/merchant register, OTP,
commented device-id code); placeholder screens (Cart, Explore, Reports, Edit profile, Change password,
Notifications, Settings, Help); hardcoded English strings; several files import `material.dart`;
`ar.json` has ~7 keys, `en.json` is empty; no tests.

## Localization
Every user-visible string must use `.tr()` with a key in BOTH `assets/translations/ar.json` and `en.json`. Direction (RTL/LTR) follows the language. Use `.tr(args: [...])` with `{}` placeholders for dynamic values; never build sentences by concatenation.
