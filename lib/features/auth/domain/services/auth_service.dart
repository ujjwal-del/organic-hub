import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/repositories/auth_repository_interface.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final AuthRepoInterface authRepoInterface;

  AuthService({required this.authRepoInterface});

  // ------------------ Guest & Shared Data ------------------
  @override
  Future<bool> clearGuestId() => authRepoInterface.clearGuestId();

  @override
  Future<bool> clearSharedData() => authRepoInterface.clearSharedData();

  @override
  Future<bool> clearUserEmailAndPassword() => authRepoInterface.clearUserEmailAndPassword();

  @override
  Future<void> saveGuestId(String id) => authRepoInterface.saveGuestId(id);

  @override
  Future<void> saveUserEmailAndPassword(String email, String password) =>
      authRepoInterface.saveUserEmailAndPassword(email, password);

  @override
  Future<void> saveUserToken(String token) => authRepoInterface.saveUserToken(token);

  @override
  Future updateDeviceToken() => authRepoInterface.updateDeviceToken();

  @override
  Future getGuestId() => authRepoInterface.getGuestId();

  @override
  String? getGuestIdToken() => authRepoInterface.getGuestIdToken();

  @override
  bool isGuestIdExist() => authRepoInterface.isGuestIdExist();

  @override
  bool isLoggedIn() => authRepoInterface.isLoggedIn();

  @override
  String getUserToken() => authRepoInterface.getUserToken();

  @override
  String getUserEmail() => authRepoInterface.getUserEmail();

  @override
  String getUserPassword() => authRepoInterface.getUserPassword();

  // ------------------ Firebase Auth Login ------------------
  @override
  Future login(Map<String, dynamic> body) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: body['email'], password: body['password']);

      String? token = await userCredential.user?.getIdToken();
      await saveUserToken(token ?? '');
      await updateDeviceToken();

      // Optional: sync backend
      // await authRepoInterface.login(body);

      return {
        'success': true,
        'token': token,
        'message': 'Login successful'
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Login failed'
      };
    }
  }

  @override
  Future registration(Map<String, dynamic> body) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: body['email'], password: body['password']);

      String? token = await userCredential.user?.getIdToken();
      await saveUserToken(token ?? '');
      await updateDeviceToken();

      // Optional: sync backend
      // await authRepoInterface.registration(body);

      return {
        'success': true,
        'token': token,
        'message': 'Registration successful'
      };
    } on FirebaseAuthException catch (e) {
      return {
        'success': false,
        'message': e.message ?? 'Registration failed'
      };
    }
  }

  // ------------------ Social Login ------------------
  @override
  Future socialLogin(Map<String, dynamic> body) => authRepoInterface.socialLogin(body);

  // ------------------ OTP / Email / Phone ------------------
  @override
  Future sendOtpToEmail(String email, String token) =>
      authRepoInterface.sendOtpToEmail(email, token);

  @override
  Future resendEmailOtp(String email, String token) =>
      authRepoInterface.resendEmailOtp(email, token);

  @override
  Future verifyEmail(String email, String code, String token) =>
      authRepoInterface.verifyEmail(email, code, token);

  @override
  Future sendOtpToPhone(String phone, String token) =>
      authRepoInterface.sendOtpToPhone(phone, token);

  @override
  Future resendPhoneOtp(String phone, String token) =>
      authRepoInterface.resendPhoneOtp(phone, token);

  @override
  Future verifyPhone(String phone, String otp, String token) =>
      authRepoInterface.verifyPhone(phone, otp, token);

  @override
  Future verifyOtp(String otp, String identity) =>
      authRepoInterface.verifyOtp(otp, identity);

  // ------------------ Password Management ------------------
  @override
  Future forgetPassword(String identity) =>
      authRepoInterface.forgetPassword(identity);

  @override
  Future resetPassword(String otp, String identity, String password, String confirmPassword) =>
      authRepoInterface.resetPassword(otp, identity, password, confirmPassword);

  // ------------------ Logout ------------------
  @override
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    return authRepoInterface.logout();
  }

  // ------------------ Language ------------------
  @override
  Future setLanguageCode(String code) => authRepoInterface.setLanguageCode(code);
}
