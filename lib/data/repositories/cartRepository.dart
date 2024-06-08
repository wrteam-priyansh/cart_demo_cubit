import 'package:cart_demo/data/models/cartItem.dart';

class CartRepository {
  Future<List<CartItem>> getCartItems() async {
    await Future.delayed(const Duration(seconds: 1));
    return List<CartItem>.from([]);
  }

  Future<void> addToCart() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> removeFromCart() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
