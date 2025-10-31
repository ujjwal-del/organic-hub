import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:shimmer/shimmer.dart';

class FeaturedProductShimmer extends StatelessWidget {
  const FeaturedProductShimmer({super.key, });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      child: Column(children: [
        Padding(padding: const EdgeInsets.symmetric(horizontal: 50, vertical: Dimensions.paddingSizeSmall),
          child: Container(height: 10,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),
                boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
                color: ColorResources.iconBg()),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).cardColor,
              highlightColor: Colors.grey[300]!,
              enabled: true,
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                Container(height: 10, padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    decoration:  BoxDecoration(color: ColorResources.iconBg(),
                        borderRadius: BorderRadius.circular(2)))
              ]),
            ),
          ),
        ),

        Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
          child: Swiper(
            itemCount: 2,
            autoplay: true,
            autoplayDelay: 3000,
            itemBuilder: (context, index) {

              return SizedBox(height: 500,
                child: Container(margin: const EdgeInsets.all(5),
                  width: 300,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                      color: ColorResources.white,
                      boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
                  child: Shimmer.fromColors(baseColor: Theme.of(context).cardColor,
                    highlightColor: Colors.grey[100]!,
                    enabled: true,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                      Container(height: 150,
                          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                          decoration: BoxDecoration(color: ColorResources.iconBg(),
                              borderRadius: BorderRadius.circular(10))),

                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Container(height: 10, width: 50, color: ColorResources.white),
                                const Icon(Icons.star, color: Colors.orange, size: 15),
                              ]),
                              const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                              Container(height: Dimensions.paddingSizeLarge, color: Theme.of(context).cardColor),
                              const SizedBox(height: Dimensions.paddingSizeEight),
                              Padding(padding: const EdgeInsets.symmetric(horizontal: 50),
                                child: Container(height: Dimensions.paddingSizeLarge, color: Theme.of(context).cardColor))]),
                      ),
                    ]),
                  ),
                ),
              );
            },
          ),
        ),
      ],
      ),
    );
  }
}

