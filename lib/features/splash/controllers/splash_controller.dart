import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/models/config_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/domain/services/splash_service_interface.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class SplashController extends ChangeNotifier {
  final SplashServiceInterface? splashServiceInterface;
  SplashController({required this.splashServiceInterface});

  ConfigModel? _configModel;
  BaseUrls? _baseUrls;
  CurrencyList? _myCurrency;
  CurrencyList? _usdCurrency;
  CurrencyList? _defaultCurrency;
  int? _currencyIndex;
  bool _hasConnection = true;
  bool _fromSetting = false;
  bool _firstTimeConnectionCheck = true;
  bool _onOff = true;
  bool get onOff => _onOff;

  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;
  CurrencyList? get myCurrency => _myCurrency;
  CurrencyList? get usdCurrency => _usdCurrency;
  CurrencyList? get defaultCurrency => _defaultCurrency;
  int? get currencyIndex => _currencyIndex;
  bool get hasConnection => _hasConnection;
  bool get fromSetting => _fromSetting;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;

  Future<bool> initConfig(BuildContext context) async {
    _hasConnection = true;

    if (splashServiceInterface == null) {
      debugPrint("❌ ERROR: SplashServiceInterface is null");
      return false;
    }

    debugPrint("🔍 initConfig: Starting /api/v1/config request...");

    ApiResponse apiResponse;

    // ✅ Add Timeout Protection (10 seconds)
    try {
      apiResponse = await splashServiceInterface!
          .getConfig()
          .timeout(const Duration(seconds: 10));
    } on TimeoutException {
      debugPrint("⏰ CONFIG API TIMED OUT – Skipping config load");
      _hasConnection = false;
      notifyListeners();
      return false;
    } catch (e) {
      debugPrint("❌ CONFIG API CRASHED: $e");
      _hasConnection = false;
      notifyListeners();
      return false;
    }

    bool isSuccess;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      debugPrint("✅ CONFIG API SUCCESS");
      debugPrint("🔹 Status Code: ${apiResponse.response!.statusCode}");
      debugPrint("🔹 Raw Data: ${apiResponse.response!.data}");

      _configModel = ConfigModel.fromJson(apiResponse.response!.data);
      _baseUrls = _configModel!.baseUrls;

      String? currencyCode = splashServiceInterface!.getCurrency();
      for (CurrencyList currencyList in _configModel!.currencyList!) {
        if (currencyList.id == _configModel!.systemDefaultCurrency) {
          if (currencyCode == null || currencyCode.isEmpty) {
            currencyCode = currencyList.code;
          }
          _defaultCurrency = currencyList;
        }
        if (currencyList.code == 'USD') {
          _usdCurrency = currencyList;
        }
      }

      getCurrencyData(currencyCode);
      debugPrint("💰 Default Currency: ${_defaultCurrency?.code}");
      debugPrint("💰 USD Currency: ${_usdCurrency?.code}");
      debugPrint("💰 Current Currency: ${_myCurrency?.code}");
      isSuccess = true;
    } else {
      debugPrint("❌ CONFIG API FAILED");
      debugPrint("🔹 Error: ${apiResponse.error}");
      debugPrint("🔹 Full Response: ${apiResponse.response}");

      isSuccess = false;
      ApiChecker.checkApi(apiResponse);

      if (apiResponse.error.toString() ==
          'Connection to API server failed due to internet connection') {
        _hasConnection = false;
      }
    }

    notifyListeners();
    return isSuccess;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void getCurrencyData(String? currencyCode) {
    if (_configModel == null || _configModel!.currencyList == null) {
      debugPrint("❌ ERROR: ConfigModel or currencyList is null");
      return;
    }
    for (var currency in _configModel!.currencyList!) {
      if (currencyCode == currency.code) {
        _myCurrency = currency;
        _currencyIndex = _configModel!.currencyList!.indexOf(currency);
        continue;
      }
    }
  }

  void setCurrency(int index) {
    if (splashServiceInterface == null || _configModel == null) {
      debugPrint("❌ ERROR: Service or config is null");
      return;
    }
    splashServiceInterface!.setCurrency(_configModel!.currencyList![index].code!);
    getCurrencyData(_configModel!.currencyList![index].code);
    notifyListeners();
  }

  void initSharedPrefData() {
    if (splashServiceInterface == null) {
      debugPrint("❌ ERROR: SplashServiceInterface is null");
      return;
    }
    splashServiceInterface!.initSharedData();
  }

  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  bool? showIntro() {
    if (splashServiceInterface == null) {
      debugPrint("❌ ERROR: SplashServiceInterface is null");
      return null;
    }
    return splashServiceInterface!.showIntro();
  }

  void disableIntro() {
    if (splashServiceInterface == null) {
      debugPrint("❌ ERROR: SplashServiceInterface is null");
      return;
    }
    splashServiceInterface!.disableIntro();
  }

  void changeAnnouncementOnOff(bool on) {
    _onOff = !_onOff;
    notifyListeners();
  }
}
