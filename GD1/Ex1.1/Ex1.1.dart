import 'Vehicle.dart';
void ex1Runner() {
  print('========== EX1.1 ==========');
  Car car = Car('Mercedes-Benz', 2077, false);
  car.startEngine();
  Car carTesla = Car.tesla(2026);
  carTesla.startEngine();
}