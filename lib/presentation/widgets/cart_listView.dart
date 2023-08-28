import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/data/models/cart/cart_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:input_quantity/input_quantity.dart';

import '../../logic/cubits/cart_cubit/cart_cubit.dart';
import '../../logic/services/formatter.dart';
import 'link_button.dart';

class CartListView extends StatelessWidget {
  final List<CartItemModel> items;
  final bool shrinkWrap;
  final bool noScroll;
   CartListView({Key? key,required this.items,this.shrinkWrap = false,this.noScroll = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
        physics: (noScroll) ?NeverScrollableScrollPhysics():null,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all( Radius.circular(10.0))
            ),
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: item.product!.images![0],
              ),
              title: Text("${item.product?.title}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "${Formatter.formatPrice(item.product!.price!)} x ${item.quantity} = ${Formatter.formatPrice(item.product!.price! * item.quantity!)}"),
                  LinkButton(
                    text: "Delete",
                    onPressed: () {
                      BlocProvider.of<CartCubit>(context)
                          .removeFromCart(item.product!);
                    },
                    color: Colors.red,
                  )
                ],
              ),
              trailing: InputQty(
                minVal: 1,
                maxVal: 99,
                initVal: item.quantity!,
                showMessageLimit: false,
                onQtyChanged: (value) {
                  if(value == item.quantity) return;
                  BlocProvider.of<CartCubit>(context)
                      .addToCart(item.product!, value as int);
                },
              ),
            ),
          );
        });
  }
}
