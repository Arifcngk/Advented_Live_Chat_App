import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_chat/constant/app/firebase_exeption_handler.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    return user == null ? null : UserModel(userID: user.uid, email: user.email);
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print(
        'Hata: Firebase Auth Service - currentUser: ${FirebaseExceptionHandler.handleGenericException(e as Exception)}',
      );
      return null;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print(
        'Hata: Firebase Auth Service - signInAnonymously: ${FirebaseExceptionHandler.handleGenericException(e as Exception)}',
      );
      return null;
    }
  }

  Future<UserModel?> signInGoogle() async {
    try {
      GoogleSignIn _googleSignin = GoogleSignIn();
      GoogleSignInAccount? _googleUser = await _googleSignin.signIn();
      if (_googleUser == null) return null;

      var _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken == null || _googleAuth.accessToken == null)
        return null;

      UserCredential result = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        ),
      );

      return _userFromFirebase(result.user);
    } catch (e) {
      print(
        'Hata: Firebase Auth Service - signInGoogle: ${FirebaseExceptionHandler.handleGenericException(e as Exception)}',
      );
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(
        'Hata: Firebase Auth Service - signOut: ${FirebaseExceptionHandler.handleGenericException(e as Exception)}',
      );
      return false;
    }
  }

  @override
  Future<UserModel?> createEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      print(
        'Hata: Firebase Auth Service - Create User: ${FirebaseExceptionHandler.handleFirebaseAuthException(e)}',
      );
      return null;
    }
  }

  @override
  Future<UserModel?> sigInEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      print(
        'Hata: Firebase Auth Service - Signin Email and Password User: ${FirebaseExceptionHandler.handleFirebaseAuthException(e)}',
      );
      throw Exception(
        FirebaseExceptionHandler.handleFirebaseAuthException(e),
      ); // Hata mesajını fırlat
    }
  }
}
