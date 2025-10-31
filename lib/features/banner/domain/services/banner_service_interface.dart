import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/repositories/banner_repository_interface.dart';

abstract class BannerServiceInterface {
  Future<ApiResponse> getList(BuildContext context);
  Future<ApiResponse> getSellerWiseBannerList(int sellerId);
}