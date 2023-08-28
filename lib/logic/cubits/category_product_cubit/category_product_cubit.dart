import 'package:ecommerce_app/data/repositories/product_reposetory.dart';
import 'package:ecommerce_app/logic/cubits/category_product_cubit/category_product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/category/category_model.dart';

class CategoryProductCubit extends Cubit<CategoryProductState> {
  final CategoryModel category;
  CategoryProductCubit(this.category) : super(CategoryProductInitialState()) {
    _initialize();
  }

  final _productRepository = ProductRepository();
  void _initialize() async {
    try {
      final products =
          await _productRepository.fetchProductByCategory(category.sId!);
      emit(CategoryProductLoadedState(products));
    } catch (ex) {
      emit(CategoryProductErrorState(state.products, ex.toString()));
    }
  }
}
