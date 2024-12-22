import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/navigation_screen.dart';
import 'screens/attendance_display.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line

  final themeProvider = ThemeProvider();
  await themeProvider.loadThemeFromPrefs(); // Load theme before running app

  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'Flutter App',
          theme: themeProvider.currentTheme,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            final arguments = settings.arguments as Map<String, dynamic>?;
            switch (settings.name) {
              case '/':
                return MaterialPageRoute(builder: (_) => HomeScreen());
              case '/timetable':
                return MaterialPageRoute(builder: (_) => TimetableScreen());
              case '/navigation':
                return MaterialPageRoute(builder: (_) => LocationTimeScreen());
              case '/attendance_display':
                return MaterialPageRoute(
                  builder: (_) => AttendanceDisplay(),
                  settings: RouteSettings(arguments: arguments),
                );
              default:
                return null;
            }
          },
        );
      },
    );
  }
}
