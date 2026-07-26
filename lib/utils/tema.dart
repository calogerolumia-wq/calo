import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Palette — allineata al web GymPulse ─────────────────────────────────────
// Web: primary #1E40AF · accent #EA580C
// App: stessa palette, aggiunta tertiary emerald e surface con tinta blu
// ─────────────────────────────────────────────────────────────────────────────

const _kPrimary          = Color(0xFF1E40AF); // navy blue  — identico al web
const _kOnPrimary        = Colors.white;
const _kPrimaryCtnt      = Color(0xFFDBEAFE); // blue-100
const _kOnPrimaryCtnt    = Color(0xFF1E3A8A); // blue-900

const _kSecondary        = Color(0xFFEA580C); // orange     — accent web
const _kOnSecondary      = Colors.white;
const _kSecondaryCtnt    = Color(0xFFFFF7ED); // orange-50
const _kOnSecondaryCtnt  = Color(0xFF9A3412); // orange-800

const _kTertiary         = Color(0xFF059669); // emerald    — progresso, PR
const _kOnTertiary       = Colors.white;
const _kTertiaryCtnt     = Color(0xFFD1FAE5); // emerald-100
const _kOnTertiaryCtnt   = Color(0xFF064E3B); // emerald-900

const _kBackground       = Color(0xFFF0F4FF); // blu appena percettibile
const _kOnBackground     = Color(0xFF0F172A); // slate-900

const _kSurface          = Color(0xFFFFFFFF);
const _kOnSurface        = Color(0xFF0F172A);

const _kSurfaceVariant   = Color(0xFFEEF2FF); // indigo-50
const _kOnSurfaceVariant = Color(0xFF64748B); // slate-500

const _kOutline          = Color(0xFFCBD5E1); // slate-300
const _kShadow           = Color(0x12000000);
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
    primaryContainer: _kPrimaryCtnt,
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
    inversePrimary: Color(0xFF93C5FD),
  );

  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
  );

  // Body / UI — Outfit (leggibile, moderno)
  final outfitBase = GoogleFonts.outfitTextTheme(base.textTheme).apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );

  // Headings / Display — Syne (geometrico, identico al web)
  final textTheme = outfitBase.copyWith(
    headlineLarge: GoogleFonts.syne(
      fontSize: 38,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      height: 1.02,
      color: scheme.onSurface,
    ),
    headlineMedium: GoogleFonts.syne(
      fontSize: 28,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.06,
      color: scheme.onSurface,
    ),
    headlineSmall: GoogleFonts.syne(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      height: 1.12,
      color: scheme.onSurface,
    ),
    titleLarge: GoogleFonts.syne(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      height: 1.2,
      color: scheme.onSurface,
    ),
    titleMedium: GoogleFonts.syne(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.1,
      height: 1.25,
      color: scheme.onSurface,
    ),
    titleSmall: GoogleFonts.syne(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0,
      color: scheme.onSurface,
    ),
    bodyLarge: outfitBase.bodyLarge?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.6,
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
      color: scheme.onSurface.withOpacity(0.55),
    ),
    labelLarge: outfitBase.labelLarge?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.1,
    ),
    labelMedium: outfitBase.labelMedium?.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    labelSmall: outfitBase.labelSmall?.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.5,
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
      elevation: 0,
      titleTextStyle: GoogleFonts.syne(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),

    cardTheme: CardTheme(
      elevation: 0,
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: scheme.outline.withOpacity(0.6), width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.outline, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: scheme.error, width: 2),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: GoogleFonts.outfit(
        color: scheme.onSurface.withOpacity(0.38),
        fontWeight: FontWeight.w400,
        fontSize: 14,
      ),
      labelStyle: GoogleFonts.outfit(
        color: scheme.onSurface.withOpacity(0.65),
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      elevation: 0,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withOpacity(0.12),
      indicatorShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return GoogleFonts.outfit(
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          fontSize: 11,
          color: active ? scheme.primary : scheme.onSurface.withOpacity(0.55),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final active = states.contains(WidgetState.selected);
        return IconThemeData(
          color: active ? scheme.primary : scheme.onSurface.withOpacity(0.50),
          size: 22,
        );
      }),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return scheme.onSurface.withOpacity(0.10);
          }
          return scheme.primary;
        }),
        foregroundColor: WidgetStateProperty.all(scheme.onPrimary),
        overlayColor: WidgetStateProperty.all(Colors.white.withOpacity(0.10)),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        ),
        textStyle: WidgetStateProperty.all(
          GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 15),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
            return BorderSide(color: scheme.primary, width: 2);
          }
          return BorderSide(color: scheme.outline, width: 1.5);
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.focused)) return scheme.primary;
          return scheme.onSurface;
        }),
        overlayColor: WidgetStateProperty.all(scheme.primary.withOpacity(0.06)),
        elevation: WidgetStateProperty.all(0),
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
          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      extendedPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    ),

    iconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.80)),

    dividerTheme: DividerThemeData(
      color: scheme.outline.withOpacity(0.5),
      thickness: 1,
      space: 1,
    ),

    chipTheme: ChipThemeData(
      backgroundColor: scheme.surfaceVariant,
      side: BorderSide(color: scheme.outline.withOpacity(0.6)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: GoogleFonts.outfit(
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: scheme.onSurface,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: GoogleFonts.outfit(
        color: scheme.onInverseSurface,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      behavior: SnackBarBehavior.floating,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),

    dialogTheme: DialogTheme(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurface.withOpacity(0.75),
      titleTextStyle: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      subtitleTextStyle: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: scheme.onSurface.withOpacity(0.55),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      horizontalTitleGap: 12,
    ),
  );
}
