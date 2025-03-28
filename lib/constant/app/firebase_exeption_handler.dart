import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class FirebaseExceptionHandler {
  static String handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Geçersiz e-posta adresi!';
      case 'user-disabled':
        return 'Bu hesap devre dışı bırakılmış.';
      case 'user-not-found':
        return 'Bu e-posta ile kayıtlı kullanıcı bulunamadı.';
      case 'wrong-password':
        return 'Yanlış şifre girdiniz!';
      case 'email-already-in-use':
        return 'Bu e-posta adresi zaten kullanımda.';
      case 'operation-not-allowed':
        return 'Bu işlem şu anda devre dışı.';
      case 'weak-password':
        return 'Şifreniz çok zayıf, lütfen daha güçlü bir şifre seçin.';
      default:
        return 'Bilinmeyen bir hata oluştu: ${e.message}';
    }
  }

  static String handleFirebaseFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return 'Bu işlemi gerçekleştirmek için yetkiniz yok.';
      case 'not-found':
        return 'Belirtilen veri bulunamadı.';
      case 'unavailable':
        return 'Sunucu şu anda kullanılamıyor, lütfen daha sonra tekrar deneyin.';
      default:
        return 'Firestore hatası: ${e.message}';
    }
  }

  static String handleGenericException(Exception e) {
    if (e is PlatformException) {
      return 'Platform hatası: ${e.message}';
    } else {
      return 'Bilinmeyen bir hata oluştu: $e';
    }
  }
}
