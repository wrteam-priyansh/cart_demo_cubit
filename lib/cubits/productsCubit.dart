import 'package:cart_demo/data/models/product.dart';
import 'package:cart_demo/data/repositories/productRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ProductsState {}

class ProductsInitial extends ProductsState {}

class ProductsFetchInProgress extends ProductsState {}

class ProductsFetchSuccess extends ProductsState {
  final List<Product> products;

  ProductsFetchSuccess({required this.products});
}

class ProductsFetchFailure extends ProductsState {
  final String errorMessage;

  ProductsFetchFailure(this.errorMessage);
}

class ProductsCubit extends Cubit<ProductsState> {
  final ProductRepository _productRepository = ProductRepository();

  ProductsCubit() : super(ProductsInitial());

  Future<void> fetchProducts() async {
    emit(ProductsFetchInProgress());
    try {
      final products = await _productRepository.getProducts();
      emit(ProductsFetchSuccess(products: products));
    } catch (e) {
      emit(ProductsFetchFailure(e.toString()));
    }
  }
}
