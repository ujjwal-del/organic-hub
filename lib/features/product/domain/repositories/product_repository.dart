import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/domain/repositories/product_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/product/enums/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class ProductRepository implements ProductRepositoryInterface{
  final DioClient? dioClient;
  ProductRepository({required this.dioClient});

  String _getGuestIdParam(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    if (authController.isLoggedIn()) {
      // If user is logged in, don't send guest_id or send empty
      return '';
    } else {
      // If user is guest, send their guest_id
      return authController.getGuestToken() ?? '1';
    }
  }

  @override
  Future<ApiResponse> getFilteredProductList(BuildContext context, String offset, ProductType productType, String? title) async {
    late String endUrl;
    final guestId = _getGuestIdParam(context);

     if(productType == ProductType.bestSelling){
      endUrl = '${AppConstants.bestSellingProductUri}$guestId&limit=10&offset=';
      title = getTranslated('best_selling', context);
    }
    else if(productType == ProductType.newArrival){
      endUrl = '${AppConstants.newArrivalProductUri}$guestId&limit=10&&offset=';
      title = getTranslated('new_arrival',context);
    }
    else if(productType == ProductType.topProduct){
      endUrl = '${AppConstants.topProductUri}$guestId&limit=10&offset=';
      title = getTranslated('top_product', context);
    }else if(productType == ProductType.discountedProduct){
       endUrl = '${AppConstants.discountedProductUri}$guestId&limit=10&&offset=';
       title = getTranslated('discounted_product', context);
     }
    
    final finalUrl = endUrl + offset;
    print('DEBUG: Product API call - URL: $finalUrl, guestId: $guestId, isLoggedIn: ${Provider.of<AuthController>(context, listen: false).isLoggedIn()}');
    
    try {
      final response = await dioClient!.get(finalUrl);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('DEBUG: Product API error: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getBrandOrCategoryProductList(bool isBrand, String id) async {
    try {
      String uri;
      if(isBrand){
        uri = '${AppConstants.brandProductUri}$id?guest_id=1';
      }else {
        uri = '${AppConstants.categoryProductUri}$id?guest_id=1';
      }
      final response = await dioClient!.get(uri);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getRelatedProductList(String id) async {
    try {
      final response = await dioClient!.get('${AppConstants.relatedProductUri}$id?guest_id=1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getFeaturedProductList(String offset) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.featuredProductUri}1&limit=10&offset=$offset',);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }



  @override
  Future<ApiResponse> getLatestProductList(String offset) async {
    try {
      final response = await dioClient!.get(
        '${AppConstants.latestProductUri}1&limit=10&&offset=$offset',);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getRecommendedProduct() async {
    try {
      final response = await dioClient!.get('${AppConstants.dealOfTheDay}1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostDemandedProduct() async {
    try {
      final response = await dioClient!.get('${AppConstants.mostDemandedProduct}1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  @override
  Future<ApiResponse> getFindWhatYouNeed() async {
    try {
      final response = await dioClient!.get(AppConstants.findWhatYouNeed);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getJustForYouProductList() async {
    try {
      final response = await dioClient!.get('${AppConstants.justForYou}1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getMostSearchingProductList(int offset) async {
    try {
      final response = await dioClient!.get("${AppConstants.mostSearching}1&limit=10&offset=$offset");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getHomeCategoryProductList() async {
    try {
      final response = await dioClient!.get('${AppConstants.homeCategoryProductUri}1');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future add(value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }



  @override
  Future getList({int? offset = 1}) {
    // TODO: implement getList
    throw UnimplementedError();
  }


  @override
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

}