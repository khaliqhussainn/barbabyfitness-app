# Bar Baby Fitness — Project Specification

> **Living Document.** Every architectural or feature change must append to this file.  
> Do not overwrite existing entries. Add new changelog entries at the top of the Changelog section.

---

## Project Overview

**App Name:** Bar Baby Fitness  
**Platform:** Flutter (Android First)  
**Language:** Dart  
**Repository:** khaliqhussainn/barbabyfitness-app  
**Status:** Foundation complete — ready for feature development

Bar Baby Fitness is a fitness application targeting Android as the primary platform. The codebase is built for long-term maintainability with clean architecture, strict linting, and scalable state management from day one.

---

## Goals

- Deliver a production-quality Flutter application
- Keep architecture scalable as the feature set grows
- Ensure the codebase is readable by any Flutter developer without tribal knowledge
- Avoid over-engineering: every file and abstraction earns its place

---

## Tech Stack

| Concern | Choice | Version |
|---------|--------|---------|
| Language | Dart | ^3.5.0 |
| Framework | Flutter | Latest stable |
| State Management | flutter_riverpod | ^2.6.1 |
| Navigation | go_router | ^14.6.2 |
| Responsive UI | flutter_screenutil | ^5.9.3 |
| Typography | google_fonts | ^6.2.1 |
| SVG Assets | flutter_svg | ^2.0.10+1 |
| Remote Images | cached_network_image | ^3.4.1 |
| Formatting/i18n | intl | ^0.19.0 |
| Value Equality | equatable | ^2.0.5 |

---

## Architecture

### Pattern: Feature-First Clean Architecture

Each feature is self-contained under `lib/features/<feature_name>/`. Cross-cutting concerns live in `lib/core/` and `lib/shared/`.

### Layer Structure (per feature)

```
features/<feature>/
  data/
    datasources/        # Remote and local data sources
    models/             # DTOs with fromJson/toJson
    repositories/       # Repository implementations
  domain/
    entities/           # Pure Dart business objects
    repositories/       # Abstract repository interfaces
    usecases/           # Single-responsibility business actions
  presentation/
    pages/              # Full-screen route destinations
    widgets/            # Feature-scoped widgets
    providers/          # Riverpod providers for this feature
```

### Cross-Cutting Modules

```
lib/
  core/
    errors/             # Failure sealed class + Exception types
    usecases/           # UseCase / SyncUseCase / NoParams abstractions
    utils/              # AppLogger
  config/
    routes/             # GoRouter provider + RouteNames
    theme/              # AppTheme, AppColors, AppTypography
  shared/
    constants/          # App-wide constants
    extensions/         # Dart/Flutter extension methods
    pages/              # Shared route pages (UnknownPage)
    utils/              # ResponsiveConfig
```

---

## Folder Structure

```
barbabyfitness-app/
├── assets/
│   ├── fonts/
│   ├── icons/
│   └── images/
├── docs/
│   └── PROJECT_SPEC.md
├── lib/
│   ├── app.dart
│   ├── main.dart
│   ├── config/
│   │   ├── routes/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   └── theme/
│   │       ├── app_colors.dart
│   │       ├── app_theme.dart
│   │       └── app_typography.dart
│   ├── core/
│   │   ├── errors/
│   │   │   ├── exceptions.dart
│   │   │   └── failures.dart
│   │   ├── usecases/
│   │   │   └── usecase.dart
│   │   └── utils/
│   │       └── logger.dart
│   ├── features/
│   │   ├── auth/
│   │   │   └── presentation/pages/
│   │   │       ├── forgot_password_page.dart
│   │   │       ├── login_page.dart
│   │   │       └── signup_page.dart
│   │   ├── home/
│   │   │   └── presentation/pages/
│   │   │       └── home_page.dart
│   │   ├── onboarding/
│   │   │   └── presentation/pages/
│   │   │       └── onboarding_page.dart
│   │   └── splash/
│   │       └── presentation/pages/
│   │           └── splash_page.dart
│   └── shared/
│       ├── constants/
│       │   └── app_constants.dart
│       ├── extensions/
│       │   ├── context_extensions.dart
│       │   └── string_extensions.dart
│       ├── pages/
│       │   └── unknown_page.dart
│       └── utils/
│           └── responsive_config.dart
├── test/
├── analysis_options.yaml
└── pubspec.yaml
```

---

## Dependency Decisions

