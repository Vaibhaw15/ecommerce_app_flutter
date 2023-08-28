import 'dart:developer';

import 'package:ecommerce_app/core/ui.dart';
import 'package:ecommerce_app/data/models/order/order_model.dart';
import 'package:ecommerce_app/data/models/user/user_model.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_cubit.dart';
import 'package:ecommerce_app/logic/cubits/cart_cubit/cart_state.dart';
import 'package:ecommerce_app/logic/cubits/order_cubit/order_cubit.dart';
import 'package:ecommerce_app/logic/cubits/user_cubit/user_cubit.dart';
import 'package:ecommerce_app/logic/services/razorpay.dart';
import 'package:ecommerce_app/presentation/screens/order/order_placed_screen.dart';
import 'package:ecommerce_app/presentation/screens/order/provider/order_details_provider.dart';
import 'package:ecommerce_app/presentation/screens/user/edit_profile_screen.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:ecommerce_app/presentation/widgets/link_button.dart';
import 'package:ecommerce_app/presentation/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../../logic/cubits/user_cubit/user_state.dart';
import '../../../utils/CustomDecoration.dart';
import '../../widgets/cart_listView.dart';
import '../auth/notification_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({Key? key}) : super(key: key);

  static const routeName = "order_details";

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("New Order"),
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
            padding: EdgeInsets.all(16),
            children: [
              BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                if (state is UserLoadingState) {
                  return const CircularProgressIndicator();
                }
                if (state is UserLoggedInState) {
                  UserModel user = state.userModel;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("User Details",
                          style: TextStyles.body2
                              .copyWith(fontWeight: FontWeight.bold)),
                      GapWidget(),
                      Text(
                        "${user.fullName}",
                        style: TextStyles.heading3,
                      ),
                      Text(
                        "${user.email}",
                        style: TextStyles.body2,
                      ),
                      Text(
                        "${user.phoneNumber}",
                        style: TextStyles.body2,
                      ),
                      Text(
                        "${user.address}",
                        style: TextStyles.body2,
                      ),
                      LinkButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, EditProfileScreen.routeName);
                          },
                          text: "Edit Profile")
                    ],
                  );
                }

                if (state is UserErrorState) {
                  return Text(state.message);
                }
                return SizedBox();
              }),
              GapWidget(
                size: 10,
              ),
              Text("Items",
                  style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold)),
              GapWidget(),
              BlocBuilder<CartCubit, CartState>(builder: (context, state) {
                if (state is CartLoadingState && state.items.isEmpty) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is CartErrorState && state.items.isEmpty) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                return CartListView(
                  items: state.items,
                  shrinkWrap: true,
                  noScroll: true,
                );
              }),
              GapWidget(
                size: 10,
              ),
              Text("Payment",
                  style: TextStyles.body2.copyWith(fontWeight: FontWeight.bold)),
              GapWidget(),
              Consumer<OrderDetailsProvider>(builder: (context, provider, child) {
                return Column(
                  children: [
                    RadioListTile(
                      onChanged: provider.changePaymentMethod,
                      value: "pay-on-delivery",
                      groupValue: provider.paymentMethod,
                      title: Text("Pay on Delivery"),
                      contentPadding: EdgeInsets.zero,
                    ),
                    RadioListTile(
                      onChanged: provider.changePaymentMethod,
                      value: "Pay-now",
                      groupValue: provider.paymentMethod,
                      title: Text("Pay now"),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                );
              }),
              PrimaryButton(
                  onPressed: () async {
                    OrderModel? newOrder =
                        await BlocProvider.of<OrderCubit>(context).createOrder(
                            items:
                                BlocProvider.of<CartCubit>(context).state.items,
                            paymentMethod: Provider.of<OrderDetailsProvider>(
                                    context,
                                    listen: false)
                                .paymentMethod
                                .toString());

                    if (newOrder == null) {
                      return;
                    }
                    if (newOrder.status == "payment-pending") {
                      //payment
                      await RazorPayServices.checkOutOrder(newOrder,
                          onSuccess: (response) async {
                        newOrder.status = "order-placed";
                        bool success = await BlocProvider.of<OrderCubit>(context)
                            .updateOrder(newOrder,
                                paymentId: response.paymentId,
                                signature: response.signature);

                        if (!success) {
                          log("Can't update the order!");
                          return;
                        }

                        Navigator.popUntil(context, (route) => route.isFirst);
                        Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                        Fluttertoast.showToast(
                            msg: "Order Placed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        await  NotificationService().showNotification(title: "Order Status",body: "Order Placed");

                          }, onFailure: (response)async {
                        log("payment Failed");
                        Fluttertoast.showToast(
                            msg: "payment Failed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        await  NotificationService().showNotification(title: "Order Status",body: "Payment Failed");

                          });
                    }

                    if (newOrder.status == "order-placed") {
                      Navigator.popUntil(context, (route) => route.isFirst);
                      Navigator.pushNamed(context, OrderPlacedScreen.routeName);
                      Fluttertoast.showToast(
                          msg: "Order Placed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    await  NotificationService().showNotification(id: 0,title: "Order Status",body: "Order Placed");
                    }
                  },
                  text: "Place Order"),
            ],
          ),
        ),
      ),
    );
  }
}
