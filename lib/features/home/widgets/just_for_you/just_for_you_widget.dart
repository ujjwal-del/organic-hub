import 'package:flutter/material.dart';
// CORRECTED import path below
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
// CORRECTED import path below
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';


class JustForYouView extends StatelessWidget {
  final List<Product>? productList;
  const JustForYouView({super.key, required this.productList});

  @override
  Widget build(BuildContext context) {
    if (productList == null || productList!.isEmpty) {
      return const SizedBox.shrink();
    }

    // The Expanded widget will make sure this list fills the parent's height (340px)
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: productList!.length,
        itemBuilder: (BuildContext context, int index) {
          // We set a reasonable width for each card
          return SizedBox(
            width: 190,
            child: Padding(
              padding: EdgeInsets.only(left: index == 0 ? 16 : 0, right: 16),
              // We are now using our flexible and error-free 'ProductWidget'
              child: ProductWidget(productModel: productList![index]),
            ),
          );
        },
      ),
    );
  }
}