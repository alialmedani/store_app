# Copilot Instructions - Store Management Flutter Architecture

## Important

This project has its own architecture. Do not invent a new structure.

Always follow the existing architecture and naming conventions in this repository.

Before implementing or modifying any API feature or UI screen, read the related existing files first and follow the same pattern.

Reference guides:
- docs/API_INTEGRATION_GUIDE.md
- docs/SHADCN_UI_INTEGRATION_GUIDE.md

Modify only the requested file or feature. Do not refactor unrelated files unless explicitly asked.

---

## Project Architecture

This project follows this flow:

```text
Screen
→ Widget Wrapper
→ Cubit
→ UseCase
→ Repository
→ RemoteDataSource
→ ApiProvider / Dio
→ API
```

The UI must not call Dio directly.

The screen only handles UI and user interaction.

The Cubit manages:
- Params
- UI state
- Validation errors
- Toggle states
- Selection states
- API method calls through UseCases

The UseCase represents the business action.

The Repository handles API requests.

The RemoteDataSource / ApiProvider handles the actual HTTP/Dio call.

---

## Folder Structure

For every feature, follow this structure:

```text
lib/features/{module}/{feature}/
├── cubit/
│   ├── {feature}_cubit.dart
│   └── {feature}_state.dart
├── data/
│   ├── model/
│   │   └── {entity}_model.dart
│   ├── repository/
│   │   └── {feature}_repository.dart
│   └── usecase/
│       ├── create_{entity}_usecase.dart
│       ├── get_{entity}_usecase.dart
│       ├── update_{entity}_usecase.dart
│       └── delete_{entity}_usecase.dart
└── screen/
    └── {feature}_screen.dart
```

Do not create random folders.

Do not move files to a different architecture.

Do not introduce a new architecture.

---

## API Integration Rules

When adding a new API endpoint, implement in this order:

1. Model
2. Params
3. UseCase
4. Repository
5. Cubit
6. Screen

For POST / PUT / PATCH:
- Use `data: params.toJson()`

For GET:
- Use `queryParameters: params.toJson()`

For authenticated APIs:
- Use `withAuthentication: true`

For public APIs:
- Use `withAuthentication: false`

For single object responses:
- Use `call(result: result)`

For list or paginated responses:
- Use `paginatedCall(result: result)`

Do not call ApiProvider or Dio directly from screens.

Do not put API URLs directly inside screens.

Do not put business logic inside screens.

---

## State Management Rules

Use Cubit for state management.

Avoid `setState`.

Do not use `setState` for:
- Form fields
- Validation errors
- Checkbox state
- Switch state
- Dropdown selection
- Password visibility
- Loading state
- API success state
- API error state
- Selected item state

Use Cubit variables and Cubit methods instead.

Use `BlocBuilder` when UI needs to rebuild based on Cubit state.

Use `context.read<Cubit>()` for one-time actions like:
- Button clicks
- TextField onChanged
- Dropdown selection
- Checkbox change
- Triggering API calls

---

## Emit Rules

API methods inside Cubit must NOT manually call `emit()`.

Wrong:

```dart
Future<Result> createItem() async {
  emit(Loading());
  final result = await CreateItemUsecase(ItemRepository()).call(params: params);
  emit(Success());
  return result;
}
```

Correct:

```dart
Future<Result> createItem() async {
  return await CreateItemUsecase(ItemRepository()).call(params: params);
}
```

The boilerplate widgets handle Loading / Success / Error automatically.

Allowed manual `emit()` only for UI state changes, such as:
- Validation errors
- Clearing validation errors
- Checkbox changes
- Switch changes
- Dropdown selections
- Password visibility toggle
- Selected item changes

Example:

```dart
String? nameError;

void setNameError(String error) {
  nameError = error;
  emit(CategoryInitial());
}

void clearNameError() {
  nameError = null;
  emit(CategoryInitial());
}
```

---

## Boilerplate Widget Rules

Use the existing boilerplate widgets.

Use:

