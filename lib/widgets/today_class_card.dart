import 'package:attendance_management_system/theme/app_theme.dart';
import 'package:flutter/material.dart';

class TodayClassCard extends StatelessWidget {
  final String className;
  final String subjectName;
  final String time;
  final VoidCallback onMarkAttendance;

  const TodayClassCard({
    super.key,
    required this.className,
    required this.subjectName,
    required this.time,
    required this.onMarkAttendance,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.fieldBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: Color(0xFFEDE7FF),
            child: Icon(Icons.groups, size: 18, color: Color(0xFF6B4EFF)),
          ),
          const SizedBox(width: 8),
          // flex decides how the leftover width is shared (3 : 4 : 4).
          Expanded(
            flex: 3,
            child: _InfoColumn(value: className, label: 'Class'),
          ),
          Expanded(
            flex: 4,
            child: _InfoColumn(value: subjectName, label: 'Subject'),
          ),
          Expanded(
            flex: 4,
            child: _InfoColumn(value: time, label: 'Time'),
          ),
          ElevatedButton(
            onPressed: onMarkAttendance,
            style: ElevatedButton.styleFrom(             
              minimumSize: const Size(0, 36),
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text(
                  'Mark\nAttendance',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 9),
                ),
                Icon(Icons.chevron_right, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _InfoColumn extends StatelessWidget {
  final String value;
  final String label;

  const _InfoColumn({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 8, color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }
}