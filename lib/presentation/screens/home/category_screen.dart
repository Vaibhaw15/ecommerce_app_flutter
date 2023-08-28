import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/category_cubit/category_cubit.dart';
import 'package:ecommerce_app/logic/cubits/category_cubit/category_state.dart';
import 'package:ecommerce_app/presentation/screens/product/category_product_screen.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/CustomDecoration.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(builder: (context, state) {
      if(state is CategoryLoadingState && state.categories.isEmpty){
        return  Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      if(state is CategoryErrorState && state.categories.isEmpty){
        return Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: Center(
            child: Text(state.message.toString()),
          ),
        );
      }


      // return Container(
      //    decoration: CustomDecoration.setGradientBackgroundDecoration(),
      //   child: ListView.builder(
      //       itemCount: state.categories.length,
      //       itemBuilder: (context, index) {
      //         final category = state.categories[index];
      //         return ListTile(
      //           onTap: () {
      //             Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments: category);
      //           },
      //           leading: const Icon((Icons.category)),
      //           title: Text("${category.title}"),
      //           trailing: const Icon(Icons.keyboard_arrow_right),
      //         );
      //       }),
      // );

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: CustomDecoration.setGradientBackgroundDecoration(),
        child: GridView.builder(
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final category = state.categories[index];
            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, CategoryProductScreen.routeName,arguments: category);
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(width: 0.5, color: Colors.blue)
                ),
              //  leading: const Icon((Icons.category)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: Image.network(category.image!,
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.width * 0.33,
                      ),
                    ),
                    GapWidget(size: -15,),
                    Text("${category.title}",style: TextStyles.body1,),
                  ],
                ),
            //Text("${category.title}"),
              //  trailing: const Icon(Icons.keyboard_arrow_right),
              ),
            );
          }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),),
      );
    });
  }
}