- `CreateModel` for POST / PUT / DELETE
- `GetModel` for fetching a single item
- `PaginationList` for list APIs and paginated APIs

Do not replace these wrappers with custom loading/error handling unless explicitly required.

The Cubit method passed to these widgets must return `Future<Result>` or `Future<Result<T>>`.

Example:

```dart
CreateModel<CategoryModel>(
  withValidation: true,
  onTap: () {
    return _validateForm();
  },
  useCaseCallBack: (data) {
    return context.read<CategoryCubit>().createCategory();
  },
  onSuccess: (category) {
    // success feedback
  },
  onError: (error) {
    // error feedback
  },
  child: PrimaryButton(
    child: const Text('Create Category'),
  ),
)
```

---

## shadcn_flutter UI Rules

New UI screens should use `shadcn_flutter` components.

Use `ShadcnApp` in `main.dart`, not `MaterialApp`.

Use shadcn components such as:
- `TextField`
- `PrimaryButton`
- `SecondaryButton`
- `OutlineButton`
- `DestructiveButton`
- `GhostButton`
- `Card`
- `AlertDialog`
- `Select`
- `Badge`
- `IconButton`
- `Switch`
- `Checkbox`

Use `Theme.of(context)` and the shadcn color scheme when possible.

Avoid unnecessary hardcoded colors.

Use:
- `PrimaryButton` for main actions
- `SecondaryButton` or `OutlineButton` for secondary actions
- `DestructiveButton` for delete/danger actions
- `GhostButton` for minimal actions
- `Card` for grouped content
- `Badge` for status labels
- `AlertDialog` for success, error, and confirmation messages

---

## Form Rules

Form params must be stored in the Cubit.

Text field `onChanged` should update Cubit params directly.

Example:

```dart
TextField(
  controller: _nameController,
  placeholder: const Text('Name'),
  onChanged: (value) {
    final cubit = context.read<CategoryCubit>();
    cubit.createCategoryParams.name = value;
    cubit.clearNameError();
  },
)
```

Validation errors must be stored in the Cubit.

Example:

```dart
String? nameError;

void setNameError(String error) {
  nameError = error;
  emit(CategoryInitial());
}

void clearNameError() {
  nameError = null;
  emit(CategoryInitial());
}
```

Display errors under fields using `BlocBuilder`.

Example:

```dart
BlocBuilder<CategoryCubit, CategoryState>(
  builder: (context, state) {
    final cubit = context.read<CategoryCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _nameController,
          placeholder: const Text('Name'),
          onChanged: (value) {
            cubit.createCategoryParams.name = value;
            cubit.clearNameError();
          },
        ),
        if (cubit.nameError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              cubit.nameError!,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  },
)
```

Controllers must be disposed in `dispose()`.

Example:

```dart
@override
void dispose() {
  _nameController.dispose();
  _descriptionController.dispose();
  super.dispose();
}
```

---

## Screen Rules

Each screen should be clean and readable.

A screen should:
- Build the UI
- Use shadcn components
- Update Cubit params
- Trigger Cubit methods through CreateModel / GetModel / PaginationList
- Show success/error dialogs or messages
- Use BlocBuilder for reactive UI
- Dispose controllers

A screen should NOT:
- Call Dio directly
- Hold API business logic
- Use setState for feature state
- Manually manage loading/success/error for API calls if wrapper widgets are available
- Create random local state when Cubit state is required

---

## Pagination Rules

Use `PaginationList` for paginated list screens.

Pagination means loading data page by page instead of loading all data at once.

The Cubit method should receive pagination data and pass it to the UseCase.

Example:

```dart
Future<Result> fetchCategoryList(data) async {
  return await GetCategoryListUsecase(CategoryRepository())
      .call(params: GetCategoryParams(request: data));
}
```

Repository list methods should use `paginatedCall(result: result)`.

Example:

