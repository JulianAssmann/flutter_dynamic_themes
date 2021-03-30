import 'package:dynamic_themes/dynamic_themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DynamicThemesExampleApp());
}

/// The app's themes.
/// This class is just there to connect readable names
/// to integer theme IDs.
class AppThemes {
  static const int LightBlue = 0;
  static const int LightRed = 1;
  static const int DarkBlue = 2;
  static const int DarkRed = 3;

  static String toStr(int themeId) {
    switch (themeId) {
      case LightBlue:
        return "Light Blue";
      case LightRed:
        return "Light Red";
      case DarkBlue:
        return "Dark Blue";
      case DarkRed:
        return "Dark Red";
      default:
        return "Unknown";
    }
  }
}

class DynamicThemesExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dark = ThemeData.dark();
    final darkButtonTheme = dark.buttonTheme.copyWith(buttonColor: Colors.grey[700]);
    final darkFABTheme = dark.floatingActionButtonTheme;

    final themeCollection = ThemeCollection(
      themes: {
        AppThemes.LightBlue: ThemeData(primarySwatch: Colors.blue),
        AppThemes.LightRed: ThemeData(primarySwatch: Colors.red),
        AppThemes.DarkBlue: dark.copyWith(
          accentColor: Colors.blue, 
          buttonTheme: darkButtonTheme,
          floatingActionButtonTheme: darkFABTheme.copyWith(backgroundColor: Colors.blue)),
        AppThemes.DarkRed: dark.copyWith(
          accentColor: Colors.red, 
          buttonTheme: darkButtonTheme, 
          floatingActionButtonTheme: darkFABTheme.copyWith(backgroundColor: Colors.red),
        )
      }
    );

    return DynamicTheme(
      themeCollection: themeCollection,
      defaultThemeId: AppThemes.LightBlue,
      builder: (context, theme) {
        return MaterialApp(
          title: 'dynamic_themes example',
          theme: theme,
          home: HomePage(title: 'dynamic_themes example app'),
        );
      }
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int dropdownValue = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    dropdownValue = DynamicTheme.of(context)!.themeId;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 12),
            child: Text('Select your theme here:'),
          ),
          DropdownButton(
            icon: Icon(Icons.arrow_downward),
            value: dropdownValue,
            items: [
              DropdownMenuItem(
                value: AppThemes.LightBlue,
                child: Text(AppThemes.toStr(AppThemes.LightBlue)),
              ),
              DropdownMenuItem(
                value: AppThemes.LightRed,
                child: Text(AppThemes.toStr(AppThemes.LightRed)),
              ),
              DropdownMenuItem(
                value: AppThemes.DarkBlue,
                child: Text(AppThemes.toStr(AppThemes.DarkBlue)),
              ),
              DropdownMenuItem(
                value: AppThemes.DarkRed,
                child: Text(AppThemes.toStr(AppThemes.DarkRed)),
              )
            ], 
            onChanged: (dynamic themeId) async {
              await DynamicTheme.of(context)!.setTheme(themeId);
              setState(() {
                dropdownValue = themeId;
              });
            }
          ),
          Container(
            margin: EdgeInsets.all(20),
            width: 100,
            height: 100,
            color: theme.accentColor,
            child: Center(
              child: Text('Container in accent color', textAlign: TextAlign.center,)),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Raised Button'),
          ),
        ],
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: "Notifications"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { },
        child: Icon(Icons.add),
      ),
    );
  }
}
