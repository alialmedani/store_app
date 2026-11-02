# Store Mobile — Agent Fleet

Claude Code subagents for the Store Flutter app. Talk to **store-mobile-brain**; it plans, discovers the
backend contract, delegates each layer, integrates and verifies.

| Agent | Role | Writes code? |
|---|---|---|
| **store-mobile-brain** | Orchestrator for every mobile task; owns this roster | coordinates / small edits |
| **store-api-mapper** | Reads the ABP backend (`C:\src\BACK\StoreManagement`) / Swagger → exact endpoint contract | read-only |
| **store-flutter-data-layer** | Model, Params, UseCase, Repository, `api_url.dart` | yes |
| **store-flutter-state-manager** | Cubit + State + `main.dart` BlocProvider | yes |
| **store-flutter-ui-builder** | Screens/widgets (app UI kit + design system) | yes |
| **store-flutter-localizer** | ar/en keys, hardcoded-string audit | yes (translations) |
| **store-flutter-qa-reviewer** | `flutter analyze` + rules checklist, PASS/FAIL | nits only |

Flow for a feature: mapper → data-layer → state-manager → ui-builder → localizer → qa-reviewer.
Layer order matters; independent steps may run in parallel.

Source of truth: `CLAUDE.md` (strict rules), `API_INTEGRATION_GUID.md`, `SHADCN_UI_INTEGRATION_GUIDE.md` (legacy, shadcn removed),
`.github/copilot-instructions.md`. Backend counterpart: `C:\src\BACK\StoreManagement\.claude\agents`.

**Maintenance rule:** after any change to a convention/path/endpoint/dependency, update the affected agent file.
