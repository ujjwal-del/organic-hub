import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/controllers/banner_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/controllers/category_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/controllers/product_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/shop/controllers/shop_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/controllers/brand_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/featured_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/deal/controllers/flash_deal_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/cart/controllers/cart_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/notification/controllers/notification_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/features/wishlist/controllers/wishlist_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/search_product/screens/search_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/widgets/banners_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/category/widgets/category_list_widget.dart';
// Removed non-existent widget imports; use existing sections from themed screens
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/cart_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/home/widgets/search_home_page_widget.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  bool _hasLoadedData = false;

  Future<void> _safe(String label, Future<void> Function() action) async {
    try {
      await action();
    } catch (e, st) {
      // Keep UI resilient; log for diagnostics only
      // ignore: avoid_print
      print('HOME_LOAD_ERROR[' + label + ']: ' + e.toString());
      // ignore: avoid_print
      print(st);
    }
  }

  @override
  void initState() {
    super.initState();
    print('DEBUG: HomePage initState called');
    
    // Load data immediately without waiting for config
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataImmediately();
    });
  }

  Future<void> _loadDataImmediately() async {
    print('DEBUG: Loading data immediately...');
    setState(() {
      _isLoading = true;
    });
    try {
      await Future.wait([
        _safe('banners', _loadBanners),
        _safe('categories', _loadCategories),
        _safe('products', _loadProducts),
        _safe('shops', _loadShops),
        _safe('brands', _loadBrands),
        _safe('deals', _loadDeals),
      ]);
      print('DEBUG: All data loaded (isolated)');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasLoadedData = true;
        });
      }
    }
  }

  Future<void> _loadBanners() async {
    try {
      await Provider.of<BannerController>(context, listen: false).getBannerList(context, false);
      print('DEBUG: Banners loaded: ${Provider.of<BannerController>(context, listen: false).mainBannerList?.length ?? 0}');
    } catch (e) {
      print('DEBUG: Error loading banners: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      await Provider.of<CategoryController>(context, listen: false).getList(context, false);
      print('DEBUG: Categories loaded: ${Provider.of<CategoryController>(context, listen: false).categoryList.length}');
    } catch (e) {
      print('DEBUG: Error loading categories: $e');
    }
  }

  Future<void> _loadProducts() async {
    try {
      await Provider.of<ProductController>(context, listen: false).getLatestProductList(1, reload: false);
      await Provider.of<ProductController>(context, listen: false).getFeaturedProductList('1', reload: false);
      await Provider.of<ProductController>(context, listen: false).getHomeCategoryProductList(false);
      print('DEBUG: Products loaded');
    } catch (e) {
      print('DEBUG: Error loading products: $e');
    }
  }

  Future<void> _loadShops() async {
    try {
      await Provider.of<ShopController>(context, listen: false).getTopSellerList(false, 1, type: "top");
      print('DEBUG: Shops loaded');
    } catch (e) {
      print('DEBUG: Error loading shops: $e');
    }
  }

  Future<void> _loadBrands() async {
    try {
      await Provider.of<BrandController>(context, listen: false).getBrandList(context, false);
      print('DEBUG: Brands loaded');
    } catch (e) {
      print('DEBUG: Error loading brands: $e');
    }
  }

  Future<void> _loadDeals() async {
    try {
      await Provider.of<FlashDealController>(context, listen: false).getFlashDealList(true, true);
      await Provider.of<FeaturedDealController>(context, listen: false).getFeaturedDealList(false);
      print('DEBUG: Deals loaded');
    } catch (e) {
      print('DEBUG: Error loading deals: $e');
    }
  }

  Future<void> _refreshData() async {
    print('DEBUG: Refreshing data...');
    await _loadDataImmediately();
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building HomePage, loading: $_isLoading, hasData: $_hasLoadedData');
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              // App Bar
                              SliverAppBar(
                  floating: true,
                  elevation: 0,
                  centerTitle: false,
                  automaticallyImplyLeading: false,
                  backgroundColor: Theme.of(context).highlightColor,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.asset(Images.newLogo, height: 85, fit: BoxFit.contain),
                  ),
                  actions: const [CartHomePageWidget()],
                ),

              // Debug Info removed

              // Search Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverDelegate(
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    ),
                    child: const SearchHomePageWidget(),
                  ),
                ),
              ),

              // Content
              if (_isLoading)
                SliverToBoxAdapter(
                  child: Container(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Loading content...'),
                        ],
                      ),
                    ),
                  ),
                )
              else ...[
                // Test Section with Dummy Data
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TEST CONTENT:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        Text('This section should always be visible'),
                        Text('If you can see this, the home page structure is working'),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              color: Colors.blue,
                              child: Center(child: Text('Test\nImage', textAlign: TextAlign.center, style: TextStyle(color: Colors.white))),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Test Product', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('This is a test product description'),
                                  Text('\$19.99', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Banners
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BannersWidget(),
                      SizedBox(height: Dimensions.homePagePadding),
                    ],
                  ),
                ),

                // Categories
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: Dimensions.homePagePadding),
                        child: Text(
                          getTranslated('category', context)!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      SizedBox(height: Dimensions.homePagePadding),
                      const CategoryListWidget(isHomePage: true),
                      SizedBox(height: Dimensions.homePagePadding),
                    ],
                  ),
                ),

                // Latest Products section temporarily disabled to resolve build issues (non-existent widgets)

                // Featured Products section temporarily disabled

                // Top Sellers section temporarily disabled

                // Brands section temporarily disabled

                // Flash Deals section temporarily disabled

                // Featured Deals section temporarily disabled

                // Bottom Padding
                SliverToBoxAdapter(
                  child: SizedBox(height: 100),
                ),
                
                // Fallback Content Section (shows when no data is available)
                SliverToBoxAdapter(
                  child: Consumer<BannerController>(
                    builder: (context, bannerProvider, child) {
                      // Check if any data is available
                      bool hasAnyData = (bannerProvider.mainBannerList?.isNotEmpty ?? false) ||
                                      (Provider.of<CategoryController>(context, listen: false).categoryList.isNotEmpty) ||
                                      (Provider.of<ProductController>(context, listen: false).latestProductList?.isNotEmpty ?? false);
                      
                      if (!hasAnyData && !_isLoading) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            border: Border.all(color: Colors.orange),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NO DATA AVAILABLE', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 18)),
                              SizedBox(height: 16),
                              Text('It seems no data is being loaded from the APIs.'),
                              Text('This could be due to:'),
                              SizedBox(height: 8),
                              Text('• API endpoints not responding'),
                              Text('• Network connectivity issues'),
                              Text('• Data format issues'),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _refreshData,
                                child: Text('Try Again'),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// SliverDelegate for persistent header
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
