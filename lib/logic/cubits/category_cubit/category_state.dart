import 'package:ecommerce_app/data/models/category/category_model.dart';

abstract class CategoryState {
  final List<CategoryModel> categories;
  CategoryState(this.categories);
}

class CategoryInitialState extends CategoryState {
  CategoryInitialState() : super([]);
}

class CategoryLoadingState extends CategoryState {
  CategoryLoadingState(List<CategoryModel> categories) : super(categories);
}
class CategoryLoadedState extends CategoryState {
  CategoryLoadedState(List<CategoryModel> categories) : super(categories);
}

class CategoryErrorState extends CategoryState {
  final String message;
  CategoryErrorState(List<CategoryModel> categories, this.message)
      : super(categories);
}
