import 'package:cart_demo/data/repositories/cartRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RemoveProductFromCartState {}

class RemoveProductFromCartInitial extends RemoveProductFromCartState {}

class RemoveProductFromCartInProgress extends RemoveProductFromCartState {}

class RemoveProductFromCartSuccess extends RemoveProductFromCartState {
  final int cartItemId;

  RemoveProductFromCartSuccess({required this.cartItemId});
}

class RemoveProductFromCartFailure extends RemoveProductFromCartState {
  final String errorMessage;

  RemoveProductFromCartFailure(this.errorMessage);
}

class RemoveProductFromCartCubit extends Cubit<RemoveProductFromCartState> {
  final CartRepository _cartRepository = CartRepository();

  RemoveProductFromCartCubit() : super(RemoveProductFromCartInitial());

  Future<void> removeFromCart({required int cartItemId}) async {
    emit(RemoveProductFromCartInProgress());
    try {
      await _cartRepository.removeFromCart();
      emit(RemoveProductFromCartSuccess(cartItemId: cartItemId));
    } catch (e) {
      emit(RemoveProductFromCartFailure(e.toString()));
    }
  }
}
