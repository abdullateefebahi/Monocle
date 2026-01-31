import 'package:flutter/material.dart';

/// Monocle Design System Colors
/// Updated with "Cyberpunk/Futuristic" palette
class AppColors {
  AppColors._();

  // ============ CORE DEFINITIONS ============
  /// The background. A "near-black" navy that reduces eye strain.
  static const Color primaryBase = Color(0xFF0D0D15);

  /// Card backgrounds, sidebars, and chat bubbles.
  static const Color surface = Color(0xFF1A1B26);

  /// The "Monocle" eye. Used for active states, new messages.
  static const Color cyanAccent = Color(0xFF00F2FF);

  /// Represents "Orbs" (Premium Currency) and high-level ranks.
  static const Color royalPurple = Color(0xFF7000FF);

  /// Success states, Shard (Soft Currency) icons, and completed missions.
  static const Color emeraldGreen = Color(0xFF00FF9D);

  // ============ SEMANTIC MAPPING ============

  // Primary Brand Colors
  static const Color primary = cyanAccent;
  static const Color secondary = royalPurple;

  // Currency Colors (Mapped to new palette)
  static const Color spark = emeraldGreen; // Shards (Soft Currency)
  static const Color orb = royalPurple; // Orbs (Hard Currency)
  static const Color sparkDark = Color(0xFF00CC7A);
  static const Color orbDark = Color(0xFF5500CC);

  // Status Colors
  static const Color success = emeraldGreen;
  static const Color error = Color(
    0xFFFF2E54,
  ); // Bright Red for visibility against dark
  static const Color warning = Color(0xFFFFB800);
  static const Color info = cyanAccent;

  // ============ THEME COLORS ============

  // Dark Theme (Primary)
  static const Color backgroundDark = primaryBase;
  static const Color surfaceDark = surface;
  static const Color cardDark = surface;
  static const Color dividerDark = Color(
    0xFF2A2B36,
  ); // Slightly lighter than surface

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate 400
  static const Color textTertiaryDark = Color(0xFF64748B); // Slate 500

  // Light Theme (Fallback/Inverted)
  // Maintaining basic visibility for light mode if needed, though dark is preferred
  static const Color backgroundLight = Color(0xFFF1F5F9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE2E8F0);
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // ============ GRADIENTS ============

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [cyanAccent, Color(0xFF00C2CC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [royalPurple, Color(0xFF9D44FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orbGradient = LinearGradient(
    colors: [Color(0xFF9D44FF), royalPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sparkGradient = LinearGradient(
    colors: [emeraldGreen, Color(0xFF00CC7A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFF667EEA), Color(0xFF764BA2), Color(0xFFF093FB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// A dark gradient for backgrounds to add depth
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [primaryBase, Color(0xFF13131F)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============ GLASSMORPHISM ============
  static Color glassLight = Colors.white.withValues(alpha: 0.15);
  static Color glassDark = surface.withValues(alpha: 0.7);
  static Color glassBorder = Colors.white.withValues(alpha: 0.08);

  // ============ QUEST RARITIES ============
  static const Color rarityCommon = Color(0xFF94A3B8);
  static const Color rarityUncommon = emeraldGreen;
  static const Color rarityRare = cyanAccent;
  static const Color rarityEpic = royalPurple;
  static const Color rarityLegendary = Color(0xFFFFB800); // Gold
}
