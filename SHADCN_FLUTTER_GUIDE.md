# Shadcn Flutter Integration Guide

## Overview

This project now uses **shadcn_flutter** - a Flutter implementation of shadcn/ui components. This guide shows you how to use the components in your app.

## Setup Complete ✅

The following has been set up for you:

1. ✅ Package added to `pubspec.yaml` (version ^0.0.52)
2. ✅ `ShadcnApp` configured in `main.dart` with light/dark themes
3. ✅ `AuthCubit` added to BlocProvider
4. ✅ Example screens created demonstrating shadcn_flutter components

## Available Example Screens

### 1. Login Screen with shadcn_flutter
**File**: `lib/features/auth/screen/login_screen_shadcn.dart`

Features:
- `TextField` components with icons
- `PrimaryButton` for actions
- `Card` for form container
- `Toast` notifications for success/error
- Clean, consistent styling

### 2. Register Screen with shadcn_flutter
**File**: `lib/features/auth/screen/register_screen_shadcn.dart`

Features:
- Multiple `TextField` inputs
- `Alert` component for password requirements
- Form validation
- `Toast` notifications
- Responsive layout

## Main shadcn_flutter Components

### 1. Buttons
```dart
// Primary Button
PrimaryButton(
  onPressed: () {},
  child: const Text('Click Me'),
)

// Secondary Button
SecondaryButton(
  onPressed: () {},
  child: const Text('Secondary'),
)

// Outline Button
OutlineButton(
  onPressed: () {},
  child: const Text('Outline'),
)

// Ghost Button
GhostButton(
  onPressed: () {},
  child: const Text('Ghost'),
)
```

### 2. Text Fields
```dart
TextField(
  controller: controller,
  placeholder: 'Enter text',
  decoration: InputDecoration(
    label: const Text('Label'),
    prefix: const Icon(Icons.person),
    suffix: IconButton(icon: Icon(Icons.clear)),
  ),
  obscureText: false,
  onChanged: (value) {},
)
```

### 3. Cards
```dart
Card(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card Title'),
        Text('Card content'),
      ],
    ),
  ),
)
```

### 4. Alerts
```dart
Alert(
  leading: const Icon(Icons.info),
  title: const Text('Alert Title'),
  child: const Text('Alert message'),
)

// Destructive Alert
Alert.destructive(
  leading: const Icon(Icons.error),
  title: const Text('Error'),
  child: const Text('Something went wrong'),
)
```

### 5. Toasts
```dart
showToast(
  context: context,
  builder: (context) {
    return const Toast(
      leading: Icon(Icons.check_circle),
      title: Text('Success'),
      description: Text('Operation completed'),
    );
  },
)

// Destructive Toast
showToast(
  context: context,
  builder: (context) {
    return Toast.destructive(
      leading: const Icon(Icons.error),
      title: const Text('Error'),
      description: Text('Operation failed'),
    );
  },
)
```

### 6. Dialogs
```dart
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: const Text('Confirm'),
      content: const Text('Are you sure?'),
      actions: [
        PrimaryButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Confirm'),
        ),
        SecondaryButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  },
);
```

### 7. Badges
```dart
Badge(
  child: const Text('New'),
)

Badge.destructive(
  child: const Text('Error'),
)

Badge.secondary(
  child: const Text('Info'),
)
```

### 8. Switches
```dart
Switch(
  value: isEnabled,
  onChanged: (value) {
    setState(() {
      isEnabled = value;
    });
  },
)
```

### 9. Checkboxes
```dart
Checkbox(
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value;
    });
  },
)
```

### 10. Radio Buttons
```dart
Radio(
  value: selectedValue,
  groupValue: currentValue,
  onChanged: (value) {
    setState(() {
      currentValue = value;
    });
  },
)
```

## Theme Customization

The theme is configured in `main.dart`:

```dart
ShadcnApp(
  themeMode: ThemeMode.light,
  theme: ThemeData(
    colorScheme: ColorSchemes.lightZinc(),
    radius: 0.5,
  ),
  darkTheme: ThemeData(
    colorScheme: ColorSchemes.darkZinc(),
    radius: 0.5,
  ),
)
```

### Available Color Schemes
- `ColorSchemes.lightZinc()` / `ColorSchemes.darkZinc()`
- `ColorSchemes.lightSlate()` / `ColorSchemes.darkSlate()`
- `ColorSchemes.lightStone()` / `ColorSchemes.darkStone()`
- `ColorSchemes.lightGray()` / `ColorSchemes.darkGray()`
- `ColorSchemes.lightNeutral()` / `ColorSchemes.darkNeutral()`

### Access Theme in Widgets
```dart
final theme = Theme.of(context);

Text(
  'Title',
  style: theme.typography.h1,
)

Text(
  'Subtitle',
  style: theme.typography.muted,
)
```

### Typography Styles
- `theme.typography.h1` - Heading 1
- `theme.typography.h2` - Heading 2
- `theme.typography.h3` - Heading 3
- `theme.typography.h4` - Heading 4
- `theme.typography.base` - Body text
- `theme.typography.muted` - Muted text
- `theme.typography.small` - Small text

## Switching Between Old and New Screens

### Current Setup
The app currently uses the original screens (`login_screen.dart`, `register_screen.dart`).

### To Use shadcn_flutter Screens
Update `main.dart`:

```dart
// Change this:
home: const LoginScreen(),

// To this:
home: const LoginScreenShadcn(),
```

## Best Practices

1. **Use shadcn_flutter components consistently** across your app for a cohesive design
2. **Access theme colors** via `theme.colorScheme` instead of hardcoding colors
3. **Use typography styles** from `theme.typography` for consistent text styling
4. **Leverage Toast notifications** for user feedback instead of SnackBars
5. **Use Cards** to group related content
6. **Use Alerts** for important information or warnings

## Integration with Your Clean Architecture

shadcn_flutter works seamlessly with your existing architecture:

```dart
// In your screen
CreateModel<LoginModel>(
  withValidation: true,
  onTap: () async {
    return _formKey.currentState?.validate() ?? false;
  },
  useCaseCallBack: (data) {
    return context.read<AuthCubit>().login();
  },
  onSuccess: (loginModel) {
    // Use shadcn Toast instead of SnackBar
    showToast(
      context: context,
      builder: (context) {
        return const Toast(
          leading: Icon(Icons.check_circle),
          title: Text('Success'),
          description: Text('Login successful!'),
        );
      },
    );
  },
  onError: (error) {
    // Use destructive Toast for errors
    showToast(
      context: context,
      builder: (context) {
        return Toast.destructive(
          leading: const Icon(Icons.error),
          title: const Text('Error'),
          description: Text(error),
        );
      },
    );
  },
  child: PrimaryButton(
    child: const Text('Sign In'),
  ),
)
```

## Resources

- **Package**: https://pub.dev/packages/shadcn_flutter
- **Original shadcn/ui**: https://ui.shadcn.com/
- **Flutter Documentation**: https://docs.flutter.dev/

## Next Steps

1. Explore the example screens to understand component usage
2. Replace existing UI components with shadcn_flutter equivalents
3. Customize the theme to match your brand colors
4. Use the components consistently throughout your app

---

**Created**: 2026-07-02
**Package Version**: ^0.0.52
