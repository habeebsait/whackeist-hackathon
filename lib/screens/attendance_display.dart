import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AttendanceDisplay extends StatefulWidget {
  final String usn;
  final String dob;

  const AttendanceDisplay({Key? key, required this.usn, required this.dob})
      : super(key: key);

  @override
  State<AttendanceDisplay> createState() => _AttendanceDisplayState();
}

class _AttendanceDisplayState extends State<AttendanceDisplay> {
  Map<String, List<Map<String, dynamic>>> timetable = {};
  Map<String, Map<String, int>> attendance = {}; // Store attendance here

  @override
  void initState() {
    super.initState();
    _loadTimetable();
  }

  Future<void> _loadTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timetableJson = prefs.getString('timetable');

    if (timetableJson != null) {
      Map<String, dynamic> loadedData = json.decode(timetableJson);
      loadedData.forEach((day, events) {
        List<Map<String, dynamic>> dayEvents = [];
        for (var event in events) {
          dayEvents.add({
            'startTime': event[0],
            'endTime': event[1],
            'subject': event[2],
            'isPresent': false, // Initialize attendance as absent by default
          });
        }
        timetable[day] = dayEvents;
      });
    } else {
      // Handle case where timetable is not available
      // You might want to display an error message or load a default timetable
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'USN: ${widget.usn}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Date of Birth: ${widget.dob}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: timetable.keys.length,
                itemBuilder: (context, index) {
                  String day = timetable.keys.elementAt(index);
                  List<Map<String, dynamic>> dayEvents = timetable[day]!;
                  return ExpansionTile(
                    title: Text(
                      day,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    children: dayEvents.map((event) {
                      return ListTile(
                        title: Text(
                            '${event['startTime']}:${event['endTime'].toString().padLeft(2, '0')} - ${event['subject']}'),
                        trailing: Checkbox(
                          value: event['isPresent'],
                          onChanged: (value) {
                            setState(() {
                              event['isPresent'] = value!;
                              // Update attendance data here
                              // (e.g., save to a local database or send to a server)
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
