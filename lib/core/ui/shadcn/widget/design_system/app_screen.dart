import 'package:flutter/widgets.dart' as fw;
import 'package:shadcn_flutter/shadcn_flutter.dart';
import '../../design_system/app_design_tokens.dart';

/// Consistent screen wrapper with SafeArea, background, and padding
/// Handles scroll behavior and provides consistent spacing
class AppScreen extends fw.StatelessWidget {
  final fw.Widget child;
  final bool withScroll;
  final bool withHorizontalPadding;
  final fw.Color? backgroundColor;
  final fw.EdgeInsetsGeometry? customPadding;

  const AppScreen({
    super.key,
    required this.child,
    this.withScroll = true,
    this.withHorizontalPadding = true,
    this.backgroundColor,
    this.customPadding,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);
    final padding = customPadding ??
        fw.EdgeInsets.symmetric(
          horizontal: withHorizontalPadding
              ? AppDesignTokens.screenPaddingHorizontal
              : 0,
        );

    final content = fw.Padding(
      padding: padding,
      child: child,
    );

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      child: SafeArea(
        child: withScroll
            ? fw.SingleChildScrollView(
                child: content,
              )
            : content,
      ),
    );
  }
}

/// Screen wrapper with CustomScrollView support for slivers
class AppSliverScreen extends fw.StatelessWidget {
  final List<fw.Widget> slivers;
  final fw.Color? backgroundColor;

  const AppSliverScreen({
    super.key,
    required this.slivers,
    this.backgroundColor,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.colorScheme.background,
      child: SafeArea(
        child: fw.CustomScrollView(
          slivers: slivers,
        ),
      ),
    );
  }
}
