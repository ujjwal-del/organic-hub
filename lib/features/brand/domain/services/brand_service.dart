import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/repositories/brand_repo_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/brand/domain/services/brand_service_interface.dart';

class BrandService implements BrandServiceInterface{
  BrandRepoInterface brandRepoInterface;
  BrandService({required this.brandRepoInterface});

  @override
  Future<ApiResponse> getList(BuildContext context) async{
    return await brandRepoInterface.getList(context);
  }

  @override
  Future<ApiResponse> getSellerWiseBrandList(int sellerId) {
    return brandRepoInterface.getSellerWiseBrandList(sellerId);
  }

}