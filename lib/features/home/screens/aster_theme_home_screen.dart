import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/order/controllers/order_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/seller_product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/screens/view_all_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/featured_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/home_category_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/latest_product_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/products_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/widgets/recommended_product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/responsive_helper.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/theme/controllers/theme_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/title_row_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/featured_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/featured_product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/order_again_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/top_store_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/announcement_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/screens/category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/more_store_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/aster_theme/order_again_list_view_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banners_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/cart_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/featured_deal_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/shimmers/flash_deal_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/widgets/flash_deals_list_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/single_banner_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/just_for_you/just_for_you_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/more_store_list_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/screens/flash_deal_screen_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/widgets/top_seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/screens/all_shop_screen.dart';
import 'package:provider/provider.dart';


class AsterThemeHomeScreen extends StatefulWidget {
  const AsterThemeHomeScreen({super.key});

  @override
  State<AsterThemeHomeScreen> createState() => _AsterThemeHomeScreenState();
}

class _AsterThemeHomeScreenState extends State<AsterThemeHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool singleVendor = false;

  Future<void> _loadData(bool reload) async {
    try {
      // Use the provided context directly, it's safe to do so from a State class
      await Provider.of<BannerController>(context, listen: false).getBannerList(context, reload);
      print('HOME LOG: banners=' + (Provider.of<BannerController>(context, listen: false).mainBannerList?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[banners]: $e');
      print(st);
    }

    try {
      await Provider.of<CategoryController>(context, listen: false).getList(context, reload);
      print('HOME LOG: categories=' + Provider.of<CategoryController>(context, listen: false).categoryList.length.toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[categories]: $e');
      print(st);
    }

    try {
      await Provider.of<ProductController>(context, listen: false).getHomeCategoryProductList(reload);
      print('HOME LOG: homeCategoryGroups=' + Provider.of<ProductController>(context, listen: false).homeCategoryProductList.length.toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[homeCategoryGroups]: $e');
      print(st);
    }

    try {
      await Provider.of<ShopController>(context, listen: false).getTopSellerList(reload, 1,type: "top");
      print('HOME LOG: topSellers=' + (Provider.of<ShopController>(context, listen: false).sellerModel?.sellers?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[topSellers]: $e');
      print(st);
    }

    try {
      await Provider.of<BrandController>(context, listen: false).getBrandList(context, reload);
      print('HOME LOG: brands=' + Provider.of<BrandController>(context, listen: false).brandList.length.toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[brands]: $e');
      print(st);
    }

    try {
      await Provider.of<ProductController>(context, listen: false).getLatestProductList(1, reload: reload);
      await Provider.of<ProductController>(context, listen: false).getFeaturedProductList('1', reload: reload);
      await Provider.of<ProductController>(context, listen: false).getLProductList('1', reload: reload);
      print('HOME LOG: latestFilteredProducts=' + (Provider.of<ProductController>(context, listen: false).latestProductList?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[products]: $e');
      print(st);
    }

    try {
      await Provider.of<FeaturedDealController>(context, listen: false).getFeaturedDealList(reload);
      print('HOME LOG: featuredDeals=' + (Provider.of<FeaturedDealController>(context, listen: false).featuredDealProductList?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[featuredDeals]: $e');
      print(st);
    }

    try {
      await Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, reload);
      print('HOME LOG: flashDeals=' + (Provider.of<FlashDealController>(context, listen: false).flashDealList?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[flashDeals]: $e');
      print(st);
    }

    try {
      await Provider.of<ProductController>(context, listen: false).getRecommendedProduct();
      print('HOME LOG: recommendedProductPresent=' + (Provider.of<ProductController>(context, listen: false).recommendedProduct != null).toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[recommendedProduct]: $e');
      print(st);
    }

    try {
      await Provider.of<ProductController>(context, listen: false).findWhatYouNeed();
      print('HOME LOG: findWhatYouNeedPresent=' + (Provider.of<ProductController>(context, listen: false).findWhatYouNeedModel != null).toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[findWhatYouNeed]: $e');
      print(st);
    }

    try {
      await Provider.of<ProductController>(context, listen: false).getJustForYouProduct();
      print('HOME LOG: justForYouCount=' + (Provider.of<ProductController>(context, listen: false).justForYouProduct?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[justForYou]: $e');
      print(st);
    }

    try {
      await Provider.of<ShopController>(context, listen: false).getMoreStore();
      print('HOME LOG: moreStores=' + Provider.of<ShopController>(context, listen: false).moreStoreList.length.toString());
    } catch (e, st) {
      print('HOME_LOAD_ERROR[moreStores]: $e');
      print(st);
    }

    try {
      await Provider.of<NotificationController>(context, listen: false).getNotificationList(1);
      print('HOME LOG: notifications=' + (Provider.of<NotificationController>(context, listen: false).notificationModel?.notification?.length.toString() ?? '0'));
    } catch (e, st) {
      print('HOME_LOAD_ERROR[notifications]: $e');
      print(st);
    }


    if(Provider.of<AuthController>(context, listen: false).isLoggedIn()){
      try {
        await Provider.of<ProfileController>(context, listen: false).getUserInfo(context);
      } catch (e, st) {
        print('HOME_LOAD_ERROR[userInfo]: $e');
        print(st);
      }
      try {
        await Provider.of<SellerProductController>(context, listen: false).getShopAgainFromRecentStore();
      } catch (e, st) {
        print('HOME_LOAD_ERROR[shopAgain]: $e');
        print(st);
      }
      try {
        await Provider.of<OrderController>(context, listen: false).getOrderList(1,'delivered', type: 'reorder');
      } catch (e, st) {
        print('HOME_LOAD_ERROR[reorder]: $e');
        print(st);
      }
      try {
        await Provider.of<WishListController>(context, listen: false).getWishList();
      } catch (e, st) {
        print('HOME_LOAD_ERROR[wishlist]: $e');
        print(st);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Use the class member `singleVendor` directly
    singleVendor = Provider.of<SplashController>(context, listen: false).configModel?.businessMode == "single" ?? false;
    _loadData(false);
  }

  @override
  Widget build(BuildContext context) {
    List<String?> types =[
      getTranslated('new_arrival', context),
      getTranslated('top_product', context),
      getTranslated('best_selling', context),
      getTranslated('discounted_product', context)
    ];

    return Scaffold(resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => await _loadData(true),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                  floating: true,
                  elevation: 0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).highlightColor,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.asset(Images.newLogo, height: 60, fit: BoxFit.contain),
                  ),
                  actions: const [CartHomePageWidget()]),

              SliverToBoxAdapter(child: Provider.of<SplashController>(context, listen: false).configModel?.announcement?.status == '1'?
              Consumer<SplashController>(
                builder: (context, announcement, _){
                  return (announcement.configModel?.announcement?.announcement != null && announcement.onOff)
                      ? AnnouncementWidget(announcement: announcement.configModel!.announcement)
                      : const SizedBox();
                },
              ):const SizedBox(),
              ),

              // Search Button
              SliverPersistentHeader(pinned: true,
                  delegate: SliverDelegate(
                      child: InkWell(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchScreen())),
                          child: const SearchHomePageWidget()))),

              SliverToBoxAdapter(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  // Banners - FIXED with explicit height
                  Consumer<BannerController>(
                    builder: (context, bannerProvider, child) {
                      if (bannerProvider.mainBannerList != null && bannerProvider.mainBannerList!.isNotEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.width * 0.45,
                          child: const BannersWidget(),
                        );
                      }
                      return const SizedBox();
                    },
                  ),

                  const SizedBox(height: Dimensions.homePagePadding),

                  // Flash Deals - FIXED
                  Consumer<FlashDealController>(
                    builder: (context, megaDeal, child) {
                      if (megaDeal.flashDeal != null && (megaDeal.flashDealList?.isNotEmpty ?? false)) {
                        return Column(children: [
                          Padding(padding: const EdgeInsets.fromLTRB(Dimensions.homePagePadding,
                              Dimensions.paddingSizeSmall, Dimensions.paddingSizeDefault, Dimensions.paddingSizeExtraExtraSmall),
                              child: TitleRowWidget(title: getTranslated('flash_deal', context),
                                  eventDuration: megaDeal.flashDeal?.id != null ? megaDeal.duration : null,
                                  onTap: () {Navigator.push(context, MaterialPageRoute(builder: (_) => const FlashDealScreenView()));
                                  }, isFlash: true)),
                          const SizedBox(height: Dimensions.paddingSizeSmall),
                          Text(getTranslated('hurry_up_the_offer_is_limited_grab_while_it_lasts', context)??'',
                              style: textRegular.copyWith(color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                              Theme.of(context).hintColor : Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeDefault)),
                          const SizedBox(height: Dimensions.paddingSizeDefault),
                          SizedBox(height: ResponsiveHelper.isTab(context)? MediaQuery.of(context).size.width * .58 : 350,
                              child: const Padding(padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                                  child: FlashDealsListWidget()))
                        ]);
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  // Categories (replaced "Find what you need")
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: Dimensions.homePagePadding,
                      top: Dimensions.homePagePadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleRowWidget(
                          title: getTranslated('Category', context),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CategoryScreen()),
                          ),
                        ),
                        const SizedBox(height: Dimensions.homePagePadding),
                        const CategoryListWidget(isHomePage: true),
                      ],
                    ),
                  ),


                  //Order Again - FIXED
                  if(Provider.of<AuthController>(context, listen: false).isLoggedIn())
                    Consumer<OrderController>(
                        builder: (context, orderProvider,_) {
                          if (orderProvider.deliveredOrderModel != null && (orderProvider.deliveredOrderModel?.orders?.isNotEmpty ?? false)) {
                            return const Padding(padding: EdgeInsets.all(Dimensions.homePagePadding),
                              child: OrderAgainView(),
                            );
                          } else {
                            return Consumer<BannerController>(builder: (context, bannerProvider, child) {
                              return bannerProvider.sideBarBanner != null
                                  ? Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                                  left:Dimensions.bannerPadding, right: Dimensions.bannerPadding ),
                                  child: SingleBannersWidget(bannerModel : bannerProvider.sideBarBanner,
                                      height: MediaQuery.of(context).size.width * 1.2))
                                  : const SizedBox();
                            });
                          }
                        }
                    )
                  else
                    Consumer<BannerController>(builder: (context, bannerProvider, child){
                      return bannerProvider.sideBarBanner != null
                          ? Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                          left:Dimensions.bannerPadding, right: Dimensions.bannerPadding ),
                          child: SingleBannersWidget(bannerModel : bannerProvider.sideBarBanner,
                              height: MediaQuery.of(context).size.width * 1.2))
                          : const SizedBox();
                    }),
                  const SizedBox(height: Dimensions.paddingSizeDefault),


                  //top seller - FIXED
                  if(!singleVendor)
                    Consumer<ShopController>(
                      builder: (context, shopController,_) {
                        if (shopController.sellerModel != null && (shopController.sellerModel?.sellers?.isNotEmpty ?? false)) {
                          return Column(children: [
                            TitleRowWidget(title: getTranslated('top_stores', context),
                                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                const AllTopSellerScreen( title: 'top_stores',)))),
                            const SizedBox(height: Dimensions.paddingSizeSmall),
                            SizedBox(height: ResponsiveHelper.isTab(context)? 180 : 165,
                                child: TopSellerView(isHomePage: true, scrollController: _scrollController,)),
                          ]);
                        }
                        return const TopStoreShimmer();
                      },
                    ),

                  // Featured Deals - FIXED
                  Consumer<FeaturedDealController>(
                    builder: (context, featuredDealProvider, child) {
                      if (featuredDealProvider.featuredDealProductList != null && featuredDealProvider.featuredDealProductList!.isNotEmpty) {
                        return Stack(children: [
                          Container(width: MediaQuery.of(context).size.width,height: 150,
                              color: Provider.of<ThemeController>(context, listen: false).darkTheme?
                              Theme.of(context).primaryColor.withOpacity(.20):Theme.of(context).primaryColor.withOpacity(.125)),
                          Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                            child: Column(children: [
                              Padding(padding: const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeDefault,0 ,
                                  Dimensions.paddingSizeDefault),
                                  child: TitleRowWidget(title: getTranslated('featured_deals', context) ?? 'Featured Deals',
                                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                      const FeaturedDealScreenView())))),
                              SizedBox(height: 180, // Explicit height to fix layout overflow
                                child: const FeaturedDealsListWidget(),
                              ),
                            ],
                            ),
                          ),
                        ]);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: Dimensions.homePagePadding),

                  // Featured Products - FIXED
                  Consumer<ProductController>(
                    builder: (context, featured,_) {
                      if (featured.featuredProductList != null && featured.featuredProductList!.isNotEmpty) {
                        // We removed the Stack because we deleted the background Container
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleRowWidget( title: getTranslated('featured_products', context) ?? 'Featured Products',
                                onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                    AllProductScreen(productType: ProductType.featuredProduct)))),

                            Padding(
                              padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding),
                              child: SizedBox(
                                // STEP 1: Increase the height here to give the section more space
                                  height: 280,
                                  child: FeaturedProductWidget(scrollController: _scrollController, isHome: true)
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  // Top Sidebar Banner - FIXED
                  Consumer<BannerController>(builder: (context, bannerProvider, child){
                    return bannerProvider.topSideBarBannerBottom != null
                        ? Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                        left:Dimensions.bannerPadding, right: Dimensions.bannerPadding ),
                        child: SingleBannersWidget(bannerModel : bannerProvider.topSideBarBannerBottom,
                            height: MediaQuery.of(context).size.width * 1.2))
                        : const SizedBox();
                  }),


                  const Padding(padding: EdgeInsets.only(bottom: Dimensions.homePagePadding),
                      child: RecommendedProductWidget(fromAsterTheme: true)),


                  // Latest Products - FIXED with explicit height
                  SizedBox(height: 340, child: const LatestProductListWidget()),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  // Black Friday (Footer Banner) - FIXED
                  Consumer<BannerController>(builder: (context, bannerProvider, child){
                    return (bannerProvider.footerBannerList != null && (bannerProvider.footerBannerList?.isNotEmpty ?? false))
                        ? Padding(padding: const EdgeInsets.only(bottom: Dimensions.homePagePadding,
                        left:Dimensions.homePagePadding, right: Dimensions.homePagePadding ),
                        child: SingleBannersWidget(bannerModel : bannerProvider.footerBannerList![0],
                            height: MediaQuery.of(context).size.width * 0.5))
                        : const SizedBox();
                  }),

                  // Just for you - FIXED with explicit height
                  SizedBox(
                    height: 340, // Fixed height is required to prevent overflow
                    child: Consumer<ProductController>(
                        builder: (context, productController,_) {
                          if (productController.justForYouProduct != null && productController.justForYouProduct!.isNotEmpty) {
                            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              TitleRowWidget(title: getTranslated('just_for_you', context)??'Just For You', onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) => AllProductScreen(productType: ProductType.justForYou)));
                              }),
                              JustForYouView(productList: productController.justForYouProduct)
                            ]);
                          }
                          return const SizedBox();
                        }),
                  ),


                  // More Store - FIXED
                  Consumer<ShopController>(
                      builder: (context, moreStoreProvider, _) {
                        if(moreStoreProvider.moreStoreList.isNotEmpty) {
                          return Padding(padding:  const EdgeInsets.fromLTRB(0, Dimensions.paddingSizeSmall, 0, Dimensions.paddingSizeSmall,),
                              child: Column(children: [
                                TitleRowWidget(title: getTranslated('more_store', context) ?? 'More Store',
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                                        MoreStoreViewListView(title: getTranslated('more_store', context))))),
                                const SizedBox(height: Dimensions.homePagePadding),
                                SizedBox(height: ResponsiveHelper.isTab(context)? 170 : 100,
                                    child: const MoreStoreView(isHome: true,))
                              ])
                          );
                        }
                        return const SizedBox();
                      }),


                  const Padding(padding: EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                      child: HomeCategoryProductWidget(isHomePage: true)),
                  const SizedBox(height: Dimensions.homePagePadding),


                  Consumer<BannerController>(builder: (context, footerBannerProvider, child){
                    return footerBannerProvider.mainSectionBanner != null
                        ? SingleBannersWidget(bannerModel: footerBannerProvider.mainSectionBanner,
                      height: MediaQuery.of(context).size.width/4,)
                        : const SizedBox();}),


                  Consumer<ProductController>(
                      builder: (ctx,prodProvider,child) {
                        return Padding(padding: const EdgeInsets.fromLTRB(Dimensions.paddingSizeDefault, 0,
                            Dimensions.paddingSizeSmall, Dimensions.paddingSizeExtraSmall),
                          child: Row(children: [
                            Expanded(child: Text(
                                getTranslated(prodProvider.title ?? 'new_arrival', context) ?? 'New Arrival',
                                style: titleHeader)),
                            if (prodProvider.latestProductList != null)
                              PopupMenuButton(itemBuilder: (context) {return [
                                PopupMenuItem(value: ProductType.newArrival, textStyle: textRegular.copyWith(
                                    color: Theme.of(context).hintColor), child: Text(getTranslated('new_arrival',context)!)),

                                PopupMenuItem(value: ProductType.topProduct, textStyle: textRegular.copyWith(
                                    color: Theme.of(context).hintColor), child: Text(getTranslated('top_product',context)!)),


                                PopupMenuItem(value: ProductType.bestSelling, textStyle: textRegular.copyWith(
                                    color: Theme.of(context).hintColor), child: Text(getTranslated('best_selling',context)!)),

                                PopupMenuItem(value: ProductType.discountedProduct, textStyle: textRegular.copyWith(
                                    color: Theme.of(context).hintColor), child: Text(getTranslated('discounted_product',context)!))];},
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall)),
                                  child: Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall,
                                      vertical:Dimensions.paddingSizeSmall ),
                                      child: Image.asset(Images.dropdown, scale: 3)),
                                  onSelected: (dynamic value) {
                                    if(value == ProductType.newArrival){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[0]);
                                    }else if(value == ProductType.topProduct){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[1]);
                                    }else if(value == ProductType.bestSelling){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[2]);
                                    }else if(value == ProductType.discountedProduct){
                                      Provider.of<ProductController>(context, listen: false).changeTypeOfProduct(value, types[3]);
                                    }

                                    ProductListWidget(isHomePage: false, productType: value, scrollController: _scrollController);
                                    Provider.of<ProductController>(context, listen: false).getLatestProductList(1, reload: true);
                                  })
                            else
                              const SizedBox(),
                          ]),
                        );
                      }),

                  Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.homePagePadding),
                      child: ProductListWidget(isHomePage: false, productType: ProductType.newArrival,
                          scrollController: _scrollController)),
                  const SizedBox(height: Dimensions.homePagePadding),
                ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SliverDelegate extends SliverPersistentHeaderDelegate {
  Widget child;
  double height;
  SliverDelegate({required this.child, this.height = 70});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverDelegate oldDelegate) {
    return oldDelegate.maxExtent != height || oldDelegate.minExtent != height || child != oldDelegate.child;
  }
}
