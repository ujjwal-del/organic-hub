import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product/latest_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/latest_product_shimmer.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

class LatestProductListWidget extends StatefulWidget {
  const LatestProductListWidget({super.key});

  @override
  State<LatestProductListWidget> createState() => _LatestProductListWidgetState();
}

class _LatestProductListWidgetState extends State<LatestProductListWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToNext(List<Product>? productList) {
    if (productList != null && _currentIndex < productList.length - 1) {
      _currentIndex++;
      final itemWidth = MediaQuery.of(context).size.width * 0.75 + 16; // width + margin
      _scrollController.animateTo(
        _currentIndex * itemWidth,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductController>(
      builder: (context, prodProvider, child) {
        List<Product>? productList = prodProvider.lProductList;

        return productList != null && productList.isNotEmpty
            ? Column(
          children: [
            TitleRowWidget(
              title: getTranslated('latest_products', context),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                  AllProductScreen(productType: ProductType.latestProduct))),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),

            Expanded(
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width * .75,
                        margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0),
                        child: LatestProductWidget(productModel: productList[index]),
                      );
                    },
                  ),

                  // Functional scroll button
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => _scrollToNext(productList),
                          child: Container(
                            height: 30, width: 30,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: GradientBoxBorder(
                                gradient: LinearGradient(colors: [Theme.of(context).colorScheme.background, Theme.of(context).colorScheme.onPrimary]),
                                width: 2,
                              ),
                            ),
                            child: Icon(Icons.arrow_forward_ios, size: 15, color: Theme.of(context).colorScheme.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
            : const LatestProductShimmer();
      },
    );
  }
}