class Course {
  final String courseTitle;
  final String courseCode;

  const Course({required this.courseTitle, required this.courseCode});
  String get displayName => '$courseTitle ($courseCode)';
}