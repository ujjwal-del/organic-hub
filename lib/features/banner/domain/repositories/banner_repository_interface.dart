import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';

abstract class BannerRepositoryInterface {
  Future<ApiResponse> getList(BuildContext context);
  Future<ApiResponse> getSellerWiseBannerList(int sellerId);
}