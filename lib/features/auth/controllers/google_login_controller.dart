import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleSignInController with ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  
  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;
  UserCredential? userCredential;
  bool isLoading = false;
  String? errorMessage;

  // Enhanced Google Sign-In with Firebase Auth for version 6.1.6
  Future<UserCredential?> signInWithGoogle() async {
    try {
      setLoading(true);
      errorMessage = null;
      
      print('Google Sign-In: Starting authentication flow...');
      
      // 1. Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      // 2. If the user cancels, return null
      if (googleUser == null) {
        print('Google Sign-In: User cancelled');
        setLoading(false);
        return null;
      }

      print('Google Sign-In: Got Google account - ID: ${googleUser.id}, Email: ${googleUser.email}');

      // 3. Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      print('Google Sign-In: Got authentication - Access Token: ${googleAuth.accessToken?.substring(0, 20)}..., ID Token: ${googleAuth.idToken?.substring(0, 20)}...');

      // 4. Create a new credential for Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 5. Sign in to Firebase with the credential
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      
      print('Google Sign-In: Firebase authentication successful');
      
      // 6. Store the result
      this.userCredential = userCredential;
      googleAccount = googleUser;
      auth = googleAuth;
      
      print('Google Sign-In: Stored details - Google Account: ${googleAccount?.id}, Auth: ${auth?.accessToken?.substring(0, 20)}...');
      
      setLoading(false);
      notifyListeners(); // Make sure to notify listeners
      
      return userCredential;

    } catch (e) {
      setLoading(false);
      errorMessage = e.toString();
      notifyListeners();
      print("Error during Google sign-in: $e");
      return null;
    }
  }

  // Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      
      googleAccount = null;
      auth = null;
      userCredential = null;
      
      notifyListeners();
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  // Check if user is signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  // Get current user
  User? get currentUser => _firebaseAuth.currentUser;

  // Set loading state
  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  // Clear error message
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}
