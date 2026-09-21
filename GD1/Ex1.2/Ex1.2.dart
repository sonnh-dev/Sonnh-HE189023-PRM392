import 'Employee.dart';
void ex2Runner() {
  print('========== EX1.2 ==========');
  List<Developer> teamA = [Developer("An"), Developer("Bình")];
  List<Developer> teamB = [Developer("Cường")];

  List<Developer> allStaff = [...teamA, ...teamB];

  allStaff.forEach((staff) => staff.checkIn());
}