| Package | Reason | Alternatives Considered |
|---------|--------|------------------------|
| flutter_riverpod | Compile-safe, testable, scales with async state | Provider (too simple), BLoC (too verbose) |
| go_router | Official Flutter navigation, deep link ready | AutoRoute (code-gen overhead not justified yet) |
| flutter_screenutil | Proportional sizing without manual MediaQuery math | None — standard choice |
| google_fonts | Easy font swapping once Figma delivers | Custom fonts (added later via assets/fonts) |
| flutter_svg | Required for logo and icon assets | None |
| cached_network_image | Network image caching for performance | None |
| equatable | Value equality without boilerplate | Freezed (code-gen not justified at this stage) |
| intl | Date/number formatting, i18n groundwork | None |

**Deliberately excluded:** Firebase, Dio, Hive, Isar, analytics, crashlytics — none are needed until backend is defined.

---

## Routing Strategy

- **Router:** GoRouter via `goRouterProvider` (Riverpod `Provider<GoRouter>`)
- **Route names:** Defined as `static const` strings in `RouteNames` (both path and name variants)
- **Error handling:** `errorBuilder` renders `UnknownPage` for any unmatched route
- **Auth guard:** Will be added as a GoRouter `redirect` callback once auth feature is implemented
- **Deep links:** GoRouter supports them natively; configure `AndroidManifest.xml` when needed

### Registered Routes

| Name | Path | Page |
|------|------|------|
| splash | `/` | SplashPage |
| onboarding | `/onboarding` | OnboardingPage |
| login | `/login` | LoginPage |
| signup | `/signup` | SignupPage |
| forgot-password | `/forgot-password` | ForgotPasswordPage |
| home | `/home` | HomePage |
| _(error)_ | any unmatched | UnknownPage |

---

## Theme Strategy

- **Material 3** is enabled (`useMaterial3: true`)
- **ThemeMode:** `ThemeMode.dark` — all Figma screens are dark; light theme pending design
- **AppColors:** Brand colors extracted from Figma (updated 2026-06-30)
- **AppTypography:** Inter (via `google_fonts`) as placeholder — final font from Figma
- **AppTheme:** Exposes `static final ThemeData light` and `dark`
- **Design dimensions:** 390×844 (iPhone 14 base) — update `ResponsiveConfig` when Figma frames are confirmed

---

## Coding Standards

- Feature-First structure — features are the primary boundary, not layers
- SOLID principles at the usecase and repository level
- DRY — no copy-paste; extract to shared only when used in 2+ features
- KISS — simplest correct implementation; no speculative abstractions
- Effective Dart naming: `lowerCamelCase` for variables/methods, `UpperCamelCase` for types, `snake_case` for files
- No `print()` — use `AppLogger` in debug mode only
- No `dynamic` — strict typing enforced by analyzer
- Prefer `const` constructors everywhere possible
- `sealed class` for exhaustive pattern matching on domain types

---

## Naming Conventions

| Kind | Convention | Example |
|------|-----------|---------|
| Files | `snake_case.dart` | `login_page.dart` |
| Classes | `UpperCamelCase` | `LoginPage` |
| Methods/vars | `lowerCamelCase` | `fetchUserProfile` |
| Constants | `lowerCamelCase` | `appName` |
| Riverpod providers | `lowerCamelCaseProvider` | `goRouterProvider` |
| Abstract utility classes | `abstract final class` | `AppColors` |
| Route names | suffix `Name` for named, raw path for path | `loginName`, `login` |

---

## Development Workflow

1. Pull latest from `main`
2. Branch: `feature/<feature-name>` or `fix/<issue>`
3. Implement feature in its feature folder following the layer structure
4. Add/update providers in `features/<name>/presentation/providers/`
5. Register new routes in `app_router.dart` and `route_names.dart`
6. Run `flutter analyze` — zero warnings required before PR
7. Run `flutter test`
8. PR → code review → merge to `main`

---

## Future Modules

The following features are expected but not started. Each will follow the full Clean Architecture layer structure.

| Module | Notes |
|--------|-------|
| Authentication | Login, Signup, Forgot Password flows |
| Onboarding | Multi-step user onboarding |
| User Profile | Profile management |
| Workout Tracker | Core fitness feature — TBD from product |
| Notifications | Push notifications (FCM) |
| Settings | App preferences, theme toggle |

---

## Backend Preparation Notes

- No backend is integrated yet
- When backend is defined, add to pubspec: `dio` (HTTP), `retrofit` or manual datasources, chosen local DB
- Repository pattern is already in place — datasource implementations slot in under `data/`
- `UseCase<Type, Params>` is defined but returns `Future<Type>` directly; when backend arrives, consider adding `fpdart` for `Either<Failure, T>` typed results
- Auth redirect in GoRouter will be activated by watching an auth state provider
- Environment config (base URLs, keys) should go in `lib/config/env/` using `--dart-define` at build time

---

