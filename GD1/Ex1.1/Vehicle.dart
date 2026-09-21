class Vehicle {
  String brand;
  int year;

  Vehicle(this.brand, this.year);

  void startEngine() {
    print('Khởi động phương tiện');
  }
}

class Car extends Vehicle {
  bool isElectric;
  Car(String brand, int year, this.isElectric) : super(brand, year);
  Car.tesla(int year) : isElectric = true, super('Tesla', year);

  @override
  void startEngine() {
    isElectric
        ? print('xe điện hãng $brand ($year) năng lượng xanh không ồn')
        : print('Xe xăng hãng $brand ($year) khởi động bùng nổ...}');
  }
}

