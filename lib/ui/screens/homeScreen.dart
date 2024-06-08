import 'package:cart_demo/cubits/cartCubit.dart';
import 'package:cart_demo/cubits/manageProductInCartCubit.dart';
import 'package:cart_demo/cubits/productsCubit.dart';
import 'package:cart_demo/ui/screens/cartScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      context.read<ProductsCubit>().fetchProducts();
      context.read<CartCubit>().fetchCartItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => const CartScreen()));
              },
              icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          if (state is ProductsFetchInProgress || state is ProductsInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ProductsFetchSuccess) {
            return ListView.builder(
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                return BlocProvider(
                  create: (context) => ManageProductInCartCubit(),
                  child: Card(
                    child: ListTile(
                      title: Text(state.products[index].name),
                      subtitle:
                          Text("Rs.${state.products[index].price.toString()}"),

                      ///[Add to cart button]
                      trailing: BlocConsumer<ManageProductInCartCubit,
                          ManageProductInCartState>(
                        listener: (context, manageProductInCartState) {
                          if (manageProductInCartState
                              is ManageProductInCartSuccess) {
                            context
                                .read<CartCubit>()
                                .addToCart(manageProductInCartState.product);
                          }
                        },
                        builder: (context, manageProductInCartState) {
                          return manageProductInCartState
                                  is ManageProductInCartInProgress
                              ? SizedBox(
                                  height: 15,
                                  width: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                  ))
                              : TextButton(
                                  onPressed: () {
                                    context
                                        .read<ManageProductInCartCubit>()
                                        .addToCart(state.products[index]);
                                  },
                                  child: Text("Add to Cart"));
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
          if (state is ProductsFetchFailure) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
