import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/models/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/screens/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product_details/widgets/favourite_button_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/heartbeat_tea_cup_animation.dart';

class ProductWidget extends StatelessWidget {
  final Product productModel;
  const ProductWidget({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    String ratting = productModel.rating != null && productModel.rating!.isNotEmpty && productModel.rating![0].average != null? productModel.rating![0].average! : "0";

    return InkWell(
      onTap: () async {
        final overlayState = Overlay.of(context);
        final animationKey = GlobalKey<HeartbeatTeaCupAnimationState>();
        final entry = OverlayEntry(builder: (_) => HeartbeatTeaCupAnimation(key: animationKey));
        overlayState.insert(entry);
        await Future.delayed(const Duration(milliseconds: 60));
        // Start navigation without awaiting so the overlay stays on top for a beat
        Navigator.push(context, PageRouteBuilder(transitionDuration: const Duration(milliseconds: 650),
            pageBuilder: (context, anim1, anim2) => ProductDetails(productId: productModel.id, slug: productModel.slug)));
        // Delay a bit so the new page is visible, then fade out smoothly
        await Future.delayed(const Duration(milliseconds: 180));
        if(entry.mounted){
          animationKey.currentState?.startFadeOut((){ if(entry.mounted) entry.remove(); });
        }
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        child: AspectRatio(
          aspectRatio: 1 / 1.3,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).highlightColor,
              boxShadow: Provider.of<ThemeController>(context, listen: false).darkTheme ? null :
              [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 5)],
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Provider.of<ThemeController>(context, listen: false).darkTheme ?
                          Theme.of(context).primaryColor.withOpacity(.05) : ColorResources.getIconBg(context),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                          child: CustomImageWidget(
                            image: '${Provider.of<SplashController>(context, listen: false).baseUrls!.productThumbnailUrl}/${productModel.thumbnail}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.star_rate_rounded, color: Colors.orange, size: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(double.parse(ratting).toStringAsFixed(1),
                                    style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault)),
                              ),
                              Text('(${productModel.reviewCount ?? 0})',
                                  style: textRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor)),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Text(productModel.name ?? '',
                                textAlign: TextAlign.center,
                                style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ),
                          productModel.discount != null && productModel.discount! > 0 ?
                          Text(PriceConverter.convertPrice(context, productModel.unitPrice),
                              style: titleRegular.copyWith(
                                  color: Theme.of(context).hintColor,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: Dimensions.fontSizeSmall)) : const SizedBox.shrink(),
                          const SizedBox(height: 2),
                          Text(PriceConverter.convertPrice(context,
                              productModel.unitPrice,
                              discountType: productModel.discountType,
                              discount: productModel.discount),
                              style: titilliumSemiBold.copyWith(color: ColorResources.getPrimary(context))),
                        ],
                      ),
                    ),
                  ],
                ),

                // ======== FIX 1: RESTORED THE DISCOUNT WIDGET ========
                if (productModel.discount! > 0)
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: ColorResources.getPrimary(context),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                          bottomRight: Radius.circular(Dimensions.paddingSizeExtraSmall),
                        ),
                      ),
                      child: Center(
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            PriceConverter.percentageCalculation(
                              context,
                              productModel.unitPrice,
                              productModel.discount,
                              productModel.discountType,
                            ),
                            style: textRegular.copyWith(
                              color: Theme.of(context).highlightColor,
                              fontSize: Dimensions.fontSizeSmall,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                // ======== FIX 2: RESTORED THE FAVOURITE BUTTON WIDGET ========
                Positioned(
                  top: 5,
                  right: 5,
                  child: FavouriteButtonWidget(
                    backgroundColor: ColorResources.getImageBg(context),
                    productId: productModel.id,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}