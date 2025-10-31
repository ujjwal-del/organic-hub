import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/find_what_you_need_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/featured_deal_card_widget.dart';
import 'package:provider/provider.dart';


class FeaturedDealsListWidget extends StatelessWidget {
  final bool isHomePage;
  const FeaturedDealsListWidget({super.key, this.isHomePage = true});

  @override
  Widget build(BuildContext context) {

    return isHomePage?
    Consumer<FeaturedDealController>(
      builder: (context, featuredDealProvider, child) {
        return featuredDealProvider.featuredDealProductList != null? featuredDealProvider.featuredDealProductList!.isNotEmpty ?
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: featuredDealProvider.featuredDealProductList?.length ?? 0,
            itemBuilder: (context, index) {
              return Container(
                width: 300,
                margin: const EdgeInsets.only(right: 16),
                child: FeaturedDealWidget(isHomePage: isHomePage,product: featuredDealProvider.featuredDealProductList![index]),
              );
            },
          ),
        ) : const SizedBox() :const FindWhatYouNeedShimmer();
      }):

    Consumer<FeaturedDealController>(
      builder: (context, featuredDealProvider, _) {
        return ListView.builder(
            padding: const EdgeInsets.all(0),
            scrollDirection: Axis.vertical,
            itemCount: featuredDealProvider.featuredDealProductList?.length,
            itemBuilder: (context, index) {
              return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: FeaturedDealWidget(isHomePage: isHomePage,product: featuredDealProvider.featuredDealProductList![index]));
            });
      }
    );
  }
}


