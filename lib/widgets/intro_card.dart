import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class IntroCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const IntroCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFFDCEBFF), Colors.white]),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          Icon(icon, size: 60, color: AppTheme.primary.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}