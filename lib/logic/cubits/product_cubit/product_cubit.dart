import 'package:ecommerce_app/data/repositories/product_reposetory.dart';
import 'package:ecommerce_app/logic/cubits/product_cubit/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/product/product_model.dart';

class ProductCubit extends Cubit<ProductState>{
  ProductCubit():super(ProductInitialState()){
    _initialize();
  }

  final _productRepository = ProductRepository();
  List<ProductModel> products =[];
  List<ProductModel> productsSearch =[];


  void searchProduct(String search) async{
    emit(ProductLoadingState(productsSearch));
    try{
     for (var element in products) {
       if(element.title.toString().toLowerCase().contains(search)){
         productsSearch.add(element);
       }
     }
      emit(ProductLoadedState(productsSearch));

    }catch(ex){
      emit(ProductErrorState(productsSearch, ex.toString()));
    }
  }

  void _initialize() async{
    emit(ProductLoadingState(state.products));
    try{
      products = await _productRepository.fetchAllProduct();
      emit(ProductLoadedState(products));

    }catch(ex){
      emit(ProductErrorState(state.products, ex.toString()));
    }
  }
}