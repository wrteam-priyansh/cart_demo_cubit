import 'package:cart_demo/data/models/product.dart';
import 'package:cart_demo/data/repositories/cartRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ManageProductInCartState {}

class ManageProductInCartInitial extends ManageProductInCartState {}

class ManageProductInCartInProgress extends ManageProductInCartState {}

class ManageProductInCartSuccess extends ManageProductInCartState {
  final Product product;
  final bool isAddedToCart;

  ManageProductInCartSuccess(
      {required this.product, required this.isAddedToCart});
}

class ManageProductInCartFailure extends ManageProductInCartState {
  final String errorMessage;

  ManageProductInCartFailure(this.errorMessage);
}

class ManageProductInCartCubit extends Cubit<ManageProductInCartState> {
  final CartRepository _cartRepository = CartRepository();

  ManageProductInCartCubit() : super(ManageProductInCartInitial());

  Future<void> addToCart(Product product) async {
    emit(ManageProductInCartInProgress());
    try {
      await _cartRepository.addToCart();
      emit(ManageProductInCartSuccess(
        isAddedToCart: true,
        product: product,
      ));
    } catch (e) {
      emit(ManageProductInCartFailure(e.toString()));
    }
  }

  Future<void> decreaseQuantityOfCartItem(Product product) async {
    emit(ManageProductInCartInProgress());
    try {
      await _cartRepository.removeFromCart();
      emit(ManageProductInCartSuccess(isAddedToCart: false, product: product));
    } catch (e) {
      emit(ManageProductInCartFailure(e.toString()));
    }
  }
}
