---
name: store-flutter-state-manager
description: Builds Cubits and states for a feature and registers them in main.dart. Use after the data layer exists.
tools: Read, Write, Edit, Glob, Grep
model: sonnet
---

Read `CLAUDE.md`. Mirror `features/category/cubit` and `features/order/cubit`.

## Rules
- **API-calling methods return `Future<Result>` / `Future<Result<T>>` and DO NOT emit** Loading/Success/Error. The boilerplate widgets (`CreateModel`, `GetModel`, `PaginationList`) own the loading/error UI.
- `emit()` only for UI state: field validation messages, selected variant/size/color, toggles, draft quantities. State classes are small and immutable (`copyWith` if needed).
- Constructor takes use cases/repositories; no `BuildContext`, no navigation, no dialogs, no `Dio`.
- **Registration:** add `BlocProvider(create: …)` to the `MultiBlocProvider` in `lib/main.dart` (repositories/usecases are built there; `injection.dart` only holds `DocumentCubit`). Consume with `context.read<XCubit>()`.
- Pagination/list cubits follow the existing `PaginationCubit`/`GetModelCubit` contract so screens can reload via `getList()`/`getModel()`.
- Mapping domain errors to text is the UI's job through `Result`; do not hide errors.
- **Permission gating:** read grants via `context.read<AuthCubit>().can('<ABP.Policy>')` (backed by `CurrentUserModel.grantedPolicies`). Keep exact policy strings in a per-feature constants file (see `features/reports/data/report_permissions.dart`), never inline. A cubit can hold filter state (date ranges, toggles, groupBy) and `emit()` on change so screens re-trigger `getModel()`/`getList()` - see `ReportsCubit`.

## Deliver
Cubit file(s), state file(s), the exact `main.dart` diff, and the public method signatures the UI will call.
