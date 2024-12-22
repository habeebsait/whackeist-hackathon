import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController usnController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isDarkMode = false;

  ThemeData get currentTheme => isDarkMode ? _darkTheme : _lightTheme;

  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.teal,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
  );

  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.tealAccent,
    cardColor: Color(0xFF1E1E1E),
    scaffoldBackgroundColor: Color(0xFF121212),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: currentTheme,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDarkMode
                  ? [Color(0xFF1E1E1E), Color(0xFF121212)]
                  : [Colors.teal.shade300, Colors.teal.shade100],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Theme Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              isDarkMode = !isDarkMode;
                            });
                          },
                        ),
                      ],
                    ),
                    Text(
                      'Please enter your details',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(height: 40),

                    // Main Card with Form
                    Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? currentTheme.cardColor
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'USN Number',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDarkMode
                                    ? Colors.tealAccent
                                    : Colors.teal.shade700,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: usnController,
                              decoration: InputDecoration(
                                hintText: 'Enter your USN',
                                prefixIcon: Icon(Icons.person_outline,
                                    color: isDarkMode
                                        ? Colors.tealAccent
                                        : Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Color(0xFF2C2C2C)
                                    : Colors.grey.shade100,
                              ),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your USN';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Date of Birth',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: isDarkMode
                                    ? Colors.tealAccent
                                    : Colors.teal.shade700,
                              ),
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: dobController,
                              decoration: InputDecoration(
                                hintText: 'YYYY-MM-DD',
                                prefixIcon: Icon(Icons.calendar_today,
                                    color: isDarkMode
                                        ? Colors.tealAccent
                                        : Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Color(0xFF2C2C2C)
                                    : Colors.grey.shade100,
                              ),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              readOnly: true,
                              onTap: () async {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                DateTime? selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: isDarkMode
                                              ? Colors.tealAccent
                                              : Colors.teal,
                                          onPrimary: isDarkMode
                                              ? Colors.black
                                              : Colors.white,
                                          surface: isDarkMode
                                              ? Color(0xFF1E1E1E)
                                              : Colors.white,
                                          onSurface: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (selectedDate != null) {
                                  dobController.text =
                                      "${selectedDate.toLocal()}".split(' ')[0];
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Date of Birth';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 32),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    String usn = usnController.text;
                                    String dob = dobController.text;
                                    Navigator.pushNamed(
                                      context,
                                      '/attendance_display',
                                      arguments: {'usn': usn, 'dob': dob},
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDarkMode
                                      ? Colors.tealAccent
                                      : Colors.teal.shade400,
                                  foregroundColor:
                                      isDarkMode ? Colors.black : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavigationCard(
                          context,
                          'Timetable',
                          Icons.calendar_today,
                          '/timetable',
                        ),
                        _buildNavigationCard(
                          context,
                          'Navigation',
                          Icons.navigation,
                          '/navigation',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationCard(
    BuildContext context,
    String title,
    IconData icon,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDarkMode ? currentTheme.cardColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 40,
              color: isDarkMode ? Colors.tealAccent : Colors.teal.shade400,
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.tealAccent : Colors.teal.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
