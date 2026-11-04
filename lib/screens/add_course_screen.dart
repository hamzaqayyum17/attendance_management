import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/course.dart';
import '../theme/app_theme.dart';
import '../widgets/app_header.dart';
import '../widgets/field_label.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  // The key lets us reach this Form to run validate() / reset() on it.
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    // Runs every validator. If any returns a message, stop here.
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      courseTitle: _titleController.text.trim(),
      courseCode: _codeController.text.trim().toUpperCase(),
    );

    
    courses.add(course);

    
    _formKey.currentState!.reset();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text('Course saved: ${course.courseTitle} (${course.courseCode})'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          const AppHeader(title: 'Add Course'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro card: title, description, illustration placeholder.
                  Container(
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
                                'Add Course',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.navy,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Create a new course (subject)\nto use in your classes.',
                                style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.auto_stories,
                          size: 60,
                          color: AppTheme.primary.withValues(alpha: 0.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FieldLabel('Course Title'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: AppTheme.inputDecoration(
                            hint: 'Enter course title',
                            icon: Icons.menu_book_outlined,
                          ),
                          // value is String? because it can be null.
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Course title is required';
                            }
                            return null; // null = valid
                          },
                        ),
                        const SizedBox(height: 20),

                        const FieldLabel('Course Code'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _codeController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: AppTheme.inputDecoration(
                            hint: 'Enter course code',
                            icon: Icons.sell_outlined,
                            helper: 'e.g. CS101, MATH201, PF102',
                          ),
                          validator: (value) {
                            final code = (value ?? '').trim();

                            
                            if (code.isEmpty) return 'Course code is required';

                            
                            if (!RegExp(r'^[A-Za-z]{2,}[0-9]{2,}$').hasMatch(code)) {
                              return 'Use letters then numbers, e.g. CS101';
                            }

                            
                            final exists = courses.any(
                              (c) => c.courseCode.toLowerCase() == code.toLowerCase(),
                            );
                            if (exists) return 'This course code already exists';

                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _saveCourse,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Save Course',
                                  style: TextStyle(fontWeight: FontWeight.bold)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                        ),
                      ],
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
}