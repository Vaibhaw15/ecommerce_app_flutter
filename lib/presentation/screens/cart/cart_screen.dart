import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_state.dart';
import 'package:ecommerce_app/logic/services/formatter.dart';
import 'package:ecommerce_app/presentation/screens/order/order_details_screen.dart';
import 'package:ecommerce_app/presentation/widgets/link_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../../logic/services/calculation.dart';
import '../../../utils/CustomDecoration.dart';
import '../../widgets/cart_listView.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  static const routeName = "cart";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: const Text("Cart"),
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
        child: BlocBuilder<CartCubit, CartState>(builder: (context, state) {
          if (state is CartLoadingState && state.items.isEmpty) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CartErrorState && state.items.isEmpty) {
            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: Center(
                child: Text(state.message),
              ),
            );
          }
          if (state is CartLoadedState && state.items.isEmpty) {
            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: Center(
                child: Text(
                  "cart items will show up here...",
                  style: TextStyles.body1,
                ),
              ),
            );
          }

          return Container(
            decoration: CustomDecoration.setGradientBackgroundDecoration(),
            child: Column(
              children: [
                Expanded(
                  child: CartListView(items:state.items),
                ),
                Container(
                  //color: Colors.black,
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0))),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${state.items.length}",
                                style: TextStyles.body1
                                    .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                              ),
                              Text(
                                "Total: ${Formatter.formatPrice(Calculations.carTotal(state.items))}",
                                style: TextStyles.heading3.copyWith(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: CupertinoButton(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 22),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, OrderDetailsScreen.routeName);
                            },
                            color: AppColors.accent,
                            child: const Text("Place Order"),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }
}
