import 'package:flutter/material.dart';

class AppSpacing {
  static const double xxs = 4;
  static const double xs  = 8;
  static const double sm  = 12;
  static const double md  = 16;
  static const double lg  = 20;
  static const double xl  = 28;
  static const double xxl = 36;
}

class AppRadius {
  static const double xs  = 8;
  static const double sm  = 12;
  static const double md  = 16;
  static const double lg  = 20;
  static const double xl  = 26;
  static const double xxl = 32;
}

// Ombra pulita, leggermente calda — nessun branching dark/light
const _kShadow1 = BoxShadow(
  color: Color(0x0F000000),
  blurRadius: 24,
  offset: Offset(0, 8),
  spreadRadius: -2,
);
const _kShadow2 = BoxShadow(
  color: Color(0x07000000),
  blurRadius: 6,
  offset: Offset(0, 2),
);

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
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;
  final Color? color;
  final BorderRadius? radius;
  final bool outlined;
  final bool useShadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final r = radius ?? BorderRadius.circular(AppRadius.xl);
    final bg = color ?? c.surface;

    Widget card = Container(
      decoration: BoxDecoration(
        borderRadius: r,
        color: gradient == null ? bg : null,
        gradient: gradient,
        border: outlined ? Border.all(color: c.outline, width: 1) : null,
        boxShadow: useShadow ? const [_kShadow1, _kShadow2] : null,
      ),
      child: ClipRRect(
        borderRadius: r,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: r,
          child: card,
        ),
      );
    }

    return card;
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
    this.small = false,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool filled;
  final bool expand;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    final vPad = small ? 10.0 : 14.0;
    final hPad = small ? 16.0 : 22.0;
    final fontSize = small ? 13.0 : 15.0;
    const radius = 14.0;

    final shape = WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    );
    final padding = WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
    );
    final textStyle = WidgetStateProperty.all(
      theme.textTheme.labelLarge?.copyWith(fontSize: fontSize, fontWeight: FontWeight.w700),
    );

    final ButtonStyle style;
    if (filled) {
      style = ButtonStyle(
        padding: padding,
        shape: shape,
        textStyle: textStyle,
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return c.onSurface.withOpacity(0.12);
          }
          return c.primary;
        }),
        foregroundColor: WidgetStateProperty.all(c.onPrimary),
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.12)),
        elevation: WidgetStateProperty.all(0),
        surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
      );
    } else {
      style = ButtonStyle(
        padding: padding,
        shape: shape,
        textStyle: textStyle,
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        foregroundColor: WidgetStateProperty.all(c.onSurface),
        side: WidgetStateProperty.all(BorderSide(color: c.outline, width: 1.5)),
        overlayColor: WidgetStateProperty.all(c.primary.withOpacity(0.06)),
        elevation: WidgetStateProperty.all(0),
      );
    }

    Widget btn;
    if (icon != null) {
      btn = filled
          ? FilledButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: small ? 16 : 18),
              label: Text(label),
            )
          : OutlinedButton.icon(
              onPressed: onPressed,
              style: style,
              icon: Icon(icon, size: small ? 16 : 18),
              label: Text(label),
            );
    } else {
      btn = filled
          ? FilledButton(onPressed: onPressed, style: style, child: Text(label))
          : OutlinedButton(onPressed: onPressed, style: style, child: Text(label));
    }

    if (!expand) return btn;
    return SizedBox(width: double.infinity, child: btn);
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 3),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: c.onSurface.withOpacity(0.54),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: AppSpacing.sm),
          trailing!,
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
    final tone = accent ?? c.primary;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      radius: BorderRadius.circular(AppRadius.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: tone.withOpacity(0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
              border: Border.all(color: tone.withOpacity(0.18)),
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
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: c.onSurface.withOpacity(0.54),
              fontWeight: FontWeight.w500,
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
    this.tone,
  });

  final String message;
  final IconData icon;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    final color = tone ?? c.error;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: c.onSurface.withOpacity(0.80),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureDisabilitata extends StatelessWidget {
  const FeatureDisabilitata({super.key, required this.titolo});
  final String titolo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(titolo)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline_rounded,
                  size: 56, color: c.onSurface.withOpacity(0.25)),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Funzionalità non disponibile',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Questa sezione è stata disabilitata dall\'amministratore.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: c.onSurface.withOpacity(0.54)),
              ),
            ],
          ),
        ),
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

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Color.lerp(
            c.surfaceVariant,
            c.outline.withOpacity(0.5),
            _anim.value,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
