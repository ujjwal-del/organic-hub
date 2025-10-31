import 'dart:developer';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/social_login_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/facebook_login_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/google_login_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../screens/mobile_verify_screen.dart';
import '../screens/otp_verification_screen.dart';

class SocialLoginWidget extends StatefulWidget {
  const SocialLoginWidget({super.key});

  @override
  SocialLoginWidgetState createState() => SocialLoginWidgetState();
}

class SocialLoginWidgetState extends State<SocialLoginWidget> {

  SocialLoginModel socialLogin = SocialLoginModel();
  route(bool isRoute, String? token, String? temporaryToken, String? errorMessage) async {
    // THIS IS THE FIX 👇
    if (!mounted) return;

    if (isRoute) {
      if(token != null){
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);

      }else if(temporaryToken != null && temporaryToken.isNotEmpty){
        if(Provider.of<SplashController>(context,listen: false).configModel!.emailVerification!){
          Provider.of<AuthController>(context, listen: false).sendOtpToEmail(socialLogin.email.toString(),
              temporaryToken).then((value) async {
            // It's also safer to check here as well
            if (!mounted) return;
            if (value.response?.statusCode == 200) {
              Provider.of<AuthController>(context, listen: false).updateEmail(socialLogin.email.toString());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => VerificationScreen(temporaryToken, '',socialLogin.email.toString())), (route) => false);
            }
          });
        } else { // Added an else block to avoid duplicate navigation
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => MobileVerificationScreen(temporaryToken)), (route) => false);
        }
      }
      else {
        showCustomSnackBar(errorMessage!, context);
      }

    } else {
      showCustomSnackBar(errorMessage!, context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
        (Provider.of<SplashController>(context,listen: false).configModel!.socialLogin![0].status! ||
       Provider.of<SplashController>(context,listen: false).configModel!.socialLogin![1].status! ||
            Provider.of<SplashController>(context,listen: false).configModel!.socialLogin![2].status!)?

        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(child: Image.asset(Images.left, color: Theme.of(context).primaryColor)),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Center(child: Text(getTranslated('or_login_with', context)??'', style: textRegular.copyWith(fontSize: Dimensions.fontSizeDefault),)),
            const SizedBox(width: Dimensions.paddingSizeSmall,),
            Expanded(child: Image.asset( Images.right))]) :const SizedBox(),


        Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
             // Temporarily show Google button for testing (ignore backend config)
             InkWell(
                onTap: () async {
                  try {
                    // Use the enhanced Google Sign-In method
                    final userCredential = await Provider.of<GoogleSignInController>(context, listen: false).signInWithGoogle();
                    
                    if (userCredential != null && context.mounted) {
                      // Successfully signed in with Firebase
                      final user = userCredential.user;
                                              if (user != null) {
                          // Get the Google account and authentication details
                          final googleController = Provider.of<GoogleSignInController>(context, listen: false);
                          final googleAccount = googleController.googleAccount;
                          final googleAuth = googleController.auth;
                          
                          // Debug logging
                          log('Debug - Google Account: ${googleAccount?.id}');
                          log('Debug - Google Auth: ${googleAuth?.accessToken?.substring(0, 20)}...');
                          log('Debug - User Email: ${user.email}');
                          
                          if (googleAccount != null && googleAuth != null) {
                            String? id = googleAccount.id; // Use Google account ID, not Firebase UID
                            String? email = user.email;
                            String? token = googleAuth.accessToken; // Use Google access token, not Firebase ID token
                            String medium = 'google';
                            
                            log('Google Sign-In Success - Email: $email, Google ID: $id, Access Token: ${token?.substring(0, 20)}...');
                            
                            socialLogin.email = email;
                            socialLogin.medium = medium;
                            socialLogin.token = token;
                            socialLogin.uniqueId = id;
                            
                            // Call socialLogin with the route callback
                            await Provider.of<AuthController>(context, listen: false).socialLogin(socialLogin, route);
                          } else {
                            log('Debug - Google Account is null: ${googleAccount == null}');
                            log('Debug - Google Auth is null: ${googleAuth == null}');
                            showCustomSnackBar('Failed to get Google authentication details', context);
                          }
                        }
                    } else if (context.mounted) {
                      // User cancelled or sign-in failed
                      final controller = Provider.of<GoogleSignInController>(context, listen: false);
                      if (controller.errorMessage != null) {
                        showCustomSnackBar(controller.errorMessage!, context);
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      showCustomSnackBar('Google Sign-In failed: ${e.toString()}', context);
                    }
                    log('Google Sign-In Error: $e');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).hintColor.withOpacity(.25),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 0)
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<GoogleSignInController>(
                        builder: (context, googleController, child) {
                          if (googleController.isLoading) {
                            return SizedBox(
                              height: 47,
                              width: 47,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                ),
                              ),
                            );
                          }
                          return Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(Radius.circular(5))
                                ),
                                height: 47,
                                width: 47,
                                child: Padding(
                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                  child: Image.asset(Images.google)
                                ),
                              ),
                            ]
                          );
                        },
                      )
                    )
                  )
                )
              ),


              Provider.of<SplashController>(context,listen: false).configModel!.socialLogin![1].status!?
              InkWell(onTap: () async{
                  await Provider.of<FacebookLoginController>(context, listen: false).login();
                  String? id,token,email, medium;
                  if(Provider.of<FacebookLoginController>(context,listen: false).userData != null){
                    id = Provider.of<FacebookLoginController>(context,listen: false).result.accessToken!.userId;
                    email = Provider.of<FacebookLoginController>(context,listen: false).userData!['email'];
                    token = Provider.of<FacebookLoginController>(context,listen: false).result.accessToken!.token;
                    medium = 'facebook';
                    socialLogin.email = email;
                    socialLogin.medium = medium;
                    socialLogin.token = token;
                    socialLogin.uniqueId = id;
                    await Provider.of<AuthController>(context, listen: false).socialLogin(socialLogin, route);
                  }
                },
                child: Padding(padding: const EdgeInsets.all(6),
                  child: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).cardColor,
                      boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(.25), blurRadius: 1, spreadRadius: 1, offset: const Offset(0,0))]),
                    child: Padding(padding: const EdgeInsets.all(8.0),
                      child: Wrap(crossAxisAlignment: WrapCrossAlignment.center,
                        children: [SizedBox(height: 47,width: 47,
                            child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              child: Image.asset(Images.facebook),)),
                        ]))))):const SizedBox(),


              // Temporarily disabled Apple Sign In
              // if(Provider.of<SplashController>(context,listen: false).configModel!.socialLogin!.length >2 && Provider.of<SplashController>(context,listen: false).configModel!.socialLogin![2].status! && Platform.isIOS)
              // Padding(padding: const EdgeInsets.all(6.0),
              //   child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
              //     child: SizedBox(width: 70,height: 70,
              //       child: ClipRRect(borderRadius: BorderRadius.circular(100),
              //         child: SignInWithAppleButton(
              //           style: Provider.of<ThemeController>(context, listen: false).darkTheme? SignInWithAppleButtonStyle.black : SignInWithAppleButtonStyle.white,
              //           text: '',
              //           height: 47,
              //           onPressed: () async {
              //             String? id,token,email, medium;
              //             final credential = await SignInWithApple.getAppleIDCredential(
              //               scopes: [AppleIDAuthorizationScopes.email,
              //                 AppleIDAuthorizationScopes.fullName]);
              //             id = credential.authorizationCode;
              //             email = credential.email??'';
              //             token = credential.authorizationCode;
              //             medium = 'apple';
              //             socialLogin.email = email;
              //             socialLogin.medium = medium;
              //             socialLogin.token = token;
              //             socialLogin.uniqueId = id;
              //             await Provider.of<AuthController>(Get.context!, listen: false).socialLogin(socialLogin, route);

              //             log('id token =>${credential.identityToken}\n===> Identifier${credential.userIdentifier}\n==>Given Name ${credential.familyName}');
              //           },
              //         ),
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
