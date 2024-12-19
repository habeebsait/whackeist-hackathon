import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart'; // For parsing HTML

// AttendanceFetcher class
class AttendanceFetcher {
  final String username;
  final String day;
  final String month;
  final String year;

  AttendanceFetcher({
    required this.username,
    required this.day,
    required this.month,
    required this.year,
  });

  Future<Map<String, List<String>>> fetchAttendance() async {
    final url = Uri.parse("https://parents.msrit.edu/newparents/");

    var response = await http.post(
      url,
      body: {
        'username': username,
        'dd': day,
        'mm': month,
        'yyyy': year,
      },
    );

    if (response.statusCode == 200) {
      var document = parse(response.body);

      List<String> subjects = [];
      for (int i = 1; i <= 10; i++) {
        var cell = document.querySelector(
            '#page_bg > div:nth-child(1) > div > div > div[5] > div > div > div > table > tbody > tr:nth-child($i) > td:nth-child(2)');
        subjects.add(cell?.text.trim() ?? "N/A");
      }

      List<String> attendance = [];
      for (int i = 1; i <= 10; i++) {
        var button = document.querySelector(
            '#page_bg > div:nth-child(1) > div > div > div[5] > div > div > div > table > tbody > tr:nth-child($i) > td:nth-child(5) > a > button');
        attendance.add(button?.text.trim() ?? "N/A");
      }

      return {'subjects': subjects, 'attendance': attendance};
    } else {
      throw Exception("Login Failed: ${response.statusCode}");
    }
  }
}

// Main Application
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/attendance': (context) => AttendancePage(),
      },
    );
  }
}

// LoginPage
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            TextField(
              controller: _dayController,
              decoration: InputDecoration(labelText: "Day"),
            ),
            TextField(
              controller: _monthController,
              decoration: InputDecoration(labelText: "Month"),
            ),
            TextField(
              controller: _yearController,
              decoration: InputDecoration(labelText: "Year"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/attendance',
                  arguments: {
                    'username': _usernameController.text,
                    'day': _dayController.text,
                    'month': _monthController.text,
                    'year': _yearController.text,
                  },
                );
              },
              child: Text("Fetch Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}

// AttendancePage
class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Attendance")),
        body: Center(child: Text("No data provided!")),
      );
    }

    final username = args['username']!;
    final day = args['day']!;
    final month = args['month']!;
    final year = args['year']!;

    return Scaffold(
      appBar: AppBar(title: Text("Attendance")),
      body: FutureBuilder<Map<String, List<String>>>(
        future: AttendanceFetcher(
          username: username,
          day: day,
          month: month,
          year: year,
        ).fetchAttendance(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final subjects = snapshot.data!['subjects']!;
            final attendance = snapshot.data!['attendance']!;
            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subjects[index]),
                  subtitle: Text("Attendance: ${attendance[index]}"),
                );
              },
            );
          } else {
            return Center(child: Text("No attendance data found!"));
          }
        },
      ),
    );
  }
}
