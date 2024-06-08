import 'package:cart_demo/data/models/product.dart';

class ProductRepository {
  Future<List<Product>> getProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Product(
        id: 1,
        name: 'iPhone Pro Max',
        imageUrl:
            'https://images.pexels.com/photos/126419/pexels-photo-126419.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        price: 1299.99,
      ),
      Product(
        id: 2,
        name: 'iPhone 12 Pro',
        imageUrl:
            'https://images.pexels.com/photos/126419/pexels-photo-126419.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        price: 1299.99,
      ),
      Product(
        id: 3,
        name: 'iPhone 2 Pro Max',
        imageUrl:
            'https://images.pexels.com/photos/126419/pexels-photo-126419.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        price: 129.99,
      ),
      Product(
        id: 4,
        name: 'iPhone 69 Pro',
        imageUrl:
            'https://images.pexels.com/photos/126419/pexels-photo-126419.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        price: 129.99,
      ),
      Product(
        id: 5,
        name: 'iPhone 9 Pro Max',
        imageUrl:
            'https://images.pexels.com/photos/126419/pexels-photo-126419.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
        price: 1299.99,
      ),
    ];
  }
}
