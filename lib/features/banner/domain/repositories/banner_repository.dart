import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/dio/dio_client.dart';
import 'package:flutter_sixvalley_ecommerce/data/datasource/remote/exception/api_error_handler.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:provider/provider.dart';

class BannerRepository implements BannerRepositoryInterface{
  final DioClient? dioClient;
  BannerRepository({required this.dioClient});

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
  Future<ApiResponse> getList(BuildContext context) async {
    try {
      final guestId = _getGuestIdParam(context);
      final url = '${AppConstants.getBannerList}?guest_id=$guestId';
      print('DEBUG: Banner API call - URL: $url, guestId: $guestId, isLoggedIn: ${Provider.of<AuthController>(context, listen: false).isLoggedIn()}');
      final response = await dioClient!.get(url);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print('DEBUG: Banner API error: $e');
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  @override
  Future<ApiResponse> getSellerWiseBannerList(int sellerId) async {
    try {
      final response = await dioClient!.get('${AppConstants.getBannerList}?seller_id=$sellerId');
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
  Future update(Map<String, dynamic> body, int id) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future get(String id) {
    // TODO: implement get
    throw UnimplementedError();
  }
}