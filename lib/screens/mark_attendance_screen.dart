import 'package:attendance_management_system/widgets/add_student_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/app_data.dart';
import '../models/attendance_student.dart';
import '../models/class_model.dart';
import '../models/schedule.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';

class MarkAttendanceScreen extends StatefulWidget {
  final Schedule schedule; 

  const MarkAttendanceScreen({super.key, required this.schedule});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  DateTime _selectedDate = DateTime.now(); 

  
  ClassModel? get _classModel => findClassForCourse(widget.schedule.course);

  String get _classKey =>
      _classModel?.classKey ?? widget.schedule.course.courseCode;

  List<AttendanceStudent> get _students =>
      attendanceStudents.where((s) => s.classKey == _classKey).toList();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null) return; 
    if (!mounted) return;
    setState(() => _selectedDate = picked);
  }

  void _toggleStatus(AttendanceStudent student) {
    setState(() {
      student.status = student.status == 'P' ? 'A' : 'P';
    });
  }
  
  Future<void> _openAddStudent() async {
    final added = await showDialog<bool>(
      context: context,
      builder: (_) => AddStudentDialog(classKey: _classKey),
    );

    if (!mounted) return;
    if (added == true) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Student added'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final students = _students; // compute once per build
    final presentCount = students.where((s) => s.status == 'P').length;
    final absentCount = students.length - presentCount;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddStudent,
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const AppHeader(title: 'Mark Attendance'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  _buildClassCard(),
                  const SizedBox(height: 12),
                  _buildDateRow(),
                  const SizedBox(height: 14),

                  
                  Row(
                    children: [
                      Text(
                        'Students (${students.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      const Spacer(),
                      _countChip('Present', presentCount, Colors.green),
                      const SizedBox(width: 6),
                      _countChip('Absent', absentCount, Colors.red),
                    ],
                  ),
                  const SizedBox(height: 10),

                  _buildTableHeader(),
                  Expanded(
                    child: students.isEmpty
                        ? const Center(
                            child: Text(
                              'No students yet. Tap + to add one.',
                              style: TextStyle(color: AppTheme.textGrey),
                            ),
                          )
                        : ListView.builder(
                           
                            padding: const EdgeInsets.only(bottom: 90),
                            itemCount: students.length,
                            itemBuilder: (context, index) =>
                                _buildStudentRow(index, students[index]),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildClassCard() {
    final cls = _classModel;
    final schedule = widget.schedule;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.fieldBorder),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFFE3F0FF),
            child: Icon(Icons.menu_book, color: AppTheme.primary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule.course.courseTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.navy,
                  ),
                ),
                Text(
                  cls == null
                      ? schedule.course.courseCode
                      : '${cls.shortName} | Semester ${cls.semester}',
                  style: const TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                schedule.day,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
              ),
              Text(
                schedule.timeSlot,
                style: const TextStyle(fontSize: 10, color: AppTheme.textGrey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  
  Widget _buildDateRow() {
    return Row(
      children: [
        const Text('Date', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 16),
        Expanded(
          child: InkWell(
            onTap: _pickDate,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.fieldBorder),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18, color: AppTheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      DateFormat('EEE, dd MMM yyyy').format(_selectedDate),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: AppTheme.textGrey),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _countChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$label  $count',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    const style = TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      color: AppTheme.textGrey,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFFE9F0FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      child: const Row(
        children: [
          SizedBox(width: 28, child: Text('#', style: style)),
          Expanded(flex: 3, child: Text('Reg. No', style: style)),
          Expanded(flex: 3, child: Text('Student Name', style: style)),
          SizedBox(width: 44, child: Text('Status', style: style)),
        ],
      ),
    );
  }

  Widget _buildStudentRow(int index, AttendanceStudent student) {
    final isPresent = student.status == 'P';
    final color = isPresent ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAEFF6))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text('${index + 1}', style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(student.registrationNumber,
                style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 3,
            child: Text(student.studentName,
                style: const TextStyle(fontSize: 12)),
          ),
          InkWell(
            onTap: () => _toggleStatus(student),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 44,
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  student.status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}