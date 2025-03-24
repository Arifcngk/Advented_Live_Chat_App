import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(userID: user.uid, email: user.email);
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      User? user = _firebaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print('Hata: Firebase Auth Service - currentUser: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      return _userFromFirebase(result.user);
    } catch (e) {
      print('Hata: Firebase Auth Service - signInAnonymously: $e');
      return null;
    }
  }

  Future<UserModel?> signInGoogle() async {
    try {
      GoogleSignIn _googleSignin = GoogleSignIn();
      print("Google Sign-In başlatılıyor...");
      GoogleSignInAccount? _googleUser = await _googleSignin.signIn();

      if (_googleUser == null) {
        print("Google Sign-In iptal edildi veya başarısız oldu.");
        return null;
      }

      print("Google Kullanıcı: ${_googleUser.email}");
      var _googleAuth = await _googleUser.authentication;

      if (_googleAuth.idToken == null || _googleAuth.accessToken == null) {
        print(
          "Google Auth token’ları alınamadı: idToken=${_googleAuth.idToken}, accessToken=${_googleAuth.accessToken}",
        );
        return null;
      }

      print(
        "Google Auth token’ları alındı: idToken=${_googleAuth.idToken?.substring(0, 10)}..., accessToken=${_googleAuth.accessToken?.substring(0, 10)}...",
      );
      UserCredential result = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: _googleAuth.accessToken,
          idToken: _googleAuth.idToken,
        ),
      );

      User? _user = result.user;
      print("Firebase Kullanıcı: ${_user?.email}");
      return _userFromFirebase(_user);
    } catch (e) {
      print('Hata: Firebase Auth Service - signInGoogle: $e');
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print('Hata: Firebase Auth Service - signOut: $e');
      return false;
    }
  }

  @override
  Future<UserModel?> createEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } catch (e) {
      print('Hata: Firebase Auth Service - Create User: $e');
      return null;
    }
  }

  @override
  Future<UserModel?> sigInEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebase(result.user);
    } on FirebaseAuthException catch (e) {
      print('Hata: Firebase Auth Service - Signin Email and Password User: $e');

      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = "Bu e-posta ile kayıtlı bir kullanıcı bulunamadı!";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Hatalı şifre girdiniz!";
      } else if (e.code == 'invalid-email') {
        errorMessage = "Geçersiz e-posta adresi!";
      } else {
        errorMessage = "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.";
      }

      throw Exception(errorMessage); // Hata mesajını fırlat
    }
  }
}
