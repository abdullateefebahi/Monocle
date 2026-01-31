import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// Premium gradient button with loading state
class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final LinearGradient? gradient;
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.gradient,
    this.width,
    this.height = 52,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: isDisabled
            ? LinearGradient(
                colors: [Colors.grey.shade400, Colors.grey.shade500],
              )
            : (gradient ?? AppColors.primaryGradient),
        borderRadius: borderRadius ?? BorderRadius.circular(14),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: (gradient?.colors.first ?? AppColors.primary)
                      .withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: borderRadius ?? BorderRadius.circular(14),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  )
                : DefaultTextStyle(
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    child: child,
                  ),
          ),
        ),
      ),
    );
  }
}

/// Glass morphism card
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final Color? color;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.glassDark : AppColors.glassLight),
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// Currency display widget
class CurrencyDisplay extends StatelessWidget {
  final int amount;
  final CurrencyType type;
  final double iconSize;
  final TextStyle? textStyle;
  final bool showLabel;
  final bool animate;

  const CurrencyDisplay({
    super.key,
    required this.amount,
    required this.type,
    this.iconSize = 20,
    this.textStyle,
    this.showLabel = false,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSpark = type == CurrencyType.spark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize + 8,
          height: iconSize + 8,
          decoration: BoxDecoration(
            gradient: isSpark ? AppColors.sparkGradient : AppColors.orbGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (isSpark ? AppColors.spark : AppColors.orb).withValues(alpha: 
                  0.4,
                ),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              isSpark ? '⚡' : '🔮',
              style: TextStyle(fontSize: iconSize * 0.6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel)
              Text(
                isSpark ? 'Sparks' : 'Orbs',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            animate
                ? TweenAnimationBuilder<int>(
                    tween: IntTween(begin: 0, end: amount),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        _formatAmount(value),
                        style: textStyle ?? theme.textTheme.titleMedium,
                      );
                    },
                  )
                : Text(
                    _formatAmount(amount),
                    style: textStyle ?? theme.textTheme.titleMedium,
                  ),
          ],
        ),
      ],
    );
  }

  String _formatAmount(int value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toString();
  }
}

enum CurrencyType { spark, orb }

/// Animated progress bar
class AnimatedProgressBar extends StatelessWidget {
  final double progress;
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final double height;
  final BorderRadius? borderRadius;
  final Duration duration;

  const AnimatedProgressBar({
    super.key,
    required this.progress,
    this.backgroundColor,
    this.gradient,
    this.height = 8,
    this.borderRadius,
    this.duration = const Duration(milliseconds: 500),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.colorScheme.outline.withValues(alpha: 0.2),
        borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              AnimatedContainer(
                duration: duration,
                curve: Curves.easeOutCubic,
                width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  gradient: gradient ?? AppColors.primaryGradient,
                  borderRadius:
                      borderRadius ?? BorderRadius.circular(height / 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Section header with optional action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(actionLabel!),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
