import 'dart:async';

class Product {
  int id;
  String name;
  double price;

  Product(this.id, this.name, this.price);

  @override
  String toString() {
    return 'Product number $id: name: $name; price $price';
  }
}

class ProductRepository {
  final StreamController<Product> _controller =
      StreamController<Product>.broadcast();

  Future<List<Product>> getAll() async {
    return [
      Product(1, 'Banana', 1234.0),
      Product(2, 'Apple', 36.7),
      Product(3, 'Kiwi', 21.8),
    ];
  }

  Stream<Product> liveAdded() {
    return _controller.stream;
  }

  void addProduct(Product product) {
    _controller.add(product);
  }
}

Future<void> exercise1() async {
  final repository = ProductRepository();

  final addNotify = repository.liveAdded().listen(
    (product) => print('New product added is: $product'),
  );

  final products = await repository.getAll();
  print('===== exercise 1: ======');
  for (final product in products) {
    print(product);
  }

  repository.addProduct(Product(4, 'Blueberry', 69.0));
  repository.addProduct(Product(5, 'Strawberry', 96.0));
  // Delay for loading stream.
  await Future.delayed(const Duration(milliseconds: 100));
}
