import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/rating_bar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/heartbeat_tea_cup_animation.dart';

class LatestProductWidget extends StatelessWidget {
  final Product productModel;
  const LatestProductWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    String ratting = productModel.rating != null && productModel.rating!.isNotEmpty ? productModel.rating![0].average! : "0";
    var splashController = Provider.of<SplashController>(context, listen: false);

    return InkWell(
      onTap: () async {
        final overlayState = Overlay.of(context);
        final animationKey = GlobalKey<HeartbeatTeaCupAnimationState>();
        final entry = OverlayEntry(builder: (_) => HeartbeatTeaCupAnimation(key: animationKey));
        overlayState.insert(entry);
        await Future.delayed(const Duration(milliseconds: 60));
        Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 650),
          pageBuilder: (context, anim1, anim2) => ProductDetails(productId: productModel.id, slug: productModel.slug),
        ));
        await Future.delayed(const Duration(milliseconds: 180));
        if(entry.mounted){
          animationKey.currentState?.startFadeOut((){ if(entry.mounted) entry.remove(); });
        }
      },
      child: AspectRatio(
        // We enforce a consistent shape for the card
        aspectRatio: 0.9 / 1.2,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).cardColor,
            boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), spreadRadius: 1, blurRadius: 1, offset: const Offset(0, 1))],
          ),
          child: Stack(
            children: [
              // Main layout is now a Column for flexibility
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // The image is wrapped in Expanded to fill available space
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: CustomImageWidget(
                        image: '${splashController.baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // The product details are now directly in the Column
                  Container(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Theme.of(context).highlightColor,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(color: Theme.of(context).hintColor.withOpacity(.125)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RatingBar(rating: double.parse(ratting), size: 18),
                            Text('(${productModel.reviewCount.toString()})', style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                          ],
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Text(
                          productModel.name ?? '',
                          textAlign: TextAlign.center,
                          style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (productModel.discount != null && productModel.discount! > 0)
                              Padding(
                                padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
                                child: Text(
                                  PriceConverter.convertPrice(context, productModel.unitPrice),
                                  style: titleRegular.copyWith(
                                    color: ColorResources.hintTextColor,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                  ),
                                ),
                              ),
                            Text(
                              PriceConverter.convertPrice(context, productModel.unitPrice,
                                  discountType: productModel.discountType, discount: productModel.discount),
                              style: titilliumSemiBold.copyWith(
                                color: ColorResources.getPrimary(context),
                                fontSize: Dimensions.fontSizeDefault,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // The discount and favorite buttons remain in the Stack to stay on top
              if (productModel.discount! > 0)
                Positioned(
                  top: 12,
                  left: 0,
                  child: Container(
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: ColorResources.getPrimary(context),
                      borderRadius: const BorderRadius.only(bottomRight: Radius.circular(5), topRight: Radius.circular(5)),
                    ),
                    child: Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          PriceConverter.percentageCalculation(context, productModel.unitPrice, productModel.discount, productModel.discountType),
                          style: textRegular.copyWith(color: Theme.of(context).highlightColor, fontSize: Dimensions.fontSizeSmall),
                        ),
                      ),
                    ),
                  ),
                ),

              Positioned(
                top: 10,
                right: 10,
                child: FavouriteButtonWidget(
                  backgroundColor: ColorResources.getImageBg(context),
                  productId: productModel.id,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}