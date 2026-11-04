import 'course.dart';


class Schedule {
  final Course course;
  final String day;      
  final String timeSlot; 

  const Schedule({
    required this.course,
    required this.day,
    required this.timeSlot,
  });
}