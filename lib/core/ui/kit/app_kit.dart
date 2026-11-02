// App UI kit: Flutter Material + our own thin widgets that follow
// AppDesignTokens (Aurora, light + dark).
//
// Screens import ONLY this file for UI primitives (never material.dart
// directly). Names that Material also defines are hidden here and replaced by
// the token-aware versions in this file.
import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart' as fw;

import '../shadcn/design_system/app_design_tokens.dart';

export 'package:flutter/material.dart'
    hide Scaffold, IconButton, TextField, Card, AlertDialog;

// ---------------------------------------------------------------------------
// Theme colors: short names used across screens (theme.colorScheme.muted ...)
// They read AppDesignTokens, so they always match the active theme.
// ---------------------------------------------------------------------------
extension AppColorSchemeX on m.ColorScheme {
  fw.Color get foreground => AppDesignTokens.titleTextColor;
  fw.Color get mutedForeground => AppDesignTokens.mutedTextColor;
  fw.Color get muted => AppDesignTokens.mutedSurfaceColor;
  fw.Color get border => AppDesignTokens.borderColor;
  fw.Color get card => AppDesignTokens.cardColor;
  fw.Color get destructive => AppDesignTokens.dangerColor;
  fw.Color get primaryForeground => AppDesignTokens.onAccentColor;
  fw.Color get secondaryForeground => AppDesignTokens.titleTextColor;
}

// ---------------------------------------------------------------------------
// Icons that used to come from Radix icons.
// ---------------------------------------------------------------------------
class RadixIcons {
  RadixIcons._();
  static const fw.IconData crossCircled = m.Icons.cancel_outlined;
  static const fw.IconData backpack = m.Icons.backpack_outlined;
  static const fw.IconData eyeOpen = m.Icons.visibility_outlined;
  static const fw.IconData eyeClosed = m.Icons.visibility_off_outlined;
  static const fw.IconData arrowRight = m.Icons.arrow_forward;
}

// ---------------------------------------------------------------------------
// Scaffold: accepts `child` (or `body`)
// ---------------------------------------------------------------------------
class Scaffold extends fw.StatelessWidget {
  final fw.Widget? child;
  final fw.Widget? body;
  final fw.Color? backgroundColor;
  final fw.PreferredSizeWidget? appBar;

  const Scaffold({
    super.key,
    this.child,
    this.body,
    this.backgroundColor,
    this.appBar,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return m.Scaffold(
      backgroundColor: backgroundColor ?? AppDesignTokens.backgroundColor,
      appBar: appBar,
      body: body ?? child,
    );
  }
}

// ---------------------------------------------------------------------------
// Card: token-based surface with hairline border
// ---------------------------------------------------------------------------
class Card extends fw.StatelessWidget {
  final fw.Widget child;
  final fw.EdgeInsetsGeometry padding;
  final fw.Color? color;

