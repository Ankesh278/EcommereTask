import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, secondary, outlined, text, danger }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final IconData? suffixIcon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool? isFullWidth;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.suffixIcon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isFullWidth,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
  });

  factory AppButton.compact({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    AppButtonVariant variant = AppButtonVariant.primary,
    Color? backgroundColor,
    Color? textColor,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: variant,
      size: AppButtonSize.small,
      isFullWidth: false,
      backgroundColor: backgroundColor,
      textColor: textColor,
    );
  }

  factory AppButton.outlined({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.large,
    bool? isFullWidth,
    Color? textColor,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: AppButtonVariant.outlined,
      size: size,
      isFullWidth: isFullWidth,
      textColor: textColor,
    );
  }

  factory AppButton.danger({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
    IconData? icon,
    AppButtonSize size = AppButtonSize.large,
    bool? isFullWidth,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: AppButtonVariant.danger,
      size: size,
      isFullWidth: isFullWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = onPressed != null && !isLoading;
    final double height = _resolveHeight();
    final double radius = borderRadius ?? _resolveRadius();
    final bool fullWidth = isFullWidth ?? (size == AppButtonSize.large);

    Widget buttonContent = _buildContent(context, isEnabled);

    Widget button;
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.danger:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _resolveBackgroundColor(),
            foregroundColor: _resolveForegroundColor(isEnabled),
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.35),
            disabledForegroundColor: Colors.white70,
            elevation: 0,
            minimumSize: fullWidth ? Size.fromHeight(height) : Size(0, height),
            padding: _resolvePadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.secondary:
        button = ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.surfaceVariant,
            foregroundColor: textColor ?? AppColors.textPrimary,
            elevation: 0,
            minimumSize: fullWidth ? Size.fromHeight(height) : Size(0, height),
            padding: _resolvePadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isEnabled ? onPressed : null,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? AppColors.primary,
            side: BorderSide(
              color: isEnabled
                  ? (backgroundColor ?? AppColors.border)
                  : AppColors.border.withValues(alpha: 0.5),
              width: 1.2,
            ),
            minimumSize: fullWidth ? Size.fromHeight(height) : Size(0, height),
            padding: _resolvePadding(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: buttonContent,
        );
        break;

      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isEnabled ? onPressed : null,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? AppColors.accentDark,
            padding: _resolvePadding(),
            minimumSize: fullWidth ? Size.fromHeight(height) : Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
          child: buttonContent,
        );
        break;
    }

    return button;
  }

  Widget _buildContent(BuildContext context, bool isEnabled) {
    if (isLoading) {
      final spinnerSize = size == AppButtonSize.small ? 16.0 : 20.0;
      final spinnerColor = _resolveSpinnerColor();

      return SizedBox(
        height: spinnerSize,
        width: spinnerSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.2,
          valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
        ),
      );
    }

    final double iconSize = size == AppButtonSize.small ? 14.0 : 18.0;
    final TextStyle textStyle = _resolveTextStyle(isEnabled);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: iconSize),
          SizedBox(width: size == AppButtonSize.small ? 4 : 8),
        ],
        Text(text, style: textStyle),
        if (suffixIcon != null) ...[
          SizedBox(width: size == AppButtonSize.small ? 4 : 8),
          Icon(suffixIcon, size: iconSize),
        ],
      ],
    );
  }

  double _resolveHeight() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.buttonHeightSmall;
      case AppButtonSize.medium:
        return AppDimensions.buttonHeightMedium;
      case AppButtonSize.large:
        return AppDimensions.buttonHeightLarge;
    }
  }

  double _resolveRadius() {
    switch (size) {
      case AppButtonSize.small:
        return AppDimensions.radiusSmall;
      case AppButtonSize.medium:
      case AppButtonSize.large:
        return AppDimensions.radiusMedium;
    }
  }

  EdgeInsetsGeometry _resolvePadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 10, vertical: 6);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 14);
    }
  }

  Color _resolveBackgroundColor() {
    if (backgroundColor != null) return backgroundColor!;
    if (variant == AppButtonVariant.danger) return AppColors.error;
    return AppColors.primary;
  }

  Color _resolveForegroundColor(bool isEnabled) {
    if (textColor != null) return textColor!;
    if (!isEnabled) return Colors.white70;
    return Colors.white;
  }

  Color _resolveSpinnerColor() {
    if (variant == AppButtonVariant.outlined ||
        variant == AppButtonVariant.text) {
      return textColor ?? AppColors.primary;
    }
    return Colors.white;
  }

  TextStyle _resolveTextStyle(bool isEnabled) {
    switch (size) {
      case AppButtonSize.small:
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _resolveForegroundColor(isEnabled),
        );
      case AppButtonSize.medium:
        return TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: _resolveForegroundColor(isEnabled),
        );
      case AppButtonSize.large:
        return AppTextStyles.buttonText.copyWith(
          color: _resolveForegroundColor(isEnabled),
        );
    }
  }
}
