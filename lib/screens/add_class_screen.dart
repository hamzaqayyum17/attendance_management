import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/class_model.dart';
import '../models/course.dart';
import '../theme/app_theme.dart';
import '../widgets/app_dropdown.dart';
import '../widgets/app_header.dart';
import '../widgets/field_label.dart';
import '../widgets/intro_card.dart';

class AddClassScreen extends StatefulWidget {
  const AddClassScreen({super.key});

  @override
  State<AddClassScreen> createState() => _AddClassScreenState();
}

class _AddClassScreenState extends State<AddClassScreen> {
  final _formKey = GlobalKey<FormState>();

  
  Course? _course;
  String _discipline = 'CS'; 
  int? _semester;
  String? _section;

  
  final List<int> _semesters = List.generate(8, (i) => i + 1); 
  final List<String> _sections = ['A', 'B', 'C', 'D', 'E'];

  void _showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(text),
      ),
    );
  }

  void _saveClass() {
    
    if (!_formKey.currentState!.validate()) return;

    final newClass = ClassModel(
      course: _course!,
      discipline: _discipline,
      semester: _semester!,
      section: _section!,
    );

    
    final exists = classes.any(
      (c) =>
          c.course.courseCode == newClass.course.courseCode &&
          c.discipline == newClass.discipline &&
          c.semester == newClass.semester &&
          c.section == newClass.section,
    );
    if (exists) {
      _showMessage('This class already exists.', isError: true);
      return;
    }

    classes.add(newClass);

    
    _formKey.currentState!.reset();
    setState(() {
      _course = null;
      _semester = null;
      _section = null;
      _discipline = 'CS';
    });

    _showMessage('Class saved: ${newClass.className} (${newClass.course.courseTitle})');
  }

 
  Widget _disciplineOption(String code, String fullName) {
    final selected = _discipline == code;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => setState(() => _discipline = code), // tap anywhere on the box
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE6F0FF) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? AppTheme.primary : AppTheme.fieldBorder,
            ),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: code, // the value this radio represents
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(code,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                    Text(
                      fullName,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 8, color: AppTheme.textGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FD),
      body: Column(
        children: [
          const AppHeader(title: 'Add Class'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const IntroCard(
                    title: 'Add Class',
                    subtitle:
                        'Create a new class and assign it to a\nsubject with class details.',
                    icon: Icons.groups,
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ---- Subject (from the global course list) ----
                        const FieldLabel('Subject (Course)'),
                        const SizedBox(height: 8),
                        AppDropdown<Course>(
                          hint: 'Select Subject',
                          icon: Icons.menu_book_outlined,
                          items: courses, // <-- the global list from Step 4
                          labelOf: (c) => c.displayName,
                          onChanged: (value) => _course = value,
                          validator: (value) =>
                              value == null ? 'Please select a subject' : null,
                        ),
                        if (courses.isEmpty)
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Text(
                              'No courses yet. Add a course first.',
                              style: TextStyle(fontSize: 12, color: Colors.orange),
                            ),
                          ),
                        const SizedBox(height: 20),

                        // ---- Discipline (radio buttons) ----
                        const FieldLabel('Discipline'),
                        const SizedBox(height: 8),
                        RadioGroup<String>(
                          groupValue: _discipline,
                          onChanged: (value) {
                            if (value != null) setState(() => _discipline = value);
                          },
                          child: Row(
                            children: [
                              _disciplineOption('CS', 'Computer Science'),
                              const SizedBox(width: 8),
                              _disciplineOption('AI', 'Artificial Intelligence'),
                              const SizedBox(width: 8),
                              _disciplineOption('SE', 'Software Engineering'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ---- Semester 1-8 ----
                        const FieldLabel('Semester'),
                        const SizedBox(height: 8),
                        AppDropdown<int>(
                          hint: 'Select Semester (1 - 8)',
                          icon: Icons.school_outlined,
                          items: _semesters,
                          labelOf: (n) => '$n',
                          onChanged: (value) => _semester = value,
                          validator: (value) =>
                              value == null ? 'Please select a semester' : null,
                        ),
                        const SizedBox(height: 20),

                        // ---- Section A-E ----
                        const FieldLabel('Section'),
                        const SizedBox(height: 8),
                        AppDropdown<String>(
                          hint: 'Select Section (A - E)',
                          icon: Icons.groups_2_outlined,
                          items: _sections,
                          labelOf: (s) => s,
                          onChanged: (value) => _section = value,
                          validator: (value) =>
                              value == null ? 'Please select a section' : null,
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _saveClass,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Save Class',
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