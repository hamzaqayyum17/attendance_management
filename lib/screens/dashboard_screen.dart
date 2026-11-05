import 'package:attendance_management_system/screens/mark_attendance_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart';
import '../data/schedule_options.dart';
import '../models/schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/quick_action_card.dart';
import '../widgets/today_class_card.dart';
import 'add_class_screen.dart';
import 'add_course_screen.dart';
import 'add_schedule_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Future<void> _open(Widget screen) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
    if (!mounted) return;
    setState(() {}); // empty setState = "rebuild and re-read the lists"
  }

  List<Schedule> _todaysSchedules(String todayName) {
    final list = schedules.where((s) => s.day == todayName).toList();
    list.sort(
      (a, b) => timeSlots
          .indexOf(a.timeSlot)
          .compareTo(timeSlots.indexOf(b.timeSlot)),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final todayText = DateFormat('EEE, d MMM yyyy').format(DateTime.now());
    final todayName = DateFormat('EEEE').format(DateTime.now());
    final todays = _todaysSchedules(todayName);
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeCard(),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.menu_book,
                          title: 'Add Course',
                          subtitle: 'Create a new course (subject)',
                          color: const Color(0xFF12A150),
                          background: const Color(0xFFE3F6EA),
                          onTap: () => _open(const AddCourseScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.groups,
                          title: 'Add Class',
                          subtitle: 'Create a class for a course',
                          color: AppTheme.primary,
                          background: const Color(0xFFE3F0FF),
                          onTap: () => _open(const AddClassScreen()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: QuickActionCard(
                          icon: Icons.edit_calendar,
                          title: 'Add Schedule',
                          subtitle: 'Set class timing and assign subject',
                          color: const Color(0xFFF57C00),
                          background: const Color(0xFFFFEBD6),
                          onTap: () => _open(const AddScheduleScreen()),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // "Today's Classes" title + date on the right.
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today's Classes",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: AppTheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            todayText,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (todays.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No classes scheduled for $todayName.',
                          style: const TextStyle(color: AppTheme.textGrey),
                        ),
                      ),
                    )
                  else
                    for (final s in todays)
                      TodayClassCard(
                        className:
                            findClassForCourse(s.course)?.className ??
                            s.course.courseCode,
                        subjectName: s.course.courseTitle,
                        time: s.timeSlot,

                        onMarkAttendance: () =>_open(MarkAttendanceScreen(schedule: s)),
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        MediaQuery.of(context).padding.top + 12,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppTheme.navy, AppTheme.primary]),
      ),
      child: Row(
        children: [
          const Icon(Icons.school, color: Colors.white, size: 34),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attendance\nManagement',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    height: 1.1,
                  ),
                ),
                Text(
                  'Track • Manage • Grow',
                  style: TextStyle(color: Colors.white70, fontSize: 9),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: AppTheme.navy),
          ),
          const SizedBox(width: 8),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Umar Farooq',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                'Teacher',
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
          const Icon(Icons.keyboard_arrow_down, color: Colors.white),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFDCEBFF), Colors.white],
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Manage your courses, classes\nand attendance efficiently.',
                  style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),

          Icon(
            Icons.account_balance,
            size: 64,
            color: AppTheme.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}
