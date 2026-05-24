import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette 2026 ────────────────────────────────────────────────────────────
// Warm paper white base · single vivid accent (terracotta) · deep charcoal text
// ─────────────────────────────────────────────────────────────────────────────

const _kPrimary          = Color(0xFFE8441E); // terracotta — energia, azione
const _kOnPrimary        = Colors.white;
const _kPrimaryContainer = Color(0xFFFFF0EC);
const _kOnPrimaryCtnt    = Color(0xFFB02E0D);

const _kSecondary        = Color(0xFF4A5260); // slate scuro
const _kOnSecondary      = Colors.white;
const _kSecondaryCtnt    = Color(0xFFF0F1F5);
const _kOnSecondaryCtnt  = Color(0xFF4A5260);

const _kTertiary         = Color(0xFF0DA85B); // smeraldo
const _kOnTertiary       = Colors.white;
const _kTertiaryCtnt     = Color(0xFFEAFBF3);
const _kOnTertiaryCtnt   = Color(0xFF0A7A44);

const _kBackground       = Color(0xFFF7F5F1); // warm paper white
const _kOnBackground     = Color(0xFF17191F);

const _kSurface          = Color(0xFFFFFFFF);
const _kOnSurface        = Color(0xFF17191F);

const _kSurfaceVariant   = Color(0xFFF0EDE6);
const _kOnSurfaceVariant = Color(0xFF6C7080);

const _kOutline          = Color(0xFFE4E0D7);
const _kShadow           = Color(0x15000000);
const _kScrim            = Color(0x66000000);

const _kError            = Color(0xFFDC2626);
const _kOnError          = Colors.white;
const _kErrorContainer   = Color(0xFFFEF2F2);
const _kOnErrorCtnt      = Color(0xFFB91C1C);

ThemeData tema() {
  const scheme = ColorScheme(
    brightness: Brightness.light,

    primary: _kPrimary,
    onPrimary: _kOnPrimary,
    primaryContainer: _kPrimaryContainer,
    onPrimaryContainer: _kOnPrimaryCtnt,

    secondary: _kSecondary,
    onSecondary: _kOnSecondary,
    secondaryContainer: _kSecondaryCtnt,
    onSecondaryContainer: _kOnSecondaryCtnt,

    tertiary: _kTertiary,
    onTertiary: _kOnTertiary,
    tertiaryContainer: _kTertiaryCtnt,
    onTertiaryContainer: _kOnTertiaryCtnt,

    background: _kBackground,
    onBackground: _kOnBackground,

    surface: _kSurface,
    onSurface: _kOnSurface,

    surfaceVariant: _kSurfaceVariant,
    onSurfaceVariant: _kOnSurfaceVariant,

    outline: _kOutline,
    shadow: _kShadow,
    scrim: _kScrim,

    error: _kError,
    onError: _kOnError,
    errorContainer: _kErrorContainer,
    onErrorContainer: _kOnErrorCtnt,

    inverseSurface: _kOnSurface,
    onInverseSurface: _kBackground,
    inversePrimary: Color(0xFFFFB4A4),
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
  );

  final outfitBase = GoogleFonts.outfitTextTheme(base.textTheme).apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );

  final textTheme = outfitBase.copyWith(
    headlineLarge: outfitBase.headlineLarge?.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.0,
      height: 1.05,
    ),
    headlineMedium: outfitBase.headlineMedium?.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      height: 1.08,
    ),
    headlineSmall: outfitBase.headlineSmall?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.12,
    ),
    titleLarge: outfitBase.titleLarge?.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleMedium: outfitBase.titleMedium?.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w700,
    ),
    titleSmall: outfitBase.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: outfitBase.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.55,
    ),
    bodyMedium: outfitBase.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.55,
    ),
    bodySmall: outfitBase.bodySmall?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      height: 1.4,
      color: scheme.onSurface.withOpacity(0.58),
    ),
    labelLarge: outfitBase.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
    ),
    labelMedium: outfitBase.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: outfitBase.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
  );

  return base.copyWith(
    textTheme: textTheme,

    appBarTheme: AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleMedium,
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),

    cardTheme: CardTheme(
      elevation: 0,
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: scheme.outline, width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(
        color: scheme.onSurface.withOpacity(0.38),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelStyle: TextStyle(
        color: scheme.onSurface.withOpacity(0.65),
        fontWeight: FontWeight.w600,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 68,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withOpacity(0.12),
      labelTextStyle: WidgetStateProperty.all(
        GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 11),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(color: scheme.onSurface.withOpacity(0.80)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withOpacity(0.12);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.12)),
        elevation: WidgetStateProperty.all(0),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: scheme.outline.withOpacity(1.0), width: 1.5),
        ),
        foregroundColor: WidgetStateProperty.all(scheme.onSurface),
        overlayColor: WidgetStateProperty.all(scheme.primary.withOpacity(0.06)),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        foregroundColor: WidgetStateProperty.all(scheme.primary),
        overlayColor: WidgetStateProperty.all(scheme.primary.withOpacity(0.08)),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 0,
    ),

    iconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.85)),

    dividerTheme: DividerThemeData(
      color: scheme.outline,
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceVariant,
      side: BorderSide(color: scheme.outline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      labelStyle: GoogleFonts.outfit(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: scheme.onSurface,
      ),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: GoogleFonts.outfit(
        color: scheme.onInverseSurface,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
