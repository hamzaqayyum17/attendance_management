import 'package:attendance_management_system/data/app_user.dart';
import 'package:attendance_management_system/models/course.dart';
import '../models/class_model.dart';
import '../models/schedule.dart';

final List<AppUser> appUsers = [
  const AppUser(email: 'teacher@biit.edu.pk', password: '123456'),
  const AppUser(email: '2024-CS-0001', password: '123456'),
  const AppUser(email: 'admin@biit.edu.pk', password: 'admin123'),
];
final List<Course> courses = [];
final List<ClassModel> classes = [];
final List<Schedule> schedules = [];
ClassModel? findClassForCourse(Course course) {
  for (final c in classes) {
    if (c.course.courseCode == course.courseCode) return c;
  }
  return null; 
}