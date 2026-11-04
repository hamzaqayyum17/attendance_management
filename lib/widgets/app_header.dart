import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class AppHeader extends StatelessWidget {
  final String title;
  const AppHeader({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        4,
        MediaQuery.of(context).padding.top + 8, // below the status bar
        16,
        14,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.navy, AppTheme.primary]),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(Icons.school, color: Colors.white, size: 28),
          const SizedBox(width: 6),
          const Text(
            'Attendance\nManagement',
            style: TextStyle(color: Colors.white, fontSize: 10, height: 1.1),
          ),
        ],
      ),
    );
  }
}
