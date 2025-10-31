import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_shimmer_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FeaturedProductWidget extends StatelessWidget {
  final ScrollController? scrollController;
  final bool isHome;

  const FeaturedProductWidget({super.key,  this.scrollController, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList;
        productList = prodProvider.featuredProductList;
        return Column(children: [

          productList != null? productList.isNotEmpty ?
          // ======== THE ONLY CHANGE IS ADDING 'EXPANDED' HERE ========
          Expanded(
            child: isHome? Padding(
              padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 180,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: ProductWidget(productModel: productList![index]),
                    ),
                  );
                },
              ),
            ) :
            MasonryGridView.count(
              itemCount: productList.length,
              crossAxisCount: ResponsiveHelper.isTab(context)? 3 : 2,
              padding: const EdgeInsets.all(0),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) => ProductWidget(productModel: productList![index]),
            ),
          ): const SizedBox.shrink() : ProductShimmer(isHomePage: true ,isEnabled: prodProvider.firstFeaturedLoading),

          prodProvider.isFeaturedLoading ? Center(child: Padding(
            padding: const EdgeInsets.all(Dimensions.iconSizeExtraSmall),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) : const SizedBox.shrink()]);
      },
    );
  }
}