```dart
Future<Result<List<CategoryModel>>> getCategoryListRequest({
  required GetCategoryParams params,
}) async {
  final result = await RemoteDataSource.request<List<CategoryModel>>(
    withAuthentication: true,
    url: getCategoryListUrl,
    method: HttpMethod.GET,
    queryParameters: params.toJson(),
    converter: (json) {
      final List<dynamic> data = json['items'] ?? json['data'] ?? [];
      return data.map((item) => CategoryModel.fromJson(item)).toList();
    },
  );

  return paginatedCall(result: result);
}
```

---

## Model Rules

Models should contain:
- Nullable fields when API fields are optional
- `fromJson`
- `toJson`

Example:

```dart
class CategoryModel {
  final String? id;
  final String? name;
  final String? description;
  final bool? isActive;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }
}
```

Match JSON keys exactly as returned by the API.

Handle dates safely with `DateTime.parse()` only when the value is not null.

Use `toIso8601String()` when sending dates to the API.

---

## Params Rules

Params classes should be inside UseCase files.

Params used by Cubit and `onChanged` must be mutable.

Do not make fields `final` if the UI updates them directly.

Example:

```dart
class CreateCategoryParams extends BaseParams {
  String name;
  String description;
  bool isActive;

  CreateCategoryParams({
    required this.name,
    required this.description,
    required this.isActive,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }
}
```

---

## Repository Rules

Repositories should:
- Extend `CoreRepository`
- Call `RemoteDataSource.request`
- Use correct HTTP method
- Use `data` for POST / PUT / PATCH
- Use `queryParameters` for GET
- Use `withAuthentication` correctly
- Convert API response using `converter`
- Return `call(result: result)` for single models
- Return `paginatedCall(result: result)` for paginated lists

Example:

```dart
class CategoryRepository extends CoreRepository {
  Future<Result<CategoryModel>> createCategoryRequest({
    required CreateCategoryParams params,
  }) async {
    final result = await RemoteDataSource.request<CategoryModel>(
      withAuthentication: true,
      url: createCategoryUrl,
      method: HttpMethod.POST,
      data: params.toJson(),
      converter: (json) => CategoryModel.fromJson(json),
    );

    return call(result: result);
  }
}
```

---

## UseCase Rules

UseCases should extend `UseCase<T, Params>`.

UseCases should call repository methods only.

Example:

```dart
class CreateCategoryUsecase
    extends UseCase<CategoryModel, CreateCategoryParams> {
  final CategoryRepository repository;

  CreateCategoryUsecase(this.repository);

  @override
  Future<Result<CategoryModel>> call({
    required CreateCategoryParams params,
  }) {
    return repository.createCategoryRequest(params: params);
  }
}
```

---

## Cubit Rules

Cubit should contain:
- Params objects
- UI state variables
- UI state methods with emit
- API methods without emit

Example:

```dart
class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  CreateCategoryParams createCategoryParams = CreateCategoryParams(
    name: '',
    description: '',
    isActive: true,
  );

  String? nameError;
  String? descriptionError;

  void setNameError(String error) {
    nameError = error;
    emit(CategoryInitial());
  }

  void clearNameError() {
    nameError = null;
    emit(CategoryInitial());
  }

  void toggleIsActive(bool value) {
    createCategoryParams.isActive = value;
    emit(CategoryInitial());
  }

  Future<Result> createCategory() async {
    return await CreateCategoryUsecase(CategoryRepository())
        .call(params: createCategoryParams);
  }
}
```

---

## Naming Rules

Follow existing naming exactly.

Examples:

- `CategoryModel`
- `CreateCategoryParams`
- `GetCategoryParams`
- `UpdateCategoryParams`
- `DeleteCategoryParams`
- `CreateCategoryUsecase`
- `GetCategoryUsecase`
- `UpdateCategoryUsecase`
- `DeleteCategoryUsecase`
- `CategoryRepository`
- `CategoryCubit`
- `CategoryState`
- `CreateCategoryScreen`
- `CategoryListScreen`
- `CategoryDetailScreen`
- `category_cubit.dart`
- `category_state.dart`
- `category_repository.dart`
- `create_category_usecase.dart`
- `get_category_usecase.dart`
- `category_model.dart`

