# Copilot Instructions - Store Flutter Architecture

## Main Rule

This project has its own architecture. Do not invent a new structure.

Always follow the existing project architecture, naming, folders, and code style.

Before coding, read existing similar features first.

Reference guides:
- API_INTEGRATION_GUID.md
- SHADCN_UI_INTEGRATION_GUIDE.md

---

## Architecture

Use this flow:

```text
Screen
→ CreateModel / GetModel / PaginationList
→ Cubit
→ UseCase
→ Repository
→ RemoteDataSource
→ ApiProvider / Dio
→ API
```

Do not call Dio directly from screens.

Do not put business logic inside screens.

Do not bypass the architecture.

---

## Feature Structure

For every feature, follow this structure:

```text
lib/features/{feature}/
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

Do not move files to another architecture.

Do not create new architectural patterns unless explicitly requested.

---

## API URL Rules

All API endpoints must be defined in:

```text
lib/core/constant/end_points/api_url.dart
```

Do not hardcode URLs inside:
- screen
- cubit
- usecase
- repository

Always reuse the existing `baseUrl`.

For every new feature, add a clear section in `api_url.dart`.

Example:

```dart
// ========== Product URLs ==========
const createProductUrl = '$baseUrl/api/app/product';
const getProductListUrl = '$baseUrl/api/app/product';

String getProductDetailsUrl(String id) => '$baseUrl/api/app/product/$id';

String updateProductUrl(String id) => '$baseUrl/api/app/product/$id';

