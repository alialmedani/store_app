import 'dart:math' as math;
import 'package:flutter/widgets.dart' as fw;
import '../../design_system/app_design_tokens.dart';

/// Fade + slide-up entrance. Items in a list pass their [index] so they
/// appear one after another (stagger is capped so long lists stay snappy).
class FadeSlideIn extends fw.StatefulWidget {
  final fw.Widget child;
  final int index;
  final Duration? delay;
  final double offsetY;

  const FadeSlideIn({
    super.key,
    required this.child,
    this.index = 0,
    this.delay,
    this.offsetY = 16,
  });

  @override
  fw.State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends fw.State<FadeSlideIn>
    with fw.SingleTickerProviderStateMixin {
  late final fw.AnimationController _controller;
  late final fw.Animation<double> _curve;

  @override
  void initState() {
    super.initState();
    _controller = fw.AnimationController(
      vsync: this,
      duration: AppDesignTokens.motionEntrance,
    );
    _curve = fw.CurvedAnimation(
      parent: _controller,
      curve: AppDesignTokens.easeOut,
    );
    final delay =
        widget.delay ??
        AppDesignTokens.motionStagger * math.min(widget.index, 8);
    if (delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.AnimatedBuilder(
      animation: _curve,
      child: widget.child,
      builder: (context, child) {
        final t = _curve.value;
        return fw.Opacity(
          opacity: t.clamp(0.0, 1.0),
          child: fw.Transform.translate(
            offset: fw.Offset(0, (1 - t) * widget.offsetY),
            child: child,
          ),
        );
      },
    );
  }
}

/// Wraps a tappable area with a subtle press-down scale.
class PressScale extends fw.StatefulWidget {
  final fw.Widget child;
  final fw.VoidCallback? onTap;
  final double pressedScale;

  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
  });

  @override
  fw.State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends fw.State<PressScale> {
  bool _down = false;

  void _set(bool value) {
    if (widget.onTap == null) return;
    if (_down != value) setState(() => _down = value);
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.GestureDetector(
      behavior: fw.HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: fw.AnimatedScale(
        scale: _down ? widget.pressedScale : 1.0,
        duration: AppDesignTokens.motionFast,
        curve: AppDesignTokens.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Number that counts up to [value] when first shown (and when it changes).
class CountUpText extends fw.StatelessWidget {
  final num value;
  final fw.TextStyle? style;
  final String suffix;
  final Duration duration;

  const CountUpText({
    super.key,
    required this.value,
    this.style,
    this.suffix = '',
    this.duration = const Duration(milliseconds: 1100),
  });

  static String format(num v) {
    final s = v.round().abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return (v < 0 ? '-' : '') + buffer.toString();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    return fw.TweenAnimationBuilder<double>(
      tween: fw.Tween<double>(begin: 0, end: value.toDouble()),
      duration: duration,
      curve: fw.Curves.easeOutQuart,
      builder: (context, v, _) =>
          fw.Text('${format(v)}$suffix', style: style),
    );
  }
}

/// Small pulsing status dot (live / needs attention).
class PulseDot extends fw.StatefulWidget {
  final fw.Color color;
  final double size;

  const PulseDot({super.key, required this.color, this.size = 7});

  @override
  fw.State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends fw.State<PulseDot>
    with fw.SingleTickerProviderStateMixin {
  late final fw.AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = fw.AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  fw.Widget build(fw.BuildContext context) {
    final box = widget.size * 3;
    return fw.SizedBox(
      width: box,
      height: box,
      child: fw.AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = _controller.value;
          return fw.Stack(
            alignment: fw.Alignment.center,
            children: [
              fw.Container(
                width: widget.size * (1 + 2 * t),
                height: widget.size * (1 + 2 * t),
                decoration: fw.BoxDecoration(
                  shape: fw.BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.5 * (1 - t)),
                ),
              ),
              fw.Container(
                width: widget.size,
                height: widget.size,
                decoration: fw.BoxDecoration(
                  shape: fw.BoxShape.circle,
                  color: widget.color,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
