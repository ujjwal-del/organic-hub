import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';

class ShopInfoWidget extends StatelessWidget {
  // We only need these parameters now
  final int sellerId;
  final String banner;

  const ShopInfoWidget({
    super.key,
    required this.sellerId,
    required this.banner,
    // The other parameters are no longer needed
    bool? vacationIsOn,
    bool? temporaryClose,
    String? sellerName,
    String? shopImage,
  });

  @override
  Widget build(BuildContext context) {
    var splashController = Provider.of<SplashController>(context, listen: false);

    // The entire widget is now just this banner image.
    return CustomImageWidget(
      image: sellerId == 0
          ? splashController.configModel!.companyCoverImage ?? ''
          : '${Provider.of<SplashController>(context, listen: false).baseUrls!.shopImageUrl}/banner/$banner',
      placeholder: Images.placeholder_3x1,
      width: MediaQuery.of(context).size.width,
      height: ResponsiveHelper.isTab(context) ? 250 : 120,
    );
  }
}