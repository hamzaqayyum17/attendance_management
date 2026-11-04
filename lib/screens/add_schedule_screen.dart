import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../data/schedule_options.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_header.dart';
import '../widgets/field_label.dart';
import '../widgets/schedule_list_item.dart';

class AddScheduleScreen extends StatefulWidget {
  const AddScheduleScreen({super.key});

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();

  
  Course? _course;
  String? _day;
  String? _timeSlot;
int _formVersion = 0;

  static const List<Color> _itemColors = [
    Color(0xFF2F80ED),
    Color(0xFF12A150),
    Color(0xFFF57C00),
    Color(0xFF7B4DFF),
    Color(0xFFE5484D),
  ];

  void _showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(text),
      ),
    );
  }

  void _resetFields() {
    _course = null;
    _day = null;
    _timeSlot = null;
    _formVersion++; 
  }

  void _addToList() {

    if (!_formKey.currentState!.validate()) return;

    final course = _course!;
    final day = _day!;
    final slot = _timeSlot!;

  
    if (findClassForCourse(course) == null) {
      _showMessage(
        'No class exists for ${course.courseTitle}. Create a class first.',
        isError: true,
      );
      return;
    }

    
    final taken = schedules.any((s) => s.day == day && s.timeSlot == slot);
    if (taken) {
      _showMessage('$day, $slot is already scheduled.', isError: true);
      return;
    }

    
    setState(() {
      schedules.add(Schedule(course: course, day: day, timeSlot: slot));
      _resetFields();
    });
    _showMessage('Added: ${course.courseTitle} on $day');
  }

 
  Widget _formRow(String label, Widget field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 84,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FieldLabel(label),
            ),
          ),
          Expanded(child: field),
        ],
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card title
          const Row(
            children: [
              Icon(Icons.edit_calendar, size: 36, color: AppTheme.primary),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Class Schedule',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.navy,
                      ),
                    ),
                    Text(
                      'Select your subject, day and time to create a class schedule.',
                      style: TextStyle(fontSize: 10, color: AppTheme.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _formRow(
                  'Subject',
                  AppDropdown<Course>(
                    key: ValueKey('subject$_formVersion'),
                    hint: 'Select Subject',
                    icon: Icons.menu_book_outlined,
                    items: courses, // global course list from Step 4
                    initialValue: _course,
                    labelOf: (c) => c.displayName,
                    onChanged: (value) => _course = value,
                    validator: (v) => v == null ? 'Select a subject' : null,
                  ),
                ),
                _formRow(
                  'Day',
                  AppDropdown<String>(
                    key: ValueKey('day$_formVersion'),
                    hint: 'Select Day',
                    icon: Icons.calendar_month_outlined,
                    items: weekDays,
                    initialValue: _day,
                    labelOf: (d) => d,
                    onChanged: (value) => _day = value,
                    validator: (v) => v == null ? 'Select a day' : null,
                  ),
                ),
                _formRow(
                  'Time Slot',
                  AppDropdown<String>(
                    key: ValueKey('slot$_formVersion'),
                    hint: 'Select Time Slot',
                    icon: Icons.access_time,
                    items: timeSlots,
                    initialValue: _timeSlot,
                    labelOf: (t) => t,
                    onChanged: (value) => _timeSlot = value,
                    validator: (v) => v == null ? 'Select a time slot' : null,
                  ),
                ),
              ],
            ),
          ),

          // Clear + Add to List
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(_resetFields),
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _addToList,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add to List'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          const AppHeader(title: 'Add Class Schedule'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFormCard(),
                  const SizedBox(height: 18),

                  // "Scheduled Classes" title + Total chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Scheduled Classes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F0FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Total: ${schedules.length}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (schedules.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No classes scheduled yet.',
                          style: TextStyle(color: AppTheme.textGrey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: schedules.length,
                      itemBuilder: (context, index) {
                        final item = schedules[index];
                        final cls = findClassForCourse(item.course);
                        return ScheduleListItem(
                          subject: item.course.courseTitle,
                          classLabel: cls == null
                              ? item.course.courseCode
                              : '${item.course.courseCode} - ${cls.semester}${cls.section}',
                          day: item.day,
                          time: item.timeSlot,
                          color: _itemColors[index % _itemColors.length],
                          // Placeholders: wired up in Step 7.
                          onEdit: () =>
                              _showMessage('Edit is added in the next step'),
                          onDelete: () =>
                              _showMessage('Delete is added in the next step'),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
