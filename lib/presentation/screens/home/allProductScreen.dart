import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/product_cubit/product_cubit.dart';
import 'package:ecommerce_app/logic/cubits/product_cubit/product_state.dart';
import 'package:ecommerce_app/logic/services/formatter.dart';
import 'package:ecommerce_app/presentation/screens/product/product_details_screen.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/CustomDecoration.dart';
import '../../widgets/product_ListView.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({Key? key}) : super(key: key);

  static const routeName = "all_productScreen";

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("All Product"),
            actions: [
              IconButton(
                  onPressed: (){

                  },
                  icon: const Icon(Icons.search))
            ],
            backgroundColor: AppColors.appBarColors,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
        if (state is ProductLoadingState && state.products.isEmpty) {
          return  Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is ProductErrorState && state.products.isEmpty) {
          return Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: Center(
              child: Text(state.message),
            ),
          );
        }
        return ProductListView(products: state.products);
      }),
    );
  }
}
