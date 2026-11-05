import 'course.dart';

// A class group, e.g. Programming Fundamentals taught to CS, semester 3, section A.
class ClassModel {
  final Course course;     
  final String discipline; 
  final int semester;      
  final String section;    

  const ClassModel({
    required this.course,
    required this.discipline,
    required this.semester,
    required this.section,
  });


  String get className => 'BS$discipline - $semester$section';
  String get shortName => '$discipline - $semester$section';
  String get classKey => '${course.courseCode}-$discipline-$semester$section';
}