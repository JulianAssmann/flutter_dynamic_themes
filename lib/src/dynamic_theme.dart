library dynamic_themes;

import 'package:dynamic_themes/src/theme_collection.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Signature for the `builder` function which takes the [BuildContext] and
/// [ThemeData] as arguments and is responsible for returning a [Widget]
/// in the corresponding theme.
typedef ThemedWidgetBuilder = Widget Function(
    BuildContext context, ThemeData themeData);

/// [DynamicTheme] handles building a widget in response to a new theme.
class DynamicTheme extends StatefulWidget {
  final ThemedWidgetBuilder builder;
  final int defaultThemeId;
  final ThemeCollection themeCollection;

  /// Creates a new [DynamicTheme] to handle dynamic themes.
  /// 
  /// [builder] returns a [Widget] themed according to the current theme passed as a parameter.
  /// [themeCollection] is the [ThemeCollection] mapping theme IDs to [ThemeData] themes.
  /// [defaultThemeId] is the ID of the theme to choose, if there is no theme ID saved in the preferences yet.
  /// Default is 0.
  /// 
  /// Example:
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   final themeCollection = ThemeCollection(
  ///     themes: {
  ///       0: ThemeData(primarySwatch: Colors.blue),
  ///       1: ThemeData(primarySwatch: Colors.red),
  ///       2: ThemeData.dark()
  ///     }
  ///   );
  ///   
  ///   return DynamicTheme(
  ///     themeCollection: themeCollection,
  ///     defaultThemeId: 0,
  ///     builder: (context, theme) {
  ///       return MaterialApp(
  ///         title: 'dynamic_themes example',
  ///         theme: theme,
  ///         home: HomePage(title: 'dynamic_themes example app'),
  ///       );
  ///     }
  ///   );
  /// }
  /// ```
  const DynamicTheme(
      {Key key,
      @required this.builder,
      @required this.themeCollection,
      this.defaultThemeId = 0})
      : assert(themeCollection != null),
        super(key: key);

  @override
  _DynamicThemeState createState() => _DynamicThemeState();

  /// Returns the data from the closest [DynamicTheme] instance that encloses the given context.
  static _DynamicThemeState of(BuildContext context) {
    return context.findAncestorStateOfType<_DynamicThemeState>();
  }
}

/// The data from the closest [DynamicTheme] instance that encloses the given context.
class _DynamicThemeState extends State<DynamicTheme> {
  static const String _sharedPreferencesKey = 'selectedThemeId';
  ThemeData _currentTheme;
  int _currentThemeId;

  /// Gets the theme currently set.
  ThemeData get theme => _currentTheme;

  /// Gets the id of the theme currently set.
  int get themeId => _currentThemeId;

  @override
  void initState() {
    super.initState();
    _currentThemeId = widget.defaultThemeId;
    _currentTheme = widget.themeCollection[_currentThemeId];

    _loadThemeIdFromPreferences().then((int themeId) {
      _currentTheme = widget.themeCollection[themeId];
      _currentThemeId = themeId;

      if (mounted) {
        setState(() {}); // Update
      }
    });
  }

  /// Sets the theme of the app to the [ThemeData] that corresponds to the [themeId].
  /// If no [ThemeData] is registered for the given [themeId], the [ThemeCollection]s
  /// fallback theme is used.
  Future<void> setTheme(int themeId) async {
    setState(() {
      _currentTheme = widget.themeCollection[themeId];
      _currentThemeId = themeId;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_sharedPreferencesKey, _currentThemeId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentTheme = widget.themeCollection[_currentThemeId];
  }

  @override
  void didUpdateWidget(DynamicTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentTheme = widget.themeCollection[_currentThemeId];
  }

  /// Loads the theme id from the shared preferences.
  /// Returns the [defaultThemeId] if none is set.
  Future<int> _loadThemeIdFromPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_sharedPreferencesKey)) {
      try {
        return prefs.getInt(_sharedPreferencesKey);
      } on Exception {
        return widget.defaultThemeId;
      }
    }
    return widget.defaultThemeId;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _currentTheme);
  }
}
