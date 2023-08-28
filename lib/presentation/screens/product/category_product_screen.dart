import 'package:ecommerce_app/logic/cubits/category_product_cubit/category_product_cubit.dart';
import 'package:ecommerce_app/logic/cubits/category_product_cubit/category_product_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui.dart';
import '../../../utils/CustomDecoration.dart';
import '../../widgets/product_ListView.dart';

class CategoryProductScreen extends StatefulWidget {
  const CategoryProductScreen({Key? key}) : super(key: key);

  static const routeName = "category_product";

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CategoryProductCubit>(context);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("${cubit.category.title}"),
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("${cubit.category.title}"),
            backgroundColor: AppColors.appBarColors,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
          child: BlocBuilder<CategoryProductCubit, CategoryProductState>(
        builder: (context, state) {
          if (state is CategoryProductLoadingState && state.products.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CategoryProductErrorState && state.products.isEmpty) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is CategoryProductLoadedState && state.products.isEmpty) {
            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: Center(
                child: Text("No Product found!"),
              ),
            );
          }
          return ProductListView(products: state.products);
        },
      )),
    );
  }
}
