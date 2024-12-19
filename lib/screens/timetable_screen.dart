import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  final Map<String, List<Tuple3<int, int, String>>> timetable = {};
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  String _selectedDay = "Monday";
  Tuple3<int, int, String>? _editingEvent;
  int? _eventIndex;

  @override
  void initState() {
    super.initState();
    _loadTimetable(); // Load the timetable when the screen is initialized
  }

  // Load timetable data from SharedPreferences
  Future<void> _loadTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? timetableJson = prefs.getString('timetable');

    if (timetableJson != null) {
      Map<String, dynamic> loadedData = json.decode(timetableJson);

      loadedData.forEach((day, events) {
        List<Tuple3<int, int, String>> dayEvents = [];
        for (var event in events) {
          dayEvents.add(Tuple3(event[0], event[1], event[2]));
        }
        timetable[day] = dayEvents;
      });
    } else {
      // Default timetable if no data found
      _initializeDefaultTimetable();
    }

    // Ensure each day has an empty list initialized
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    for (var day in days) {
      timetable.putIfAbsent(day, () => []);
    }

    setState(() {});
  }

  // Initialize timetable with default data if SharedPreferences is empty
  void _initializeDefaultTimetable() {
    timetable.addAll({
      "Monday": [
        Tuple3(9, 0, "AI53 NLP (AJA)"),
        Tuple3(9, 55, "AIE553 COA (SM)"),
        Tuple3(11, 5, "AL58 RM (VBP, BM)"),
        Tuple3(12, 0, "AI52 OS (AMF)"),
      ],
      "Tuesday": [
        Tuple3(9, 0, "AI53 NLP (AJA)"),
        Tuple3(9, 55, "AIE553 COA (SM)"),
        Tuple3(11, 5, "AI51 D Science Lab (MAK, SBN, BHP)"),
        Tuple3(13, 45, "AI54 ML (MSM)"),
      ],
      // Add other days similarly
    });
  }

  // Save timetable data to SharedPreferences
  Future<void> _saveTimetable() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> timetableJson = {};

    timetable.forEach((day, events) {
      timetableJson[day] =
          events.map((e) => [e.item1, e.item2, e.item3]).toList();
    });

    prefs.setString('timetable', json.encode(timetableJson));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Timetable"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButton<String>(
                value: _selectedDay,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDay = newValue!;
                  });
                },
                items:
                    timetable.keys.map<DropdownMenuItem<String>>((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        day,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.teal),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: Text(
                      _selectedDay,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    children: timetable[_selectedDay]!.map((event) {
                      String time =
                          "${event.item1}:${event.item2.toString().padLeft(2, '0')}";
                      String subject = event.item3;
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          title: Text(
                            "$time - $subject",
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.edit, color: Colors.teal),
                            onPressed: () {
                              _timeController.text = "$time";
                              _subjectController.text = subject;
                              _editEvent(event);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _timeController,
                        decoration: InputDecoration(
                          labelText: "Time (HH:mm)",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.datetime,
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _subjectController,
                        decoration: InputDecoration(
                          labelText: "Subject",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _addEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: EdgeInsets.symmetric(horizontal: 40),
                        ),
                        child: Text(
                          _editingEvent == null ? "Save Event" : "Update Event",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addEvent() {
    final timeParts = _timeController.text.split(":");
    if (timeParts.length == 2) {
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final subject = _subjectController.text;

      setState(() {
        if (_editingEvent == null) {
          timetable[_selectedDay]!.add(Tuple3(hour, minute, subject));
        } else {
          timetable[_selectedDay]![_eventIndex!] =
              Tuple3(hour, minute, subject);
        }
      });

      _saveTimetable(); // Save the updated timetable

      _timeController.clear();
      _subjectController.clear();
      _editingEvent = null;
      _eventIndex = null;
    }
  }

  void _editEvent(Tuple3<int, int, String> event) {
    final index = timetable[_selectedDay]!.indexOf(event);
    setState(() {
      _eventIndex = index;
      _editingEvent = event;
      _timeController.text =
          "${event.item1}:${event.item2.toString().padLeft(2, '0')}";
      _subjectController.text = event.item3;
    });
  }
}