  const Card({
    super.key,
    required this.child,
    this.padding = fw.EdgeInsets.zero,
    this.color,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.Container(
      padding: padding,
      clipBehavior: fw.Clip.antiAlias,
      decoration: color == null
          ? AppDesignTokens.glassDecoration()
          : fw.BoxDecoration(
              color: color,
              borderRadius: fw.BorderRadius.circular(AppDesignTokens.cardRadius),
              border: fw.Border.all(color: AppDesignTokens.glassBorder),
              boxShadow: AppDesignTokens.cardShadow(AppDesignTokens.titleTextColor),
            ),
      child: child,
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons
// ---------------------------------------------------------------------------
enum ButtonVariance { primary, secondary, outline, ghost, destructive }

enum ButtonDensity { normal, compact, dense }

fw.RoundedRectangleBorder _btnShape([fw.BorderSide side = fw.BorderSide.none]) =>
    fw.RoundedRectangleBorder(
      borderRadius: fw.BorderRadius.circular(AppDesignTokens.buttonRadius),
      side: side,
    );

class PrimaryButton extends fw.StatelessWidget {
  final fw.VoidCallback? onPressed;
  final fw.Widget child;
  const PrimaryButton({super.key, this.onPressed, required this.child});

  @override
  fw.Widget build(fw.BuildContext context) {
    final enabled = onPressed != null;
    final radius = fw.BorderRadius.circular(AppDesignTokens.buttonRadius);
    return fw.DecoratedBox(
      decoration: fw.BoxDecoration(
        gradient: enabled ? AppDesignTokens.primaryGradient : null,
        color: enabled ? null : AppDesignTokens.mutedSurfaceColor,
        borderRadius: radius,
        boxShadow: enabled ? AppDesignTokens.glowShadow : null,
      ),
      child: m.FilledButton(
        onPressed: onPressed,
        style: m.FilledButton.styleFrom(
          backgroundColor: const fw.Color(0x00000000),
          shadowColor: const fw.Color(0x00000000),
          foregroundColor: const fw.Color(0xFFFFFFFF),
          disabledBackgroundColor: const fw.Color(0x00000000),
          disabledForegroundColor: AppDesignTokens.mutedTextColor,
          minimumSize: const fw.Size(0, AppDesignTokens.primaryButtonHeight),
          shape: _btnShape(),
        ),
        child: child,
      ),
    );
  }
}

class SecondaryButton extends fw.StatelessWidget {
  final fw.VoidCallback? onPressed;
  final fw.Widget child;
  const SecondaryButton({super.key, this.onPressed, required this.child});

  @override
  fw.Widget build(fw.BuildContext context) => m.FilledButton(
    onPressed: onPressed,
    style: m.FilledButton.styleFrom(
      backgroundColor: AppDesignTokens.primarySoftColor,
      foregroundColor: AppDesignTokens.primaryColor,
      disabledBackgroundColor: AppDesignTokens.mutedSurfaceColor,
      disabledForegroundColor: AppDesignTokens.mutedTextColor,
      minimumSize: const fw.Size(0, AppDesignTokens.primaryButtonHeight),
      shape: _btnShape(),
    ),
    child: child,
  );
}

class DestructiveButton extends fw.StatelessWidget {
  final fw.VoidCallback? onPressed;
  final fw.Widget child;
  const DestructiveButton({super.key, this.onPressed, required this.child});

  @override
  fw.Widget build(fw.BuildContext context) => m.FilledButton(
    onPressed: onPressed,
    style: m.FilledButton.styleFrom(
      backgroundColor: AppDesignTokens.dangerSoftColor,
      foregroundColor: AppDesignTokens.dangerColor,
      disabledBackgroundColor: AppDesignTokens.mutedSurfaceColor,
      disabledForegroundColor: AppDesignTokens.mutedTextColor,
      minimumSize: const fw.Size(0, AppDesignTokens.primaryButtonHeight),
      shape: _btnShape(),
    ),
    child: child,
  );
}

class OutlineButton extends fw.StatelessWidget {
  final fw.VoidCallback? onPressed;
  final fw.Widget child;
  const OutlineButton({super.key, this.onPressed, required this.child});

  @override
  fw.Widget build(fw.BuildContext context) => m.OutlinedButton(
    onPressed: onPressed,
    style: m.OutlinedButton.styleFrom(
      foregroundColor: AppDesignTokens.titleTextColor,
      disabledForegroundColor: AppDesignTokens.mutedTextColor,
      minimumSize: const fw.Size(0, AppDesignTokens.primaryButtonHeight),
      backgroundColor: AppDesignTokens.cardColor,
      side: fw.BorderSide(color: AppDesignTokens.hairlineStrong),
      shape: _btnShape(),
    ),
    child: child,
  );
}

class IconButton extends fw.StatelessWidget {
  final fw.Widget icon;
  final fw.VoidCallback? onPressed;
  final fw.Color? color;
  final ButtonVariance variance;
  final ButtonDensity density;

  const IconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.variance = ButtonVariance.ghost,
    this.density = ButtonDensity.normal,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    fw.Color? bg;
    fw.Color fg = color ?? AppDesignTokens.titleTextColor;
    switch (variance) {
      case ButtonVariance.primary:
        bg = AppDesignTokens.primaryColor;
        fg = color ?? AppDesignTokens.onAccentColor;
        break;
      case ButtonVariance.destructive:
        bg = AppDesignTokens.dangerColor;
        fg = color ?? AppDesignTokens.onAccentColor;
        break;
      case ButtonVariance.secondary:
      case ButtonVariance.outline:
        bg = AppDesignTokens.mutedSurfaceColor;
        break;
      case ButtonVariance.ghost:
        bg = null;
        break;
    }
    final button = m.IconButton(
      onPressed: onPressed,
      icon: icon,
      visualDensity: density == ButtonDensity.normal
          ? m.VisualDensity.standard
          : m.VisualDensity.compact,
      style: m.IconButton.styleFrom(
        backgroundColor: bg ?? AppDesignTokens.cardColor,
        foregroundColor: fg,
        shape: fw.RoundedRectangleBorder(
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
          side: bg == null
              ? fw.BorderSide(color: AppDesignTokens.glassBorder)
              : fw.BorderSide.none,
        ),
      ),
    );
    if (bg != null) return button;
    return fw.DecoratedBox(
      decoration: fw.BoxDecoration(
        borderRadius: fw.BorderRadius.circular(AppDesignTokens.iconBoxRadius),
        boxShadow: AppDesignTokens.cardShadow(AppDesignTokens.titleTextColor),
      ),
      child: button,
    );
  }
}

// ---------------------------------------------------------------------------
// TextField: `placeholder` is a widget (kept from the old API)
// ---------------------------------------------------------------------------
class TextField extends fw.StatelessWidget {
  final fw.TextEditingController? controller;
  final fw.Widget? placeholder;
  final bool obscureText;
  final fw.TextInputType? keyboardType;
  final fw.ValueChanged<String>? onChanged;
  final fw.ValueChanged<String>? onSubmitted;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final fw.TextStyle? style;

  const TextField({
    super.key,
    this.controller,
    this.placeholder,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.style,
  });

  @override
  fw.Widget build(fw.BuildContext context) {
    m.OutlineInputBorder border(fw.Color c, [double w = 1]) =>
        m.OutlineInputBorder(
          borderRadius: fw.BorderRadius.circular(AppDesignTokens.inputRadius),
          borderSide: fw.BorderSide(color: c, width: w),
        );
    return m.TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      readOnly: readOnly,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      cursorColor: AppDesignTokens.primaryColor,
      style:
          style ??
          fw.TextStyle(
            fontSize: AppDesignTokens.bodyFontSize,
            color: AppDesignTokens.titleTextColor,
          ),
      decoration: m.InputDecoration(
        hint: placeholder == null
            ? null
            : fw.DefaultTextStyle(
                style: fw.TextStyle(
                  fontSize: AppDesignTokens.bodyFontSize,
                  color: AppDesignTokens.placeholderTextColor,
                ),
                child: placeholder!,
              ),
        isDense: true,
        filled: true,
        fillColor: AppDesignTokens.cardColor,
        contentPadding: const fw.EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: border(AppDesignTokens.glassBorder),
        enabledBorder: border(AppDesignTokens.isDark
            ? AppDesignTokens.hairlineStrong
            : AppDesignTokens.hairlineStrong),
        disabledBorder: border(AppDesignTokens.mutedBorderColor),
        focusedBorder: border(AppDesignTokens.primaryColor, 1.6),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// AlertDialog: token-based surface
// ---------------------------------------------------------------------------
class AlertDialog extends fw.StatelessWidget {
  final fw.Widget? title;
  final fw.Widget? content;
  final List<fw.Widget>? actions;

  const AlertDialog({super.key, this.title, this.content, this.actions});

  @override
  fw.Widget build(fw.BuildContext context) {
    return m.AlertDialog(
      backgroundColor: AppDesignTokens.cardColor,
      surfaceTintColor: const fw.Color(0x00000000),
      shape: fw.RoundedRectangleBorder(
        borderRadius: fw.BorderRadius.circular(28),
        side: fw.BorderSide(color: AppDesignTokens.glassBorder),
      ),
      titleTextStyle: fw.TextStyle(
        fontSize: AppDesignTokens.sectionTitleFontSize,
        fontWeight: AppDesignTokens.bold,
        color: AppDesignTokens.titleTextColor,
      ),
      contentTextStyle: fw.TextStyle(
        fontSize: AppDesignTokens.bodyFontSize,
        color: AppDesignTokens.mutedTextColor,
      ),
      title: title,
      content: content,
      actions: actions,
    );
  }
}


/// Screen layout where the top header is NOT pinned: it scrolls away together
/// with the content of [body] (any scrollable: list, form, pagination list).
class ScrollAwayHeader extends fw.StatelessWidget {
  final fw.Widget header;
  final fw.Widget body;

  const ScrollAwayHeader({super.key, required this.header, required this.body});

  @override
  fw.Widget build(fw.BuildContext context) {
    return m.NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        fw.SliverToBoxAdapter(child: header),
      ],
      body: body,
    );
  }
}
