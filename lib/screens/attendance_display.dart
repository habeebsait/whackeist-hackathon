import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendanceDisplay extends StatefulWidget {
  @override
  _AttendanceDisplayState createState() => _AttendanceDisplayState();
}

class _AttendanceDisplayState extends State<AttendanceDisplay> {
  late Future<Map<String, dynamic>> _attendanceData;
  late String usn;
  late String dob;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Access ModalRoute arguments after initState has completed
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    usn = args?['usn'] ?? 'Unknown';
    dob = args?['dob'] ?? 'Unknown';

    // Validate arguments
    if (usn == 'Unknown' || dob == 'Unknown') {
      throw Exception('Missing required arguments: usn or dob');
    }

    _attendanceData = _fetchAttendanceData();
  }

  Future<Map<String, dynamic>> _fetchAttendanceData() async {
    // Calculate year_pass, month_pass, and day_pass
    int year = int.parse(dob.substring(0, 4));
    int year_pass = (year - 1962);
    int month = int.parse(dob.substring(5, 7));
    int month_pass = month + 1;
    int day = int.parse(dob.substring(8, 10));
    int day_pass = day + 1;

    final String apiUrl =
        'http://192.168.0.125:5001/scrape-attendance'; // Backend URL

    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?usn=$usn&day=$day_pass&month=$month_pass&year=$year_pass'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception(
            'Failed to load attendance data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching attendance data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Data'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _attendanceData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No Data Available'));
          } else {
            final subjects = snapshot.data!['subjects'] as List;
            final attendance = snapshot.data!['attendance'] as List;

            return ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(subjects[index]),
                  subtitle: Text('Attendance: ${attendance[index]}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