Do not use different naming styles.

---

## Authentication Rules

For APIs that require login:
- Use `withAuthentication: true`
- Do not manually add Bearer token in screens
- Let RemoteDataSource / ApiProvider handle auth headers if that is the existing project pattern

For login endpoint:
- Use `application/x-www-form-urlencoded`
- Do not send login request as JSON if the backend expects token endpoint format

For `/connect/token`, send:
- `grant_type`
- `client_id`
- `username`
- `password`
- `scope`

---

## Error Handling Rules

Use existing Result / Either / boilerplate error handling.

Do not create unrelated custom error systems.

For validation errors:
- Store field errors in Cubit
- Display errors under fields
- Clear errors when user types

For API errors:
- Use `onError` from CreateModel / GetModel / PaginationList
- Show shadcn `AlertDialog` or existing project message pattern

---

## Dialog Rules

Use shadcn `AlertDialog` for:
- Success messages
- Error messages
- Delete confirmations
- Important confirmations

Use `PrimaryButton` for confirmation.

Use `DestructiveButton` for delete/danger confirmation.

Example:

```dart
showDialog(
  context: context,
  builder: (ctx) => AlertDialog(
    title: const Text('Success'),
    content: const Text('Operation completed successfully.'),
    actions: [
      PrimaryButton(
        child: const Text('OK'),
        onPressed: () => Navigator.pop(ctx),
      ),
    ],
  ),
);
```

---

## Button Rules

Use:
- `PrimaryButton` for main action
- `SecondaryButton` for secondary action
- `OutlineButton` for neutral action
- `DestructiveButton` for delete or danger action
- `GhostButton` for minimal action
- `IconButton` for icon-only action

Do not use random custom buttons unless the existing feature already uses them and the task requires consistency with that file.

---

## Theme Rules

Use:

```dart
final theme = Theme.of(context);
```

Prefer:

```dart
theme.colorScheme.primary
theme.colorScheme.primaryForeground
theme.colorScheme.secondary
theme.colorScheme.muted
theme.colorScheme.border
theme.colorScheme.card
theme.colorScheme.destructive
```

Avoid hardcoded colors unless needed for specific status colors or existing design consistency.

---

## Before Coding

Before making changes:

1. Read the related existing files.
2. Follow the same architecture.
3. Confirm which layer needs to be changed.
4. Change only the requested files.
5. Do not introduce a new architecture.
6. Do not remove existing functionality.
7. Keep the UI consistent with shadcn_flutter.
8. Preserve existing business logic.
9. Preserve existing API behavior.
10. Preserve existing navigation unless asked to change it.

---

## When I Ask for a Full File

If I ask for a full updated file, provide the complete file content.

Do not send patches.

Do not send only snippets unless I ask for snippets.

Do not skip imports.

Do not say "keep the rest unchanged".

Do not provide a ZIP unless explicitly requested.

---

## Main Principle

This is a shadcn_flutter + Cubit + UseCase + Repository architecture.

Always follow this project architecture.

Do not invent another pattern.

Do not bypass the architecture.

Do not call API directly from UI.

Do not use setState for feature state.

Use Cubit, UseCase, Repository, RemoteDataSource, ApiProvider, and the existing boilerplate widgets.


Now improve the UI/UX of this screen only.

Use shadcn_flutter components and keep my existing architecture unchanged.

Make the design premium, modern, clean, professional, user-friendly, and production-ready.

Focus on:
- clear visual hierarchy
- beautiful spacing and padding
- luxury card-based layout
- clean form sections
- readable typography
- friendly empty states
- polished loading and error states
- professional success/error dialogs
- intuitive buttons and actions
- responsive layout
- dark mode compatibility
- consistent shadcn theme usage

Do not change the API logic.
Do not change Cubit business logic.
Do not change Repository or UseCase.
Do not use setState.
Do not hardcode random colors unless necessary.
Use Theme.of(context) and shadcn colorScheme where possible.

Give me the full updated screen file only.