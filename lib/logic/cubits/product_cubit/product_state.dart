import 'package:ecommerce_app/data/models/product/product_model.dart';

abstract class ProductState{
  final List<ProductModel> products;
  ProductState(this.products);
}


class ProductInitialState extends ProductState {
  ProductInitialState() : super([]);
}

class ProductLoadingState extends ProductState {
  ProductLoadingState(List<ProductModel> products) : super(products);
}
class ProductLoadedState extends ProductState {
  ProductLoadedState(List<ProductModel> products) : super(products);
}

class ProductErrorState extends ProductState {
  final String message;
  ProductErrorState(List<ProductModel> products, this.message)
      : super(products);
}