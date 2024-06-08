import 'package:cart_demo/cubits/cartCubit.dart';
import 'package:cart_demo/cubits/manageProductInCartCubit.dart';
import 'package:cart_demo/cubits/removeProductFromCartCubit.dart';
import 'package:cart_demo/data/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  Widget _buildCheckoutButton() {
    return context.read<CartCubit>().isCartEmpty()
        ? const SizedBox()
        : Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              color: Theme.of(context).colorScheme.primary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Checkout Rs.(${context.read<CartCubit>().totalPrice().toStringAsFixed(2)})",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            if (state is CartFetchSuccess) {
              return Stack(
                children: [
                  ListView.builder(
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => RemoveProductFromCartCubit(),
                          ),
                          BlocProvider(
                            create: (context) => ManageProductInCartCubit(),
                          ),
                        ],
                        child: Builder(builder: (context) {
                          return BlocConsumer<RemoveProductFromCartCubit,
                              RemoveProductFromCartState>(
                            listener: (context, removeProductFromCartState) {
                              if (removeProductFromCartState
                                  is RemoveProductFromCartSuccess) {
                                context.read<CartCubit>().removeFromCart(
                                    cartItemId:
                                        removeProductFromCartState.cartItemId);
                              }
                            },
                            builder: (context, removeProductFromCartState) {
                              return Opacity(
                                opacity: removeProductFromCartState
                                        is RemoveProductFromCartInProgress
                                    ? 0.5
                                    : 1.0,
                                child: BlocConsumer<ManageProductInCartCubit,
                                    ManageProductInCartState>(
                                  listener:
                                      (context, manageProductInCartState) {
                                    if (manageProductInCartState
                                        is ManageProductInCartSuccess) {
                                      if (manageProductInCartState
                                          .isAddedToCart) {
                                        ///[Add product in cartcubit]
                                        context.read<CartCubit>().addToCart(
                                            manageProductInCartState.product);
                                      }

                                      ///[Decrease the quantity of the product in cartCubit]
                                      else {
                                        context
                                            .read<CartCubit>()
                                            .decreaseQuantityOfCartItem(
                                                manageProductInCartState
                                                    .product.id);
                                      }
                                    }
                                  },
                                  builder: (context, manageProductInCartState) {
                                    return Card(
                                      child: ListTile(
                                        title: Text(cartItem.name),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Rs.${cartItem.price.toString()}"),
                                            const Divider(),
                                            Text(
                                                "${cartItem.quantity} x Rs.${cartItem.price.toStringAsFixed(2)} : Rs.${(cartItem.quantity * cartItem.price).toStringAsFixed(2)}"),
                                            const Divider(),
                                            TextButton(
                                                onPressed: () {
                                                  if (removeProductFromCartState
                                                      is RemoveProductFromCartInProgress) {
                                                    return;
                                                  }
                                                  if (manageProductInCartState
                                                      is ManageProductInCartInProgress) {
                                                    return;
                                                  }
                                                  context
                                                      .read<
                                                          RemoveProductFromCartCubit>()
                                                      .removeFromCart(
                                                          cartItemId:
                                                              cartItem.id);
                                                },
                                                child:
                                                    Text("Remove from cart")),
                                          ],
                                        ),

                                        ///[Manage cart item button]
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  if (manageProductInCartState
                                                          is ManageProductInCartInProgress ||
                                                      removeProductFromCartState
                                                          is RemoveProductFromCartInProgress) {
                                                    return;
                                                  }

                                                  ///[Decrease the quantity of the product]
                                                  context
                                                      .read<
                                                          ManageProductInCartCubit>()
                                                      .decreaseQuantityOfCartItem(
                                                          Product(
                                                              id: cartItem
                                                                  .productId,
                                                              name:
                                                                  cartItem.name,
                                                              imageUrl: cartItem
                                                                  .imageUrl,
                                                              price: cartItem
                                                                  .price));
                                                },
                                                icon: const Icon(Icons
                                                    .remove_circle_outline)),
                                            manageProductInCartState
                                                    is ManageProductInCartInProgress
                                                ? SizedBox(
                                                    height: 20,
                                                    width: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10.0),
                                                    child: Text(
                                                      cartItem.quantity
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 20.0),
                                                    ),
                                                  ),
                                            IconButton(
                                                onPressed: () {
                                                  if (manageProductInCartState
                                                          is ManageProductInCartInProgress ||
                                                      removeProductFromCartState
                                                          is RemoveProductFromCartInProgress) {
                                                    return;
                                                  }

                                                  context
                                                      .read<
                                                          ManageProductInCartCubit>()
                                                      .addToCart(Product(
                                                          id: cartItem
                                                              .productId,
                                                          name: cartItem.name,
                                                          imageUrl:
                                                              cartItem.imageUrl,
                                                          price:
                                                              cartItem.price));
                                                },
                                                icon: const Icon(
                                                    Icons.add_circle_outline)),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        }),
                      );
                    },
                  ),
                  _buildCheckoutButton()
                ],
              );
            }
            if (state is CartFetchFailure) {
              return Center(
                child: Text(state.errorMessage),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
