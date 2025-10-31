import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/bouncy_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/order_details/screens/order_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/push_notification/models/notification_body.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/no_internet_screen_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/chat/screens/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/screens/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/onboarding/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final NotificationBody? body;
  const SplashScreen({super.key, this.body});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
          if (!firstTime) {
            bool isNotConnected =
                result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
            isNotConnected
                ? const SizedBox()
                : ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: isNotConnected ? Colors.red : Colors.green,
                duration: Duration(seconds: isNotConnected ? 6000 : 3),
                content: Text(
                  isNotConnected
                      ? getTranslated('no_connection', context)!
                      : getTranslated('connected', context)!,
                  textAlign: TextAlign.center,
                )));

            // 🔁 If reconnected, retry routing
            if (!isNotConnected) {
              _route();
            }
          }
          firstTime = false;
        });

    // Delay slightly for splash logo animation
    Future.delayed(const Duration(milliseconds: 600), _route);
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  // ✅ Improved route with timeout + fallback navigation
  void _route() async {
    debugPrint("🚀 Splash: Starting initialization...");
    final splashController = Provider.of<SplashController>(context, listen: false);
    final authController = Provider.of<AuthController>(context, listen: false);

    bool isSuccess = false;
    bool hasError = false;

    try {
      // Timeout safeguard (avoid getting stuck forever)
      isSuccess = await splashController
          .initConfig(context)
          .timeout(const Duration(seconds: 10), onTimeout: () {
        debugPrint("⏰ CONFIG API TIMEOUT – using fallback route");
        hasError = true;
        return false;
      });
    } catch (e) {
      debugPrint("❌ Exception while initializing config: $e");
      hasError = true;
    }

    // Always navigate after small delay
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      splashController.initSharedPrefData();

      if (splashController.hasConnection && isSuccess && !hasError) {
        debugPrint("✅ Config loaded successfully");
        _navigateAfterConfig(authController, splashController);
      } else {
        debugPrint("⚠️ Config load failed or no internet – showing offline screen");
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const NoInternetOrDataScreenWidget(
            isNoInternet: true,
            child: SplashScreen(),
          ),
        ));
      }
    });
  }

  void _navigateAfterConfig(
      AuthController authController, SplashController splashController) {
    if (splashController.configModel?.maintenanceMode == true) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MaintenanceScreen()));
    } else if (authController.isLoggedIn()) {
      authController.updateToken(context);

      if (widget.body != null) {
        if (widget.body!.type == 'order') {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => OrderDetailsScreen(orderId: widget.body!.orderId)));
        } else if (widget.body!.type == 'notification') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const NotificationScreen()));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (_) => const InboxScreen(isBackButtonExist: true)));
        }
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()));
      }
    } else if (splashController.showIntro() == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => OnBoardingScreen(
            indicatorColor: ColorResources.grey,
            selectedIndicatorColor: Theme.of(context).primaryColor,
          )));
    } else {
      if (authController.getGuestToken() != null &&
          authController.getGuestToken() != '1') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashBoardScreen()));
      } else {
        authController.getGuestIdUrl();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const DashBoardScreen()),
              (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      key: _globalKey,
      body: Provider.of<SplashController>(context).hasConnection
          ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BouncyWidget(
                  duration: const Duration(milliseconds: 2000),
                  lift: 50,
                  ratio: 0.5,
                  pause: 0.25,
                  child: SizedBox(
                      width: 150, child: Image.asset(Images.icon, width: 150.0))),
              Text(AppConstants.appName,
                  style: textRegular.copyWith(
                      fontSize: Dimensions.fontSizeOverLarge,
                      color: Colors.white)),
              Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
                  child: Text(AppConstants.slogan,
                      style: textRegular.copyWith(
                          fontSize: Dimensions.fontSizeDefault,
                          color: Colors.white)))
            ],
          ))
          : const NoInternetOrDataScreenWidget(
          isNoInternet: true, child: SplashScreen()),
    );
  }
}
