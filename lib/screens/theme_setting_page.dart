// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class ThemeSettingsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final themeProvider = Provider.of<ThemeProvider>(context);
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Theme Settings'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: themeProvider.isDarkMode
//                 ? [Color(0xFF1E1E1E), Color(0xFF121212)]
//                 : [Colors.teal.shade300, Colors.teal.shade100],
//           ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Appearance',
//                   style: theme.textTheme.headlineMedium?.copyWith(
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       children: [
//                         _buildThemeOption(
//                           context,
//                           title: 'Light Theme',
//                           icon: Icons.light_mode,
//                           isSelected: !themeProvider.isDarkMode,
//                           onTap: () {
//                             if (themeProvider.isDarkMode) {
//                               themeProvider.toggleTheme();
//                             }
//                           },
//                         ),
//                         Divider(),
//                         _buildThemeOption(
//                           context,
//                           title: 'Dark Theme',
//                           icon: Icons.dark_mode,
//                           isSelected: themeProvider.isDarkMode,
//                           onTap: () {
//                             if (!themeProvider.isDarkMode) {
//                               themeProvider.toggleTheme();
//                             }
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 24),
//                 Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Current Theme',
//                           style: theme.textTheme.titleLarge,
//                         ),
//                         SizedBox(height: 12),
//                         Row(
//                           children: [
//                             Icon(
//                               themeProvider.isDarkMode
//                                   ? Icons.dark_mode
//                                   : Icons.light_mode,
//                               color: theme.colorScheme.primary,
//                             ),
//                             SizedBox(width: 12),
//                             Text(
//                               themeProvider.isDarkMode
//                                   ? 'Dark Theme'
//                                   : 'Light Theme',
//                               style: theme.textTheme.bodyLarge,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildThemeOption(
//     BuildContext context, {
//     required String title,
//     required IconData icon,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     final theme = Theme.of(context);
//     return ListTile(
//       leading: Icon(
//         icon,
//         color: isSelected ? theme.colorScheme.primary : null,
//       ),
//       title: Text(
//         title,
//         style: theme.textTheme.bodyLarge?.copyWith(
//           fontWeight: isSelected ? FontWeight.bold : null,
//           color: isSelected ? theme.colorScheme.primary : null,
//         ),
//       ),
//       trailing: isSelected
//           ? Icon(
//               Icons.check_circle,
//               color: theme.colorScheme.primary,
//             )
//           : null,
//       onTap: onTap,
//     );
//   }
// }
