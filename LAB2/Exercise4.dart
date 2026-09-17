class Car {
  String brand;

  Car(this.brand);
  Car.defaultCar() : brand = 'Tesla';
  void used(){
    print('$brand car is used');
  }
}

class ElectricCar extends Car {
  int batteryLevel;

  ElectricCar(String brand, this.batteryLevel) : super(brand);

  @override
  void used() {
    print(
      '$brand electric car is used with $batteryLevel% battery.',
    );
  }
}

void exercise4() {
  print('============ Exercise 4 ============');
  Car car1 = Car('Toyota');
  car1.used();
  Car car2 = Car.defaultCar();
  car2.used();

  ElectricCar electricCar = ElectricCar('Tesla', 90);
  electricCar.used();

  print('');
}