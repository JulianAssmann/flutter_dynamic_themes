import 'package:flutter/material.dart';

/// A collection of theme ID/[ThemeData] pairs, from which you retrieve a
/// [ThemeData] using its associated theme ID.
class ThemeCollection {
  late Map<int, ThemeData> _themes;
  late ThemeData _fallbackTheme;

  /// The fallback theme.
  ThemeData get fallbackTheme => _fallbackTheme;

  /// Creates a new [ThemeCollection].
  ///
  /// [themes] is an optional paramter of a map,
  /// that already contains themes corresponding to theme IDs.
  ///
  /// [fallbackTheme] is a fallback theme, that is returned by [getTheme]
  ThemeCollection({Map<int, ThemeData>? themes, ThemeData? fallbackTheme}) {
    if (themes == null) {
      themes = Map<int, ThemeData>();
    } else {
      _themes = themes;
    }

    if (fallbackTheme == null) {
      _fallbackTheme = ThemeData.fallback();
    } else {
      _fallbackTheme = fallbackTheme;
    }
  }

  /// Returns true if this [ThemeCollection] has sepcific [ThemeData] stored for the given [themeId].
  /// If this returns false, retrieving the [ThemeData] for [themeId]
  /// yields the [fallbackTheme] specified in the constructor.
  bool hasThemeForId(int themeId) => _themes.containsKey(themeId);

  /// Returns the [ThemeData] for the given [themeId] or
  /// the [fallbackTheme] specified in the constructor
  /// if [themeId] is not registered in the collection.
  ThemeData operator [](int themeId) {
    if (_themes.containsKey(themeId)) 
      return _themes[themeId]!;
    else
      return _fallbackTheme;
  }

  /// Associates the [themeId] with the given [theme].
  ///
  /// If the [themeId] was already in the collection, its associated [theme] is changed.
  /// Otherwise the [themeId]/[theme] pair is added to the collection.
  operator []=(int themeId, ThemeData theme) => _themes[themeId] = theme;

  /// Associates the [themeId] with the given [theme].
  ///
  /// If the [themeId] was already in the collection, its associated [theme] is changed.
  /// Otherwise the [themeId]/[theme] pair is added to the collection.
  void addTheme(int themeId, ThemeData theme) {
    this[themeId] = theme;
  }
}
