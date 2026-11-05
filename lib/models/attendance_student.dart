
class AttendanceStudent {
  final String classKey;   
  final String registrationNumber;
  final String studentName;
  String status;              

  AttendanceStudent({
    required this.classKey,
    required this.registrationNumber,
    required this.studentName,
    this.status = 'P', 
  });
}