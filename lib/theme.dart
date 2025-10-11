import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffb50f4d),
      surfaceTint: Color(0xffb81450),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd73165),
      onPrimaryContainer: Color(0xfffffbff),
      secondary: Color(0xff006482),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff007ea3),
      onSecondaryContainer: Color(0xfffbfdff),
      tertiary: Color(0xff3c5b96),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5674b1),
      onTertiaryContainer: Color(0xfffefcff),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xfffdf8f7),
      onSurface: Color(0xff1c1b1b),
      onSurfaceVariant: Color(0xff444843),
      outline: Color(0xff747873),
      outlineVariant: Color(0xffc4c8c2),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323030),
      inversePrimary: Color(0xffffb2bf),
      primaryFixed: Color(0xffffd9de),
      onPrimaryFixed: Color(0xff3f0015),
      primaryFixedDim: Color(0xffffb2bf),
      onPrimaryFixedVariant: Color(0xff90003a),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff001f2a),
      secondaryFixedDim: Color(0xff6cd2ff),
      onSecondaryFixedVariant: Color(0xff004d65),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff001a42),
      tertiaryFixedDim: Color(0xffadc6ff),
      onTertiaryFixedVariant: Color(0xff25457f),
      surfaceDim: Color(0xffded9d8),
      surfaceBright: Color(0xfffdf8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2f1),
      surfaceContainer: Color(0xfff2edec),
      surfaceContainerHigh: Color(0xffece7e6),
      surfaceContainerHighest: Color(0xffe6e1e0),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff71002c),
      surfaceTint: Color(0xffb81450),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcd285e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003b4e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff007699),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff0e346e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff4e6ca9),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f7),
      onSurface: Color(0xff121111),
      onSurfaceVariant: Color(0xff333733),
      outline: Color(0xff4f544f),
      outlineVariant: Color(0xff6a6e69),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323030),
      inversePrimary: Color(0xffffb2bf),
      primaryFixed: Color(0xffcd285e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xffaa0046),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff007699),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff005c78),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff4e6ca9),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff34548f),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac5c4),
      surfaceBright: Color(0xfffdf8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff8f2f1),
      surfaceContainer: Color(0xffece7e6),
      surfaceContainerHigh: Color(0xffe0dcdb),
      surfaceContainerHighest: Color(0xffd5d1cf),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff5e0024),
      surfaceTint: Color(0xffb81450),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff94003c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003041),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff005068),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002a61),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff274882),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf8f7),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff292d29),
      outlineVariant: Color(0xff464a46),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff323030),
      inversePrimary: Color(0xffffb2bf),
      primaryFixed: Color(0xff94003c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff6a0029),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff005068),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00374a),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff274882),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff08316a),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb8b7),
      surfaceBright: Color(0xfffdf8f7),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5f0ee),
      surfaceContainer: Color(0xffe6e1e0),
      surfaceContainerHigh: Color(0xffd8d3d2),
      surfaceContainerHighest: Color(0xffcac5c4),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffb2bf),
      surfaceTint: Color(0xffffb2bf),
      onPrimary: Color(0xff660027),
      primaryContainer: Color(0xfffd4f80),
      onPrimaryContainer: Color(0xff54001f),
      secondary: Color(0xff6cd2ff),
      onSecondary: Color(0xff003547),
      secondaryContainer: Color(0xff019cc9),
      onSecondaryContainer: Color(0xff002d3d),
      tertiary: Color(0xffadc6ff),
      onTertiary: Color(0xff042e68),
      tertiaryContainer: Color(0xff7290cf),
      onTertiaryContainer: Color(0xff00275c),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff141313),
      onSurface: Color(0xffe6e1e0),
      onSurfaceVariant: Color(0xffc4c8c2),
      outline: Color(0xff8e928c),
      outlineVariant: Color(0xff444843),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e0),
      inversePrimary: Color(0xffb81450),
      primaryFixed: Color(0xffffd9de),
      onPrimaryFixed: Color(0xff3f0015),
      primaryFixedDim: Color(0xffffb2bf),
      onPrimaryFixedVariant: Color(0xff90003a),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff001f2a),
      secondaryFixedDim: Color(0xff6cd2ff),
      onSecondaryFixedVariant: Color(0xff004d65),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff001a42),
      tertiaryFixedDim: Color(0xffadc6ff),
      onTertiaryFixedVariant: Color(0xff25457f),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff3a3938),
      surfaceContainerLowest: Color(0xff0f0e0e),
      surfaceContainerLow: Color(0xff1c1b1b),
      surfaceContainer: Color(0xff211f1f),
      surfaceContainerHigh: Color(0xff2b2a29),
      surfaceContainerHighest: Color(0xff363434),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffd1d7),
      surfaceTint: Color(0xffffb2bf),
      onPrimary: Color(0xff52001e),
      primaryContainer: Color(0xfffd4f80),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffafe4ff),
      onSecondary: Color(0xff002938),
      secondaryContainer: Color(0xff019cc9),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffcfdcff),
      onTertiary: Color(0xff002455),
      tertiaryContainer: Color(0xff7290cf),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffdaddd7),
      outline: Color(0xffafb3ad),
      outlineVariant: Color(0xff8d918c),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e0),
      inversePrimary: Color(0xff92003b),
      primaryFixed: Color(0xffffd9de),
      onPrimaryFixed: Color(0xff2c000d),
      primaryFixedDim: Color(0xffffb2bf),
      onPrimaryFixedVariant: Color(0xff71002c),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff00131c),
      secondaryFixedDim: Color(0xff6cd2ff),
      onSecondaryFixedVariant: Color(0xff003b4e),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff00102e),
      tertiaryFixedDim: Color(0xffadc6ff),
      onTertiaryFixedVariant: Color(0xff0e346e),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff464443),
      surfaceContainerLowest: Color(0xff080707),
      surfaceContainerLow: Color(0xff1f1d1d),
      surfaceContainer: Color(0xff292727),
      surfaceContainerHigh: Color(0xff343232),
      surfaceContainerHighest: Color(0xff3f3d3d),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffffebed),
      surfaceTint: Color(0xffffb2bf),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffffacbb),
      onPrimaryContainer: Color(0xff210008),
      secondary: Color(0xffdff3ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff5dcffe),
      onSecondaryContainer: Color(0xff000d14),
      tertiary: Color(0xffecefff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa7c2ff),
      onTertiaryContainer: Color(0xff000a22),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141313),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffeef1eb),
      outlineVariant: Color(0xffc0c4be),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e0),
      inversePrimary: Color(0xff92003b),
      primaryFixed: Color(0xffffd9de),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffffb2bf),
      onPrimaryFixedVariant: Color(0xff2c000d),
      secondaryFixed: Color(0xffbfe9ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff6cd2ff),
      onSecondaryFixedVariant: Color(0xff00131c),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffadc6ff),
      onTertiaryFixedVariant: Color(0xff00102e),
      surfaceDim: Color(0xff141313),
      surfaceBright: Color(0xff52504f),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff211f1f),
      surfaceContainer: Color(0xff323030),
      surfaceContainerHigh: Color(0xff3d3b3a),
      surfaceContainerHighest: Color(0xff484646),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
