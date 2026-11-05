import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/attendance_student.dart';
import '../theme/app_theme.dart';
import 'field_label.dart';

class AddStudentDialog extends StatefulWidget {
  final String classKey;

  const AddStudentDialog({super.key, required this.classKey});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _regController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _regController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _addStudent() {
   
    if (!_formKey.currentState!.validate()) return;

    final student = AttendanceStudent(
      classKey: widget.classKey,
      registrationNumber: _regController.text.trim().toUpperCase(),
      studentName: _nameController.text.trim(),
   
    );

    attendanceStudents.add(student); // global list

   
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min, // dialog is only as tall as its content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFFE3F0FF),
                  child: Icon(Icons.person_add_alt_1, color: AppTheme.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Student',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.navy,
                        ),
                      ),
                      Text(
                        'Enter student registration number and name to add to this class.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textGrey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  // pop without a value = user cancelled
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ---- The two fields ----
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FieldLabel('Registration Number'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _regController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: AppTheme.inputDecoration(
                      hint: 'Enter registration number',
                      icon: Icons.badge_outlined,
                      helper: 'e.g. 2024-CS-0001',
                    ),
                    validator: (value) {
                      final reg = (value ?? '').trim();

                      if (reg.isEmpty) return 'Registration number is required';

                      
                      if (!RegExp(r'^\d{4}-[A-Za-z]{2,}-\d{4}$').hasMatch(reg)) {
                        return 'Use the format 2024-CS-0001';
                      }

                      
                      final exists = attendanceStudents.any(
                        (s) =>
                            s.classKey == widget.classKey &&
                            s.registrationNumber.toLowerCase() ==
                                reg.toLowerCase(),
                      );
                      if (exists) return 'This student is already in the class';

                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  const FieldLabel('Student Name'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: AppTheme.inputDecoration(
                      hint: 'Enter student name',
                      icon: Icons.person_outline,
                      helper: 'e.g. Ali Raza',
                    ),
                    validator: (value) {
                      final name = (value ?? '').trim();
                      if (name.isEmpty) return 'Student name is required';
                      if (name.length < 2) return 'Name is too short';
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _addStudent,

                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                    child: const Text(
                      'Add Student',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}