String deleteProductUrl(String id) => '$baseUrl/api/app/product/$id';
```

Use constants for static URLs.

Use functions for URLs that need id or dynamic values.

Repositories must import endpoint constants/functions from `api_url.dart`.

---

## API Integration Rules

When adding a new API, implement in this order:

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

For single response:
- Use `call(result: result)`

For list or paginated response:
- Use `paginatedCall(result: result)`

Do not call `ApiProvider` or `Dio` directly from screens.

Do not put API URLs directly inside screens.

Do not put business logic inside screens.

---

## State Management Rules

Use Cubit.

Do not use `setState` for feature state.

Do not use `setState` for:
- form fields
- validation errors
- checkbox
- switch
- dropdown
- selected item
- password visibility
- loading
- success
- error

Use Cubit variables and methods.

Use `BlocBuilder` when UI needs to rebuild.

Use `context.read<Cubit>()` for one-time actions like:
- button clicks
- `TextField` `onChanged`
- dropdown selection
- checkbox/switch change
- triggering API calls

---

## Emit Rules

Do not manually emit Loading / Success / Error inside API methods.

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

`CreateModel`, `GetModel`, and `PaginationList` handle API loading/success/error.

Manual `emit()` is allowed only for UI state:
- validation errors
- clearing validation errors
- dropdown selection
- checkbox/switch change
- password visibility
- selected item

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

## Boilerplate Widgets

Use existing boilerplate widgets:

- `CreateModel` for create/update/delete
- `GetModel` for single item details
- `PaginationList` for list pages

Do not replace these wrappers with custom loading/error logic unless explicitly requested.

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

Use `shadcn_flutter` for new UI screens.

Use:
- `TextField`
- `PrimaryButton`
- `SecondaryButton`
- `OutlineButton`
- `DestructiveButton`
- `GhostButton`
- `Card`
- `AlertDialog`
- `Badge`
- `IconButton`
- `Switch`
- `Checkbox`

Use `Theme.of(context)` and shadcn `colorScheme`.

Avoid random hardcoded colors.

Use:
- `PrimaryButton` for main actions
- `SecondaryButton` or `OutlineButton` for secondary actions
- `DestructiveButton` for delete/danger actions
- `GhostButton` for minimal actions
- `Card` for grouped content
- `Badge` for status labels
- `AlertDialog` for success/error/confirmation

Important:
- When using shadcn `IconButton`, always provide the required `variance` argument.
- Example: `variance: ButtonVariance.ghost`
- Do not assume Material `IconButton` API.

Example:

```dart
IconButton(
  icon: const Icon(Icons.arrow_back),
  variance: ButtonVariance.ghost,
  onPressed: () => Navigator.pop(context),
)
```

---

## Avoid Material UI Mixing

Do not mix Material UI widgets with `shadcn_flutter` unless explicitly requested.

Avoid these Material UI widgets:
- `InkWell`
- `TextButton`
- `ElevatedButton`
- `OutlinedButton`
- `FloatingActionButton`
- `DropdownButtonFormField`
- Material custom buttons
- Material form widgets when a shadcn alternative or project pattern exists

Use shadcn components instead.

For clickable cards:
- Use `GestureDetector` around shadcn `Card`
- Do not use `InkWell`

Example:

```dart
GestureDetector(
  onTap: onTap,
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  ),
)
```

For dialog actions:
- Use `PrimaryButton`
- Use `SecondaryButton`
- Use `DestructiveButton` for delete/danger actions
- Do not use `TextButton`

Example:

```dart
AlertDialog(
  title: const Text('Success'),
  content: const Text('Operation completed successfully.'),
  actions: [
    PrimaryButton(
      child: const Text('OK'),
      onPressed: () => Navigator.pop(context),
    ),
  ],
)
```

For navigation:
- Preserve existing navigation style unless asked to change it.
- If the project already uses named routes, use named routes.
- If the existing feature uses `Navigator.push`, keep consistent with that feature.
- Do not change navigation architecture randomly.

---

## shadcn Select Rule

Do not use `shadcn_flutter` `Select` unless the exact API is verified from the installed package version.

If `Select` causes compile errors such as missing `popup`, do not keep guessing the API.

For dropdown-like choices, prefer a shadcn button/card selector:

- Use `Wrap`
- Use `PrimaryButton` for the selected item
- Use `OutlineButton` for unselected items
- Store selected value in Cubit
- Use `BlocBuilder` to rebuild UI

Example:

```dart
BlocBuilder<CategoryCubit, CategoryState>(
  builder: (context, state) {
    final cubit = context.read<CategoryCubit>();

    final options = {
      1: 'None',
      2: 'Clothing',
      3: 'Shoes',
      4: 'One Size',
      5: 'Kids Age',
      6: 'Custom',
    };

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.entries.map((entry) {
        final isSelected = cubit.selectedSizeType == entry.key;

        if (isSelected) {
          return PrimaryButton(
            onPressed: () => cubit.selectSizeType(entry.key),
            child: Text(entry.value),
          );
        }

        return OutlineButton(
          onPressed: () => cubit.selectSizeType(entry.key),
          child: Text(entry.value),
        );
      }).toList(),
    );
  },
)
```

Do not use Material `DropdownButtonFormField` unless explicitly requested.

---

## UI Quality Rules

The UI must be modern, clean, premium, professional, and user-friendly.

Do not generate basic or ugly screens.

Focus on:
- clean layout
- good spacing
- clear visual hierarchy
- premium card-based design
- readable typography
- beautiful forms
- helpful empty states
- polished success/error dialogs
- responsive layout
- dark mode compatibility
- consistent shadcn theme usage

Do not break architecture for design.

Do not overuse colors.

Do not make screens crowded.

---

## Form Rules

Store form params inside Cubit.

`TextField onChanged` must update Cubit params.

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

Validation errors must be stored in Cubit.

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

Display validation errors using `BlocBuilder`.

Dispose all controllers in `dispose()`.

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

## Params Rules

Params classes should be inside usecase files.

Params used by Cubit must be mutable.

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

## Model Rules

Models should contain:
- nullable fields when API fields are optional
- `fromJson`
- `toJson`

Match JSON keys exactly as returned by the API.

Handle dates safely.

Use `String` for Guid values.

Use `DateTime?` for date fields when needed.

---

## Repository Rules

Repositories should:
- extend `CoreRepository`
- call `RemoteDataSource.request`
- use endpoint constants from `api_url.dart`
- use correct HTTP method
- use `data` for POST/PUT/PATCH
- use `queryParameters` for GET
- use `withAuthentication` correctly
- use `converter`
- return `call(result: result)` for single response
- return `paginatedCall(result: result)` for list response

Do not write endpoint strings directly inside repository methods.

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
- params objects
- UI state variables
- validation error variables
- selection/toggle variables
- UI state methods with emit
- API methods without emit

API methods must return `Future<Result>` or `Future<Result<T>>`.

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

## Pagination Rules

Use `PaginationList` for paginated list screens.

The Cubit list method should receive pagination data and pass it to the UseCase.

Example:

```dart
Future<Result> fetchProductList(data) async {
  return await GetProductListUsecase(ProductRepository())
      .call(params: GetProductParams(request: data));
}
```

Repository list methods should return `paginatedCall(result: result)`.

---

## Authentication Rules

For APIs that need token:
- use `withAuthentication: true`

Do not manually add Bearer token in screens.

For login:
- `/connect/token` uses `application/x-www-form-urlencoded`
- do not send login as JSON

For normal authenticated APIs:
- use JSON if backend expects JSON
- let `RemoteDataSource` / `ApiProvider` handle auth headers according to the existing project pattern

---

## Error Handling Rules

Use existing `Result` / `Either` / boilerplate error handling.

Do not create unrelated custom error systems.

For validation errors:
- Store field errors in Cubit
- Display errors under fields
- Clear errors when user types

For API errors:
- Use `onError` from `CreateModel` / `GetModel` / `PaginationList`
- Show shadcn `AlertDialog` or the existing project message pattern

---

## Dialog Rules

Use shadcn `AlertDialog` for:
- success messages
- error messages
- delete confirmations
- important confirmations

Use `PrimaryButton` for confirmation.

Use `SecondaryButton` for cancel/close.

Use `DestructiveButton` for delete/danger confirmation.

Do not use Material `TextButton` in dialogs unless explicitly requested.

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
- shadcn `IconButton` for icon-only action

When using shadcn `IconButton`, always include `variance`.

Example:

```dart
IconButton(
  icon: const Icon(Icons.notifications_outlined),
  variance: ButtonVariance.ghost,
  onPressed: () {},
)
```

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

## Naming Rules

Follow existing naming style exactly.

Examples:
- `ProductModel`
- `CreateProductParams`
- `GetProductParams`
- `ProductRepository`
- `ProductCubit`
- `ProductState`
- `ProductScreen`
- `product_model.dart`
- `create_product_usecase.dart`
- `product_repository.dart`
- `product_cubit.dart`
- `product_state.dart`

Do not use different naming styles.

---

## Before Coding

Before modifying code:

1. Read related existing files.
2. Follow the same architecture.
3. Update only needed files.
4. Do not change unrelated files.
5. Preserve existing logic.
6. Preserve navigation unless asked.
7. Preserve API behavior.
8. Keep UI consistent with shadcn_flutter.
9. Do not mix Material UI with shadcn UI.
10. Verify shadcn component API before using advanced components like `Select`.

---

## When Asked for Full File

If the user asks for a full updated file:
- provide the complete file content
- do not send patches
- do not skip imports
- do not say "keep the rest unchanged"
- do not modify unrelated files

---

## Main Principle

This is a shadcn_flutter + Cubit + UseCase + Repository architecture.

Always follow this architecture.

Do not bypass it.

Do not call API directly from UI.

Do not use `setState` for feature state.

Use `api_url.dart` for endpoints.

Do not mix Material UI widgets with shadcn_flutter unless explicitly requested.