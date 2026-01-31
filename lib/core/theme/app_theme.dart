import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Monocle App Theme Configuration
class AppTheme {
  AppTheme._();

  // ============ DARK THEME (Main) ============
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,

      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
      ),

      textTheme: _textTheme(AppColors.textPrimaryDark),
      appBarTheme: _appBarTheme(isLight: false),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surface, // Dark theme default
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme(isLight: false),
      navigationRailTheme: _navRailTheme, // Added for Desktop Sidebar
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerDark,
        thickness: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondaryDark),
    );
  }

  // ============ LIGHT THEME (Fallback) ============
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
      ),
      textTheme: _textTheme(AppColors.textPrimaryLight),
      appBarTheme: _appBarTheme(isLight: true),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.cardLight,
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      outlinedButtonTheme: _outlinedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme(isLight: true),
      dividerTheme: const DividerThemeData(
        color: AppColors.dividerLight,
        thickness: 1,
      ),
    );
  }

  // ============ TEXT THEME ============
  static TextTheme _textTheme(Color textColor) {
    return GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      titleSmall: GoogleFonts.outfit(
        color: textColor,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.outfit(color: textColor),
      bodyMedium: GoogleFonts.outfit(color: textColor),
      bodySmall: GoogleFonts.outfit(color: textColor.withValues(alpha: 0.7)),
    );
  }

  // ============ COMPONENT THEMES ============

  static AppBarTheme _appBarTheme({required bool isLight}) {
    return AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      foregroundColor: isLight
          ? AppColors.textPrimaryLight
          : AppColors.textPrimaryDark,
      systemOverlayStyle: isLight
          ? SystemUiOverlayStyle.dark
          : SystemUiOverlayStyle.light,
    );
  }

  static ElevatedButtonThemeData get _elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.black,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
    );
  }

  static OutlinedButtonThemeData get _outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme({required bool isLight}) {
    return InputDecorationTheme(
      filled: true,
      fillColor: isLight ? Colors.grey[100] : AppColors.surfaceDark,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: isLight ? Colors.transparent : Colors.white.withValues(alpha: 0.05),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      hintStyle: TextStyle(color: isLight ? Colors.grey : Colors.grey[600]),
    );
  }

  static NavigationRailThemeData get _navRailTheme {
    return NavigationRailThemeData(
      backgroundColor: AppColors.backgroundDark,
      selectedIconTheme: const IconThemeData(color: AppColors.primary),
      unselectedIconTheme: const IconThemeData(
        color: AppColors.textSecondaryDark,
      ),
      selectedLabelTextStyle: GoogleFonts.outfit(
        color: AppColors.primary,
        fontWeight: FontWeight.w600,
        fontSize: 13,
      ),
      unselectedLabelTextStyle: GoogleFonts.outfit(
        color: AppColors.textSecondaryDark,
        fontWeight: FontWeight.w500,
        fontSize: 13,
      ),
      useIndicator: false, // We'll implement custom indicators if needed
    );
  }
}
