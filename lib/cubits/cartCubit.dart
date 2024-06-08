import 'dart:math';

import 'package:cart_demo/data/models/cartItem.dart';
import 'package:cart_demo/data/models/product.dart';
import 'package:cart_demo/data/repositories/cartRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartFetchInProgress extends CartState {}

class CartFetchSuccess extends CartState {
  final List<CartItem> cartItems;

  CartFetchSuccess(this.cartItems);
}

class CartFetchFailure extends CartState {
  final String errorMessage;

  CartFetchFailure(this.errorMessage);
}

class CartCubit extends Cubit<CartState> {
  final CartRepository _cartRepository = CartRepository();

  CartCubit() : super(CartInitial());

  Future<void> fetchCartItems() async {
    emit(CartFetchInProgress());
    try {
      final cartItems = await _cartRepository.getCartItems();
      emit(CartFetchSuccess(cartItems));
    } catch (e) {
      emit(CartFetchFailure(e.toString()));
    }
  }

  void clearCart() {
    //
  }

  bool isCartEmpty() {
    return (state as CartFetchSuccess).cartItems.isEmpty;
  }

  double totalPrice() {
    return (state as CartFetchSuccess).cartItems.fold(
          0.0,
          (double total, CartItem cartItem) =>
              total + cartItem.price * cartItem.quantity,
        );
  }

  bool isProductInCart(int productId) {
    if (state is CartFetchSuccess) {
      List<CartItem> cartItems = (state as CartFetchSuccess).cartItems;

      return cartItems.any((cartItem) => cartItem.productId == productId);
    }
    return false;
  }

  void addToCart(Product product) {
    if (state is CartFetchSuccess) {
      List<CartItem> cartItems = (state as CartFetchSuccess).cartItems;

      final cartItemIndex = cartItems.indexWhere(
        (cartItem) => cartItem.productId == product.id,
      );

      if (cartItemIndex != -1) {
        ///[Update the quantity of the product in cart if it exists]
        cartItems[cartItemIndex] = cartItems[cartItemIndex].copyWith(
          quantity: cartItems[cartItemIndex].quantity + 1,
        );
      } else {
        cartItems.add(CartItem(
          id: Random().nextInt(1000),
          name: product.name,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
          productId: product.id,
        ));
      }

      emit(CartFetchSuccess(cartItems));
    }
  }

  void decreaseQuantityOfCartItem(int productId) {
    if (state is CartFetchSuccess) {
      List<CartItem> cartItems = (state as CartFetchSuccess).cartItems;

      ///[Decrease the quantity of the product in cart if it exists]
      final cartItemIndex = cartItems.indexWhere(
        (cartItem) => cartItem.productId == productId,
      );

      if (cartItemIndex != -1) {
        if (cartItems[cartItemIndex].quantity > 1) {
          cartItems[cartItemIndex] = cartItems[cartItemIndex].copyWith(
            quantity: cartItems[cartItemIndex].quantity - 1,
          );
        } else {
          cartItems.removeAt(cartItemIndex);
        }
        emit(CartFetchSuccess(cartItems));
      }
    }
  }

  void removeFromCart({required int cartItemId}) {
    if (state is CartFetchSuccess) {
      List<CartItem> cartItems = (state as CartFetchSuccess).cartItems;

      final cartItemIndex = cartItems.indexWhere(
        (cartItem) => cartItem.id == cartItemId,
      );

      if (cartItemIndex != -1) {
        cartItems.removeAt(cartItemIndex);
        emit(CartFetchSuccess(cartItems));
      }
    }
  }
}
