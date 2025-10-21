import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff65558f),
      surfaceTint: Color(0xff6750a4),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffeaddff),
      onPrimaryContainer: Color(0xff4f378b),
      secondary: Color(0xff625b71),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe8def8),
      onSecondaryContainer: Color(0xff4a4458),
      tertiary: Color(0xff7d5260),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffffd8e4),
      onTertiaryContainer: Color(0xff633b48),
      error: Color(0xffb3261e),
      onError: Color(0xffffffff),
      errorContainer: Color(0xfff9dedc),
      onErrorContainer: Color(0xff8c1d18),
      surface: Color(0xfffef7ff),
      onSurface: Color(0xff1d1b20),
      onSurfaceVariant: Color(0xff49454f),
      outline: Color(0xff79747e),
      outlineVariant: Color(0xffcac4d0),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffd0bcff),
      primaryFixed: Color(0xffeaddff),
      onPrimaryFixed: Color(0xff21005d),
      primaryFixedDim: Color(0xffd0bcff),
      onPrimaryFixedVariant: Color(0xff4f378b),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1d192b),
      secondaryFixedDim: Color(0xffccc2dc),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd8e4),
      onTertiaryFixed: Color(0xff31111d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b48),
      surfaceDim: Color(0xffded8e1),
      surfaceBright: Color(0xfffef7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f2fa),
      surfaceContainer: Color(0xfff3edf7),
      surfaceContainerHigh: Color(0xffece6f0),
      surfaceContainerHighest: Color(0xffe6e0e9),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff3c2d63),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff74649f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff3c2d63),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff74649f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff5b2238),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9c5870),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff5e2320),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffa15853),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff121016),
      onSurfaceVariant: Color(0xff37353e),
      outline: Color(0xff54515a),
      outlineVariant: Color(0xff6f6b75),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff74649f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff5b4c84),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff74649f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff5b4c84),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9c5870),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff804057),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffcac5cd),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff7f2fa),
      surfaceContainer: Color(0xffece6ee),
      surfaceContainerHigh: Color(0xffe0dbe3),
      surfaceContainerHighest: Color(0xffd5d0d8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff312259),
      surfaceTint: Color(0xff65558f),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4f4078),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff312259),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff4f4078),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff4f182e),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff72354c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff511917),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff763632),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfffdf7ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff2d2b33),
      outlineVariant: Color(0xff4a4851),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff322f35),
      inversePrimary: Color(0xffcfbdfe),
      primaryFixed: Color(0xff4f4078),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff382960),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff4f4078),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff382960),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff72354c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff571f35),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffbcb7bf),
      surfaceBright: Color(0xfffdf7ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff5eff7),
      surfaceContainer: Color(0xffe6e1e9),
      surfaceContainerHigh: Color(0xffd8d3da),
      surfaceContainerHighest: Color(0xffcac5cd),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffd0bcfe),
      surfaceTint: Color(0xffd0bcff),
      onPrimary: Color(0xff381e72),
      primaryContainer: Color(0xff4f378b),
      onPrimaryContainer: Color(0xffeaddff),
      secondary: Color(0xffccc2dc),
      onSecondary: Color(0xff332d41),
      secondaryContainer: Color(0xff4a4458),
      onSecondaryContainer: Color(0xffe8def8),
      tertiary: Color(0xffefb8c8),
      onTertiary: Color(0xff492532),
      tertiaryContainer: Color(0xff633b48),
      onTertiaryContainer: Color(0xffffd8e4),
      error: Color(0xfff2b8b5),
      onError: Color(0xff601410),
      errorContainer: Color(0xff8c1d18),
      onErrorContainer: Color(0xfff9dedc),
      surface: Color(0xff141218),
      onSurface: Color(0xffe6e0e9),
      onSurfaceVariant: Color(0xffcac4d0),
      outline: Color(0xff938f99),
      outlineVariant: Color(0xff49454f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e0e9),
      inversePrimary: Color(0xff6750a4),
      primaryFixed: Color(0xffeaddff),
      onPrimaryFixed: Color(0xff21005d),
      primaryFixedDim: Color(0xffd0bcff),
      onPrimaryFixedVariant: Color(0xff4f378b),
      secondaryFixed: Color(0xffe8def8),
      onSecondaryFixed: Color(0xff1d192b),
      secondaryFixedDim: Color(0xffccc2dc),
      onSecondaryFixedVariant: Color(0xff4a4458),
      tertiaryFixed: Color(0xffffd8e4),
      onTertiaryFixed: Color(0xff31111d),
      tertiaryFixedDim: Color(0xffefb8c8),
      onTertiaryFixedVariant: Color(0xff633b48),
      surfaceDim: Color(0xff141218),
      surfaceBright: Color(0xff3b383e),
      surfaceContainerLowest: Color(0xff0f0d13),
      surfaceContainerLow: Color(0xff1d1b20),
      surfaceContainer: Color(0xff211f26),
      surfaceContainerHigh: Color(0xff2b2930),
      surfaceContainerHighest: Color(0xff36343b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe3d6ff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff2b1b52),
      primaryContainer: Color(0xff9887c5),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffe3d6ff),
      onSecondary: Color(0xff2b1b52),
      secondaryContainer: Color(0xff9887c5),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffffd0dd),
      onTertiary: Color(0xff471228),
      tertiaryContainer: Color(0xffc57b93),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffd2ce),
      onError: Color(0xff481311),
      errorContainer: Color(0xffcc7b74),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff141318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffe0dae5),
      outline: Color(0xffb5b0bb),
      outlineVariant: Color(0xff938f99),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e9),
      inversePrimary: Color(0xff4e3f77),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff16033d),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff3c2d63),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff16033d),
      secondaryFixedDim: Color(0xffcfbdfe),
      onSecondaryFixedVariant: Color(0xff3c2d63),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff2b0013),
      tertiaryFixedDim: Color(0xffffb0c9),
      onTertiaryFixedVariant: Color(0xff5b2238),
      surfaceDim: Color(0xff141318),
      surfaceBright: Color(0xff46434a),
      surfaceContainerLowest: Color(0xff08070b),
      surfaceContainerLow: Color(0xff1e1d22),
      surfaceContainer: Color(0xff29272d),
      surfaceContainerHigh: Color(0xff343238),
      surfaceContainerHighest: Color(0xff3f3d43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfff5edff),
      surfaceTint: Color(0xffcfbdfe),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffcbb9fa),
      onPrimaryContainer: Color(0xff0f0033),
      secondary: Color(0xfff5edff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffcbb9fa),
      onSecondaryContainer: Color(0xff0f0033),
      tertiary: Color(0xffffebef),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xfffeabc5),
      onTertiaryContainer: Color(0xff20000d),
      error: Color(0xffffecea),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea7),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff141318),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xfff4eef9),
      outlineVariant: Color(0xffc6c1cc),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe6e1e9),
      inversePrimary: Color(0xff4e3f77),
      primaryFixed: Color(0xffe9ddff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffcfbdfe),
      onPrimaryFixedVariant: Color(0xff16033d),
      secondaryFixed: Color(0xffe9ddff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffcfbdfe),
      onSecondaryFixedVariant: Color(0xff16033d),
      tertiaryFixed: Color(0xffffd9e3),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffffb0c9),
      onTertiaryFixedVariant: Color(0xff2b0013),
      surfaceDim: Color(0xff141318),
      surfaceBright: Color(0xff524f55),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff211f24),
      surfaceContainer: Color(0xff322f35),
      surfaceContainerHigh: Color(0xff3d3a41),
      surfaceContainerHighest: Color(0xff48464c),
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

  List<ExtendedColor> get extendedColors => [];
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
