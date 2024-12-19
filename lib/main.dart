import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/timetable_screen.dart';
import 'screens/navigation_screen.dart';
import 'screens/attendance_display.dart';
import 'screens/attendance_test.dart'; // Import this file.

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(), // Ensure this widget exists.
        '/timetable': (context) => TimetableScreen(),
        '/navigation': (context) => LocationTimeScreen(),
        '/attendance_display': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          final usn = args?['usn'] ?? '';
          final dob = args?['dob'] ?? '';
          return AttendanceDisplay(usn: usn, dob: dob);
        },
        '/attendance_test': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map?;
          final username = args?['username'] ?? '1ms22ai032';
          final day = args?['day'] ?? 5;
          final month = args?['month'] ?? 2;
          final year = args?['year'] ?? 43;

          return AttendanceTest(
            username: username,
            day: day,
            month: month,
            year: year,
          );
        },
      },
    );
  }
}