## Decision Log

| Date | Decision | Reason |
|------|----------|--------|
| 2026-06-30 | Feature-First over Layer-First architecture | Better scalability; features are added/removed as units, not scattered across layers |
| 2026-06-30 | Riverpod over BLoC | Less boilerplate, better IDE support, no event/state ceremony for simple cases |
| 2026-06-30 | GoRouter as sole navigation layer | Official package, deep link ready, auth redirect via `redirect` callback |
| 2026-06-30 | No Either/fpdart at this stage | No backend yet; adding it now would be premature abstraction |
| 2026-06-30 | Inter as placeholder font | Neutral, readable, easily swapped when Figma delivers final typeface |
| 2026-06-30 | 390×844 as ScreenUtil base | iPhone 14 Pro standard; update when Figma frames are confirmed |
| 2026-06-30 | abstract final class for utilities | Prevents instantiation and inheritance of pure-utility namespaces |
| 2026-06-30 | sealed class for Failure | Enables exhaustive pattern matching when backend error types are handled |

---

## Changelog

### 2026-06-30 — Splash & Onboarding Screens

**Screen Implemented:** Splash Screen + Onboarding Screen

**Splash Screen**
- Purpose: App entry point; displays brand logo for 2 seconds then navigates to Onboarding
- Navigation: Auto-navigates to `/onboarding` after `Duration(seconds: 2)` via `context.go`
- Components: `_RingLogoPainter` (CustomPainter — two concentric orange arcs, local to page)
- Backend Hooks: None. In future, replace timer with async auth check (if user is logged in, skip to home)

**Onboarding Screen**
- Purpose: First-run user entry point; introduces the app value proposition
- Navigation: "Get Started" → `/signup` · "Log In" → `/login`
- Components:
  - `AppPrimaryButton` (extracted to `shared/widgets/` — reused across all auth screens)
  - `_OutlineButton` (local to OnboardingPage — appears on this screen only)
  - `_GridPainter` (CustomPainter — subtle white grid overlay on dark background, local to page)
- Backend Hooks: None at this stage. "Get Started" and "Log In" routes will eventually carry auth context

**Files Added**
- `lib/shared/widgets/app_primary_button.dart` — reusable orange pill button
- `lib/features/splash/presentation/pages/splash_page.dart` — implemented (was stub)
- `lib/features/onboarding/presentation/pages/onboarding_page.dart` — implemented (was stub)

**Files Modified**
- `lib/config/theme/app_colors.dart` — replaced placeholders with Figma brand colors
- `lib/config/theme/app_theme.dart` — applied brand colors to dark theme; dark theme is now primary
- `lib/app.dart` — changed `ThemeMode.system` → `ThemeMode.dark`
- `docs/PROJECT_SPEC.md` — appended screen log

**Architectural Decisions**
- `ThemeMode.dark` hardcoded — all 5 Figma screens are dark-only; light mode is deferred
- `AppPrimaryButton` extracted immediately — confirmed present on 4 of 5 auth screens
- `_GridPainter` and `_RingLogoPainter` kept local (private classes) — not reused elsewhere
- Splash uses `StatefulWidget` for `initState` timer; navigation in `mounted` guard prevents leaks
- No Riverpod providers needed at this stage for these screens — added when auth state drives navigation

**Brand Colors (from Figma)**
| Token | Value |
|-------|-------|
| background | `#0D0D0D` |
| primary | `#F97316` |
| textPrimary | `#FFFFFF` |
| textSecondary | `#8E8E93` |
| surface | `#1C1C1E` |
| inputBorder | `#3A3A3C` |
| error | `#EF4444` |

---

### 2026-06-30 — Foundation

- Initialized Feature-First Clean Architecture folder structure
- Added dependencies: flutter_riverpod, go_router, flutter_screenutil, google_fonts, flutter_svg, cached_network_image, intl, equatable
- Configured strict analyzer (strict-casts, strict-inference, strict-raw-types) and production linting rules
- Created `AppTheme` (light/dark), `AppColors` (placeholder), `AppTypography` (Inter placeholder)
- Set up `GoRouter` as a Riverpod provider with 6 placeholder routes + unknown error route
- Implemented `ProviderScope` at app root in `main.dart`
- Wrapped app with `ScreenUtilInit` (390×844 design base)
- Created `core/errors/` (Failure sealed class, Exception types), `core/usecases/` (UseCase interfaces), `core/utils/` (AppLogger)
- Created `shared/` module: AppConstants, ResponsiveConfig, context/string extensions
- Set up `assets/images/`, `assets/icons/`, `assets/fonts/` directories
- Created `docs/PROJECT_SPEC.md` as living specification
