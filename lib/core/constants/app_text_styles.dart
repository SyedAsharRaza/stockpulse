import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // font families ke lie
  static const String fontFamilyHeading = 'Poppins';
  static const String fontFamilyBody = 'Inter';
  static const String fontFamilyMono = 'JetBrains Mono';

  // for headings
  static TextStyle h1(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyHeading,
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: color ?? _getTextPrimary(context),
      letterSpacing: -0.5,
    );
  }

  static TextStyle h2(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyHeading,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: color ?? _getTextPrimary(context),
      letterSpacing: -0.3,
    );
  }

  static TextStyle h3(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyHeading,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? _getTextPrimary(context),
    );
  }

  static TextStyle h4(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyHeading,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: color ?? _getTextPrimary(context),
    );
  }

  // for body text
  static TextStyle bodyLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: color ?? _getTextPrimary(context),
      height: 1.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: color ?? _getTextSecondary(context),
      height: 1.5,
    );
  }

  static TextStyle bodySmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color ?? _getTextTertiary(context),
      height: 1.4,
    );
  }

  // buttons and labels kelie
  static TextStyle labelLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? _getTextPrimary(context),
      letterSpacing: 0.3,
    );
  }

  static TextStyle labelMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: color ?? _getTextSecondary(context),
      letterSpacing: 0.2,
    );
  }

  static TextStyle buttonText({Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyBody,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.3,
    );
  }


  static TextStyle metricLarge(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyMono,
      fontSize: 28,
      fontWeight: FontWeight.w700,
      color: color ?? _getTextPrimary(context),
      letterSpacing: -0.5,
    );
  }

  static TextStyle metricMedium(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyMono,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: color ?? _getTextPrimary(context),
    );
  }

  static TextStyle metricSmall(BuildContext context, {Color? color}) {
    return TextStyle(
      fontFamily: fontFamilyMono,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: color ?? _getTextSecondary(context),
    );
  }

  static Color _getTextPrimary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
  }

  static Color _getTextSecondary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
  }

  static Color _getTextTertiary(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
  }
}