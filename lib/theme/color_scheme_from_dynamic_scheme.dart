import 'package:flutter/material.dart';
import 'package:material_color_utilities/dynamiccolor/dynamic_scheme.dart';
import 'package:material_color_utilities/dynamiccolor/material_dynamic_colors.dart';

/// Maps a Material Color Utilities [DynamicScheme] to Flutter [ColorScheme],
/// using the same role resolution as [ColorScheme.fromSeed].
ColorScheme colorSchemeFromDynamicScheme(DynamicScheme scheme) {
  final brightness = scheme.isDark ? Brightness.dark : Brightness.light;
  return ColorScheme(
    primary: Color(MaterialDynamicColors.primary.getArgb(scheme)),
    onPrimary: Color(MaterialDynamicColors.onPrimary.getArgb(scheme)),
    primaryContainer:
        Color(MaterialDynamicColors.primaryContainer.getArgb(scheme)),
    onPrimaryContainer:
        Color(MaterialDynamicColors.onPrimaryContainer.getArgb(scheme)),
    primaryFixed: Color(MaterialDynamicColors.primaryFixed.getArgb(scheme)),
    primaryFixedDim:
        Color(MaterialDynamicColors.primaryFixedDim.getArgb(scheme)),
    onPrimaryFixed: Color(MaterialDynamicColors.onPrimaryFixed.getArgb(scheme)),
    onPrimaryFixedVariant:
        Color(MaterialDynamicColors.onPrimaryFixedVariant.getArgb(scheme)),
    secondary: Color(MaterialDynamicColors.secondary.getArgb(scheme)),
    onSecondary: Color(MaterialDynamicColors.onSecondary.getArgb(scheme)),
    secondaryContainer:
        Color(MaterialDynamicColors.secondaryContainer.getArgb(scheme)),
    onSecondaryContainer:
        Color(MaterialDynamicColors.onSecondaryContainer.getArgb(scheme)),
    secondaryFixed: Color(MaterialDynamicColors.secondaryFixed.getArgb(scheme)),
    secondaryFixedDim:
        Color(MaterialDynamicColors.secondaryFixedDim.getArgb(scheme)),
    onSecondaryFixed:
        Color(MaterialDynamicColors.onSecondaryFixed.getArgb(scheme)),
    onSecondaryFixedVariant:
        Color(MaterialDynamicColors.onSecondaryFixedVariant.getArgb(scheme)),
    tertiary: Color(MaterialDynamicColors.tertiary.getArgb(scheme)),
    onTertiary: Color(MaterialDynamicColors.onTertiary.getArgb(scheme)),
    tertiaryContainer:
        Color(MaterialDynamicColors.tertiaryContainer.getArgb(scheme)),
    onTertiaryContainer:
        Color(MaterialDynamicColors.onTertiaryContainer.getArgb(scheme)),
    tertiaryFixed: Color(MaterialDynamicColors.tertiaryFixed.getArgb(scheme)),
    tertiaryFixedDim:
        Color(MaterialDynamicColors.tertiaryFixedDim.getArgb(scheme)),
    onTertiaryFixed:
        Color(MaterialDynamicColors.onTertiaryFixed.getArgb(scheme)),
    onTertiaryFixedVariant:
        Color(MaterialDynamicColors.onTertiaryFixedVariant.getArgb(scheme)),
    error: Color(MaterialDynamicColors.error.getArgb(scheme)),
    onError: Color(MaterialDynamicColors.onError.getArgb(scheme)),
    errorContainer: Color(MaterialDynamicColors.errorContainer.getArgb(scheme)),
    onErrorContainer:
        Color(MaterialDynamicColors.onErrorContainer.getArgb(scheme)),
    outline: Color(MaterialDynamicColors.outline.getArgb(scheme)),
    outlineVariant: Color(MaterialDynamicColors.outlineVariant.getArgb(scheme)),
    surface: Color(MaterialDynamicColors.surface.getArgb(scheme)),
    surfaceDim: Color(MaterialDynamicColors.surfaceDim.getArgb(scheme)),
    surfaceBright: Color(MaterialDynamicColors.surfaceBright.getArgb(scheme)),
    surfaceContainerLowest:
        Color(MaterialDynamicColors.surfaceContainerLowest.getArgb(scheme)),
    surfaceContainerLow:
        Color(MaterialDynamicColors.surfaceContainerLow.getArgb(scheme)),
    surfaceContainer:
        Color(MaterialDynamicColors.surfaceContainer.getArgb(scheme)),
    surfaceContainerHigh:
        Color(MaterialDynamicColors.surfaceContainerHigh.getArgb(scheme)),
    surfaceContainerHighest:
        Color(MaterialDynamicColors.surfaceContainerHighest.getArgb(scheme)),
    onSurface: Color(MaterialDynamicColors.onSurface.getArgb(scheme)),
    onSurfaceVariant:
        Color(MaterialDynamicColors.onSurfaceVariant.getArgb(scheme)),
    inverseSurface: Color(MaterialDynamicColors.inverseSurface.getArgb(scheme)),
    onInverseSurface:
        Color(MaterialDynamicColors.inverseOnSurface.getArgb(scheme)),
    inversePrimary: Color(MaterialDynamicColors.inversePrimary.getArgb(scheme)),
    shadow: Color(MaterialDynamicColors.shadow.getArgb(scheme)),
    scrim: Color(MaterialDynamicColors.scrim.getArgb(scheme)),
    surfaceTint: Color(MaterialDynamicColors.primary.getArgb(scheme)),
    brightness: brightness,
  );
}
