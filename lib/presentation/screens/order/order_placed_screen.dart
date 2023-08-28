import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/CustomDecoration.dart';

class OrderPlacedScreen extends StatefulWidget {
  const OrderPlacedScreen({Key? key}) : super(key: key);

  static const routeName = "order_placed";

  @override
  State<OrderPlacedScreen> createState() => _OrderPlacedScreenState();
}

class _OrderPlacedScreenState extends State<OrderPlacedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("Order Placed"),
            backgroundColor: AppColors.appBarColors,
            shape:  const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(25),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: CustomDecoration.setGradientBackgroundDecoration(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.cube_box_fill,
                  color: AppColors.accent,
                  size: 100,
                ),
                GapWidget(),
                Text(
                  "Order Placed",
                  style: TextStyles.heading3.copyWith(color: AppColors.textLight),
                ),
                GapWidget(
                  size: -5,
                ),
                Text(
                  "You can check out thr status by going to profile > My Orders",
                  style: TextStyles.body2.copyWith(color: Colors.black),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
