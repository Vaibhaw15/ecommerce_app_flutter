import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/data/models/product/product_model.dart';
import 'package:ecommerce_app/utils/CustomDecoration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/ui.dart';
import '../../logic/services/formatter.dart';
import '../screens/product/product_details_screen.dart';
import 'gao_widget.dart';

class ProductListView extends StatelessWidget {
  final List<ProductModel> products;
  ProductListView({required this.products});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: CustomDecoration.setGradientBackgroundDecoration(),
      child: ListView.builder(
          // scrollDirection: Axis.vertical,
           shrinkWrap: true,
        padding: const EdgeInsets.all(8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
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
                  child: Row(
                    children: [
                      CachedNetworkImage(
                        width: MediaQuery.of(context).size.width / 3,
                        imageUrl: "${product.images?[0]}",
                      ),
                      GapWidget(),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${product.title}",
                              style: TextStyles.body1
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              "${product.description}",
                              style: TextStyles.body1.copyWith(color: AppColors.text),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            GapWidget(),
                            Text(
                              "${Formatter.formatPrice(product.price!)}",
                              style: TextStyles.heading3,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
    ;
  }
}
