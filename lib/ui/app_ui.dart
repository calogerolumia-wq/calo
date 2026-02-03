import 'package:flutter/material.dart';

class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 28;
  static const double xxl = 36;
}

class AppRadius {
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double xxl = 34;
}

class AppShadow {
  /// Shadow "premium" controllata: in dark meno aggressiva.
  static List<BoxShadow> soft(Color shadowColor, {required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    // In dark: meno opacità e blur più corto -> più pulito
    final o1 = isDark ? 0.10 : 0.12;
    final o2 = isDark ? 0.06 : 0.08;

    return [
      BoxShadow(
        color: shadowColor.withOpacity(o1),
        blurRadius: isDark ? 22 : 28,
        offset: Offset(0, isDark ? 10 : 14),
      ),
      BoxShadow(
        color: shadowColor.withOpacity(o2),
        blurRadius: isDark ? 7 : 8,
        offset: const Offset(0, 4),
      ),
    ];
  }
}

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.gradient,
    this.color,
    this.radius,
    this.outlined = true,
    this.useShadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final BorderRadius? radius;
  final bool outlined;
  final bool useShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final r = radius ?? BorderRadius.circular(AppRadius.xl);

    // Bordo coerente e leggibile in ogni tema
    final borderColor = c.outline.withOpacity(isDark ? 0.55 : 0.75);

    // Fondo card: surface (non background)
    final background = color ?? c.surface;

    // Se c'è gradient, faccio una "base" surface sotto per non impastare i testi
    final baseColor = Color.alphaBlend(
      (isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.02)),
      background,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: r,
        boxShadow: useShadow ? AppShadow.soft(c.shadow, brightness: theme.brightness) : null,
      ),
      child: ClipRRect(
        borderRadius: r,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: gradient == null ? baseColor : baseColor,
            gradient: gradient,
            borderRadius: r,
            border: outlined ? Border.all(color: borderColor, width: 1) : null,
          ),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.filled = true,
    this.expand = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    final baseStyle = ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 14),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      ),
      textStyle: WidgetStateProperty.all(
        theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w900),
      ),
    );

    final style = filled
        ? baseStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(c.primary),
      foregroundColor: WidgetStateProperty.all(c.onPrimary),
      overlayColor: WidgetStateProperty.all(c.onPrimary.withOpacity(0.08)),
      elevation: WidgetStateProperty.all(0),
    )
        : baseStyle.copyWith(
      backgroundColor: WidgetStateProperty.all(Colors.transparent),
      foregroundColor: WidgetStateProperty.all(c.onSurface),
      side: WidgetStateProperty.all(
        BorderSide(color: c.outline.withOpacity(0.9), width: 1),
      ),
      overlayColor: WidgetStateProperty.all(c.primary.withOpacity(0.08)),
    );

    final Widget button = icon == null
        ? (filled
        ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
        : OutlinedButton(onPressed: onPressed, style: style, child: Text(label)))
        : (filled
        ? FilledButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 18),
      label: Text(label),
    )
        : OutlinedButton.icon(
      onPressed: onPressed,
      style: style,
      icon: Icon(icon, size: 18),
      label: Text(label),
    ));

    if (!expand) return button;
    return SizedBox(width: double.infinity, child: button);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                // Secondario ma leggibile: NON onSurfaceVariant fisso
                style: theme.textTheme.bodySmall?.copyWith(
                  color: c.onSurface.withOpacity(0.72),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: trailing!,
          ),
        ],
      ],
    );
  }
}

class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.accent,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final tone = accent ?? c.primary;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tone.withOpacity(isDark ? 0.18 : 0.14),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: tone.withOpacity(isDark ? 0.28 : 0.20)),
            ),
            child: Icon(icon, color: tone, size: 20),
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            // usa lo stile già leggibile (no override onSurfaceVariant)
            style: theme.textTheme.bodySmall?.copyWith(
              color: c.onSurface.withOpacity(0.72),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AppInlineBanner extends StatelessWidget {
  const AppInlineBanner({
    super.key,
    required this.message,
    this.icon = Icons.wifi_off_rounded,
  });

  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          c.error.withOpacity(isDark ? 0.16 : 0.10),
          c.surfaceVariant,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: c.error.withOpacity(isDark ? 0.40 : 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, color: c.error, size: 18),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: c.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AppSkeleton extends StatefulWidget {
  const AppSkeleton({
    super.key,
    this.width,
    this.height = 12,
    this.radius = AppRadius.sm,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Skeleton ben visibile in entrambi i temi
    final base = isDark
        ? c.surfaceVariant.withOpacity(0.75)
        : c.surfaceVariant.withOpacity(0.90);

    final highlight = isDark
        ? c.surfaceVariant.withOpacity(0.45)
        : c.surfaceVariant.withOpacity(0.60);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final color = Color.lerp(base, highlight, _animation.value)!;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
        );
      },
    );
  }
}
