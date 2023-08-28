import '../../../data/models/product/product_model.dart';

abstract class CategoryProductState{
  final List<ProductModel> products;
  CategoryProductState(this.products);
}

class CategoryProductInitialState extends CategoryProductState {
  CategoryProductInitialState() : super([]);
}

class CategoryProductLoadingState extends CategoryProductState {
  CategoryProductLoadingState(List<ProductModel> products) : super(products);
}
class CategoryProductLoadedState extends CategoryProductState {
  CategoryProductLoadedState(List<ProductModel> products) : super(products);
}

class CategoryProductErrorState extends CategoryProductState {
  final String message;
  CategoryProductErrorState(List<ProductModel> products, this.message)
      : super(products);
}
