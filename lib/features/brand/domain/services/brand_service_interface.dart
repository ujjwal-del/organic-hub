import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';

abstract class BrandServiceInterface {
  Future<ApiResponse> getList(BuildContext context);
  Future<ApiResponse> getSellerWiseBrandList(int sellerId);
}