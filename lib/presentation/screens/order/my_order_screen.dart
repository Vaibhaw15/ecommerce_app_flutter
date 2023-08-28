import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/logic/cubits/order_cubit/order_cubit.dart';
import 'package:ecommerce_app/logic/cubits/order_cubit/order_state.dart';
import 'package:ecommerce_app/logic/services/formatter.dart';
import 'package:ecommerce_app/presentation/widgets/gao_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui.dart';
import '../../../logic/services/calculation.dart';
import '../../../utils/CustomDecoration.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({Key? key}) : super(key: key);
  static const routeName = "my_orders";

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

// class _MyOrderScreenState extends State<MyOrderScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Orders"),
//       ),
//       body: SafeArea(
//         child: BlocBuilder<OrderCubit, OrderState>(
//           builder: (context, state) {
//             if (state is OrderLoadingState && state.orders.isEmpty) {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//             if (state is OrderErrorState && state.orders.isEmpty) {
//               return Center(
//                 child: Text(state.message),
//               );
//             }
//
//             return ListView.builder(
//               padding: EdgeInsets.all(16),
//               itemCount: state.orders.length,
//               itemBuilder: (context, index) {
//                 final order = state.orders[index];
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("# - ${order.sId}"),
//                     Text(
//                         "Order placed on: ${Formatter.formatDate(DateTime.parse(order.createdOn!))}"),
//
//
//                     GapWidget(),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

class _MyOrderScreenState extends State<MyOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: Container(
          decoration: CustomDecoration.setGradientBackgroundDecoration(),
          child: AppBar(
            centerTitle: true,
            title: Text("My Orders"),
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
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {


            if(state is OrderLoadingState && state.orders.isEmpty) {
              return Container(
                decoration: CustomDecoration.setGradientBackgroundDecoration(),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is OrderLoadedState && state.orders.isEmpty) {
              return Container(
                decoration: CustomDecoration.setGradientBackgroundDecoration(),
                child: Center(
                  child: Text(
                    "No Order Placed yet!...",
                    style: TextStyles.body1,
                  ),
                ),
              );
            }

            if(state is OrderErrorState && state.orders.isEmpty) {
              return Container(
                decoration: CustomDecoration.setGradientBackgroundDecoration(),
                child: Center(
                    child: Text(state.message)
                ),
              );
            }

            return Container(
              decoration: CustomDecoration.setGradientBackgroundDecoration(),
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.orders.length,
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                       GapWidget(),
                      Divider(color: Colors.white,thickness: 2,),
                       GapWidget(),
                    ],
                  );
                },
                itemBuilder: (context, index) {

                  final order = state.orders[index];

                  return Container(

                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text("# - ${order.sId}", style: TextStyles.body2.copyWith(color: AppColors.textLight),),
                        Text("${Formatter.formatDate(DateTime.parse(order.createdOn!))}", style: TextStyles.body2.copyWith(color: AppColors.accent),),
                        Text("Order Total: ${Formatter.formatPrice(Calculations.carTotal(order.items!))}", style: TextStyles.body1.copyWith(fontWeight: FontWeight.bold),),

                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: order.items!.length,
                          itemBuilder: (context, index) {

                            final item = order.items![index];
                            final product = item.product!;

                            return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: CachedNetworkImage(
                                  imageUrl: product.images![0],
                                ),
                                title: Text("${product.title}"),
                                subtitle: Text("Qty: ${item.quantity}"),
                                trailing: Text(Formatter.formatPrice(product.price! * item.quantity!))
                            );

                          },
                        ),

                        Text("Status: ${order.status}"),

                      ],
                    ),
                  );

                },
              ),
            );

          },
        ),
      ),
    );
  }
}
