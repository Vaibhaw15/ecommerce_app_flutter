import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/product_cubit/product_cubit.dart';
import 'package:ecommerce_app/logic/cubits/product_cubit/product_state.dart';
import 'package:ecommerce_app/logic/services/formatter.dart';
import 'package:ecommerce_app/presentation/screens/home/allProductScreen.dart';
import 'package:ecommerce_app/presentation/screens/product/product_details_screen.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/CustomDecoration.dart';
import '../../widgets/product_ListView.dart';
import '../auth/notification_service.dart';

class UserFeedScreen extends StatefulWidget {
  const UserFeedScreen({Key? key}) : super(key: key);

  @override
  State<UserFeedScreen> createState() => _UserFeedScreenState();
}

class _UserFeedScreenState extends State<UserFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductCubit, ProductState>(builder: (context, state) {
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
    //  return ProductListView(products: state.products);
      return SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 250,
              padding: EdgeInsets.all(3),
              child: CarouselSlider.builder(
                itemCount: state.products.length ?? 0,
                itemBuilder:
                    (BuildContext context, int index, int realIndex) {
                      String url = state.products[index].images![0];
                  return CachedNetworkImage(
                    // width: 300,
                    imageUrl: url,
                    fit: BoxFit.scaleDown,
                    //  height: 32,
                  );
                },
                options:  CarouselOptions(
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 10 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1.0,
                    onPageChanged: (index, reason) {
                      // setState(() {
                      //   current = index;
                      // });
                    }),),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap:()async{
                      Navigator.pushNamed(context, AllProductScreen.routeName);
                    },
                      child: Text("See All product>",style: TextStyles.body1.copyWith(color: Colors.blue,fontWeight: FontWeight.bold),textDirection: TextDirection.ltr,)),
                ],
              ),
            ),
            GapWidget(size: -15,),
            GridView.builder(
              // scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                itemCount: 9,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: BorderSide(width: 0.5, color: Colors.blue)
                      ),
                      child: CupertinoButton(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, ProductDetailsScreen.routeName,
                              arguments: product);
                        },
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              height :MediaQuery.of(context).size.height *0.07,
                              width: MediaQuery.of(context).size.width / 3,
                              imageUrl: "${product.images?[0]}",
                            ),
                            GapWidget(size: -15,),
                            Flexible(
                               child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${product.title}",
                                    style: TextStyles.body1
                                        .copyWith(fontWeight: FontWeight.bold,fontSize: 15),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Text(
                                  //   "${product.description}",
                                  //   style: TextStyles.body1.copyWith(color: AppColors.text),
                                  //   maxLines: 2,
                                  //   overflow: TextOverflow.ellipsis,
                                  // ),
                               //  GapWidget(size: 15,),
                                  Text(
                                    "${Formatter.formatPrice(product.price!)}",
                                    style: TextStyles.heading3.copyWith(fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),),
          ],
        ),
      );
    });
  }
}
