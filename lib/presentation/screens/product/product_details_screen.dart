import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/data/models/product/product_model.dart';
import 'package:ecommerce_app/logic/services/formatter.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:ecommerce_app/presentation/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../logic/cubits/cart_cubit/cart_cubit.dart';
import '../../../logic/cubits/cart_cubit/cart_state.dart';
import '../../../utils/CustomDecoration.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  const ProductDetailsScreen({Key? key, required this.productModel})
      : super(key: key);

  static const routeName = "product_details";

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("${widget.productModel.title}"),
      // ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("${widget.productModel.title}"),
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
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: ListView(
            children: [
              Container(
                height: MediaQuery.of(context).size.width,
                child: CarouselSlider.builder(
                    itemCount: widget.productModel.images?.length ?? 0,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      String url = widget.productModel.images![index];
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
              GapWidget(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${widget.productModel.title}",
                      style: TextStyles.heading3,
                    ),
                    Text(
                      Formatter.formatPrice(widget.productModel.price!),
                      style: TextStyles.heading2,
                    ),
                    GapWidget(
                      size: 10,
                    ),
                    BlocBuilder<CartCubit, CartState>(builder: (context, state) {
                      return PrimaryButton(
                          color: (BlocProvider.of<CartCubit>(context)
                                  .cartContains(widget.productModel))
                              ? AppColors.text
                              : AppColors.accent,
                          text: (BlocProvider.of<CartCubit>(context)
                                  .cartContains(widget.productModel))
                              ? "Added to Cart"
                              : "Add to Cart",
                          onPressed: () {
                            if (BlocProvider.of<CartCubit>(context)
                                .cartContains(widget.productModel)) {
                              return;
                            }

                            BlocProvider.of<CartCubit>(context)
                                .addToCart(widget.productModel, 1);
                            Fluttertoast.showToast(
                                msg: "Added to Cart",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          });
                    }),
                    GapWidget(
                      size: 10,
                    ),
                    Text(
                      "Description",
                      style:
                          TextStyles.body1.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${widget.productModel.description}",
                      style: TextStyles.body1,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
