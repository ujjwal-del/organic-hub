import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';

abstract class CategoryRepoInterface {
  Future<ApiResponse> getList(BuildContext context);
  Future<ApiResponse> getSellerWiseCategoryList(int sellerId);
}