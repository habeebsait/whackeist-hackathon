import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationTimeScreen extends StatefulWidget {
  @override
  _LocationTimeScreenState createState() => _LocationTimeScreenState();
}

class _LocationTimeScreenState extends State<LocationTimeScreen> {
  final TextEditingController originController = TextEditingController();
  String eta = "";

  Future<void> getETA(String origin) async {
    try {
      final apiKey =
          "AIzaSyBz1dJG9aIwD7NKHcFSFrhhS8ewZkW1EzQ"; // Replace with your secure API Key
      final destination = "Ramaiah Institute of Technology, Bangalore, India";
      final url =
          "https://maps.googleapis.com/maps/api/directions/json?origin=${Uri.encodeFull(origin)}&destination=${Uri.encodeFull(destination)}&key=$apiKey";

      print("Request URL: $url"); // Debug: Print the URL

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response JSON: $data"); // Debug: Print raw JSON

        // Extract the duration text from the JSON response
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final legs = data['routes'][0]['legs'];
          if (legs != null && legs.isNotEmpty) {
            final duration = legs[0]['duration']['text'];
            setState(() {
              eta = "ETA: $duration";
            });
          } else {
            setState(() {
              eta = "No route found.";
            });
          }
        } else {
          setState(() {
            eta = "No routes available.";
          });
        }
      } else {
        setState(() {
          eta = "Failed to fetch data: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        eta = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get ETA to Ramaiah Institute of Technology"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: originController,
              decoration: InputDecoration(
                labelText: 'Enter Origin Location',
                hintText: 'e.g., San Francisco',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (originController.text.isNotEmpty) {
                  getETA(originController.text);
                }
              },
              child: Text("Get ETA"),
            ),
            SizedBox(height: 20),
            Text(
              eta,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
