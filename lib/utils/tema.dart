import 'package:flutter/material.dart';

ThemeData temaChiaro() {
  const scheme = ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF0099C8),
    onPrimary: Colors.white,
    secondary: Color(0xFFA32791),
    onSecondary: Colors.white,
    tertiary: Color(0xFF16B977),
    onTertiary: Colors.white,

    background: Color(0xFFF6F8FC),
    onBackground: Color(0xFF0B1220),

    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF0B1220),

    surfaceVariant: Color(0xFFEAF0FA),
    onSurfaceVariant: Color(0xFF445066),

    outline: Color(0xFFD3DBEA),
    shadow: Color(0x22000000),
    scrim: Color(0x66000000),

    primaryContainer: Color(0xFFD6F6FF),
    onPrimaryContainer: Color(0xFF00323D),
    secondaryContainer: Color(0xFFFFD6F6),
    onSecondaryContainer: Color(0xFF3A0030),
    tertiaryContainer: Color(0xFFD8FFF0),
    onTertiaryContainer: Color(0xFF003321),

    error: Color(0xFFB42318),
    onError: Colors.white,
    errorContainer: Color(0xFFFFDAD6),
    onErrorContainer: Color(0xFF410002),

    inverseSurface: Color(0xFF0B1220),
    onInverseSurface: Color(0xFFF6F8FC),
    inversePrimary: Color(0xFF66D9FF),
  );

  return _buildTheme(scheme);
}

ThemeData temaScuro() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF00D4FF),
    onPrimary: Color(0xFF001216),
    secondary: Color(0xFFA32791),
    onSecondary: Color(0xFF1A0014),
    tertiary: Color(0xFF38E6A8),
    onTertiary: Color(0xFF00140B),

    background: Color(0xFF0B1220),
    onBackground: Color(0xFFF6F8FF),

    surface: Color(0xFF101A2E),
    onSurface: Color(0xFFF6F8FF),

    surfaceVariant: Color(0xFF172642),
    onSurfaceVariant: Color(0xFFC9D4F2),

    outline: Color(0xFF2E4162),
    shadow: Color(0xFF000000),
    scrim: Color(0xFF000000),

    primaryContainer: Color(0xFF003B49),
    onPrimaryContainer: Color(0xFFBDF2FF),
    secondaryContainer: Color(0xFF3B0030),
    onSecondaryContainer: Color(0xFFFFC1F2),
    tertiaryContainer: Color(0xFF003322),
    onTertiaryContainer: Color(0xFFB5FFE6),

    error: Color(0xFFFF5B5B),
    onError: Color(0xFF1A0000),
    errorContainer: Color(0xFF3A0000),
    onErrorContainer: Color(0xFFFFDAD6),

    inverseSurface: Color(0xFFF6F8FF),
    onInverseSurface: Color(0xFF0B1220),
    inversePrimary: Color(0xFF006B84),
  );

  return _buildTheme(scheme);
}

ThemeData _buildTheme(ColorScheme scheme) {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: scheme,

    // background come “tela” dell’app; surface per card
    scaffoldBackgroundColor: scheme.background,
  );

  final applied = base.textTheme.apply(
    bodyColor: scheme.onSurface,
    displayColor: scheme.onSurface,
  );

  final textTheme = applied.copyWith(
    headlineLarge: applied.headlineLarge?.copyWith(
      fontSize: 34,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.9,
      height: 1.05,
    ),
    headlineMedium: applied.headlineMedium?.copyWith(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      letterSpacing: -0.6,
      height: 1.08,
    ),
    titleLarge: applied.titleLarge?.copyWith(
      fontSize: 20,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.2,
    ),
    titleMedium: applied.titleMedium?.copyWith(
      fontSize: 17,
      fontWeight: FontWeight.w800,
    ),
    titleSmall: applied.titleSmall?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: applied.bodyLarge?.copyWith(fontSize: 16, height: 1.45),
    bodyMedium: applied.bodyMedium?.copyWith(fontSize: 14, height: 1.45),

    // IMPORTANT: niente onSurfaceVariant fisso: in dark è poco leggibile
    bodySmall: applied.bodySmall?.copyWith(
      fontSize: 12,
      height: 1.4,
      color: scheme.onSurface.withOpacity(0.78),
    ),
    labelLarge: applied.labelLarge?.copyWith(fontSize: 13, fontWeight: FontWeight.w800),
    labelMedium: applied.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
  );

  const radiusCard = 22.0;
  const radiusInput = 16.0;

  return base.copyWith(
    textTheme: textTheme,

    appBarTheme: AppBarTheme(
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: textTheme.titleMedium?.copyWith(color: scheme.onSurface),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),

    cardTheme: CardTheme(
      elevation: 0,
      color: scheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusCard),
        side: BorderSide(color: scheme.outline.withOpacity(0.55), width: 1),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: scheme.outline.withOpacity(0.9), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide(color: scheme.primary, width: 1.8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusInput),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: scheme.onSurface.withOpacity(0.65), fontWeight: FontWeight.w600),
      labelStyle: TextStyle(color: scheme.onSurface.withOpacity(0.8), fontWeight: FontWeight.w700),
    ),

    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      backgroundColor: scheme.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primary.withOpacity(0.16),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurface.withOpacity(0.9)),
      ),
      iconTheme: WidgetStateProperty.all(
        IconThemeData(color: scheme.onSurface.withOpacity(0.9)),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        textStyle: WidgetStateProperty.all(
          const TextStyle(fontWeight: FontWeight.w800),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    ),

    iconTheme: IconThemeData(color: scheme.onSurface.withOpacity(0.92)),
  );
}
