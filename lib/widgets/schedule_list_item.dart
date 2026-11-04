import 'package:flutter/material.dart';
import '../theme/app_theme.dart';


class ScheduleListItem extends StatelessWidget {
  final String subject;   
  final String classLabel;
  final String day;
  final String time;
  final Color color;   
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ScheduleListItem({
    super.key,
    required this.subject,
    required this.classLabel,
    required this.day,
    required this.time,
    required this.color,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.fieldBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: color.withValues(alpha: 0.15),
            child: Icon(Icons.menu_book, size: 16, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.bold)),
                Text(classLabel,
                    style: const TextStyle(
                        fontSize: 9, color: AppTheme.textGrey)),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _iconText(Icons.calendar_today, day),
                const SizedBox(height: 2),
                _iconText(Icons.access_time, time),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.edit, size: 18, color: AppTheme.primary),
          ),
          IconButton(
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.delete, size: 18, color: Colors.red),
          ),
        ],
      ),
    );
  }

 
  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 11, color: AppTheme.primary),
        const SizedBox(width: 3),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 9))),
      ],
    );
  }
}