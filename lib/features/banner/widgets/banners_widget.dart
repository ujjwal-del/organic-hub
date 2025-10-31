import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banner_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_image_widget.dart';
import 'package:provider/provider.dart';



class BannersWidget extends StatelessWidget {
  const BannersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
        Consumer<BannerController>(
          builder: (context, bannerProvider, child) {
            print('DEBUG: Banner widget rebuilding, banner count: ${bannerProvider.mainBannerList?.length ?? 0}');
            print('DEBUG: Banner list is null: ${bannerProvider.mainBannerList == null}');
            print('DEBUG: Banner list is empty: ${bannerProvider.mainBannerList?.isEmpty ?? true}');

            double width = MediaQuery.of(context).size.width;
            return Stack(children: [
                bannerProvider.mainBannerList != null ? bannerProvider.mainBannerList!.isNotEmpty ?
                SizedBox(height: width * 0.435,width: width,
                  child: Column(children: [
                      SizedBox(height: width * 0.39, width: width,
                        child: (bannerProvider.mainBannerList == null || bannerProvider.mainBannerList!.isEmpty)
                            ? const SizedBox.shrink()
                            : PageView.builder(
                          itemCount: bannerProvider.mainBannerList?.length ?? 0,
                          onPageChanged: (index) {
                            bannerProvider.setCurrentIndex(index);
                          },
                          itemBuilder: (context, index) {

                            return InkWell(
                              onTap: () {
                                if(bannerProvider.mainBannerList![index].resourceId != null){
                                  bannerProvider.clickBannerRedirect(context,
                                      bannerProvider.mainBannerList![index].resourceId,
                                      bannerProvider.mainBannerList![index].resourceType =='product'?
                                      bannerProvider.mainBannerList![index].product : null,
                                      bannerProvider.mainBannerList![index].resourceType);
                                }
                                },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                child: Container(decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                  color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                                  Theme.of(context).primaryColor.withOpacity(.1) :
                                  Theme.of(context).primaryColor.withOpacity(.05)),
                                    child: CustomImageWidget(image: '${Provider.of<SplashController>(context,listen: false).baseUrls?.bannerImageUrl}'
                                    '/${bannerProvider.mainBannerList?[index].photo}')
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ) : const SizedBox() : const BannerShimmer(),

                if( bannerProvider.mainBannerList != null &&  bannerProvider.mainBannerList!.isNotEmpty)
                  Positioned(bottom: 0, left: 0, right: 0,
                    child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(height: 7, width: 7,
                      margin:  const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration:  BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                          children: bannerProvider.mainBannerList!.map((banner) {
                            int index = bannerProvider.mainBannerList!.indexOf(banner);
                            return index == bannerProvider.currentIndex ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
                              margin: const EdgeInsets.symmetric(horizontal: 6.0),
                              decoration: BoxDecoration(
                                color:  Theme.of(context).primaryColor ,
                                borderRadius: BorderRadius.circular(50)),
                              child:  Text("${bannerProvider.mainBannerList!.indexOf(banner) + 1}/ ${bannerProvider.mainBannerList!.length}",
                                style: const TextStyle(color: Colors.white,fontSize: 12),),
                            ):const SizedBox();
                          }).toList(),
                        ),
                      Container(height: 7, width: 7,
                        margin:  const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration:  BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      )
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 5),
      ],
    );
  }


}

