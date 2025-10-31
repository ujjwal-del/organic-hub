  import 'package:flutter/material.dart';
  import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
  import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
  import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
  import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
  import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';

  class OrderPlaceDialogWidget extends StatelessWidget {
    final bool isFailed;
    final double rotateAngle;
    final IconData icon;
    final String? title;
    final String? description;
    const OrderPlaceDialogWidget({super.key, this.isFailed = false, this.rotateAngle = 0, required this.icon, required this.title, required this.description});

    @override
    Widget build(BuildContext context) {
      return Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [

            // --- MODIFIED SECTION START ---
            SizedBox(
                width: 150, // Increased width
                height: 100, // Increased height
                child: Image.asset(Images.newLogo, fit: BoxFit.contain)),
            // --- MODIFIED SECTION END ---

            const SizedBox(height: 16),
            Text('Thank you for shopping with Organic Hub',
                textAlign: TextAlign.center,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
            const SizedBox(height: 8),
            Text(title ?? getTranslated('order_placed', context) ?? 'Order Placed Successfully!',
                textAlign: TextAlign.center, style: textMedium),
            const SizedBox(height: 6),
            Text(description ?? (getTranslated('your_order_placed', context) ?? 'To find the order ID and details, check your email.'),
                textAlign: TextAlign.center, style: titilliumRegular),
            const SizedBox(height: 20),
            SizedBox(height: 44, width: 120, child: CustomButton(
                radius: 8,
                buttonText: getTranslated('ok', context),
                onTap: () => Navigator.pop(context))),
          ]),
        ),
      );
    }
  }