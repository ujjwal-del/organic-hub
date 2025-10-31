import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/repositories/banner_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/banner/domain/services/banner_service_interface.dart';

class BannerService implements BannerServiceInterface{
  BannerRepositoryInterface bannerRepositoryInterface;
  BannerService({required this.bannerRepositoryInterface});

  @override
  Future<ApiResponse> getList(BuildContext context) async{
    return await bannerRepositoryInterface.getList(context);
  }

  @override
  Future<ApiResponse> getSellerWiseBannerList(int sellerId) async{
    return await bannerRepositoryInterface.getSellerWiseBannerList(sellerId);
  }
}