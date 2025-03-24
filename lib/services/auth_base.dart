import 'package:live_chat/model/user_model.dart';

abstract class AuthBase {
  // userları getir
  Future<UserModel?> currentUser();
  // anonim bir user oluştur
  Future<UserModel?> signInAnonymously();
  // google ile giriş yap
  Future<UserModel?> signInGoogle();
  // email ve şifre ile giriş yap
  Future<UserModel?> sigInEmailAndPassword(String email, String password);
  Future<UserModel?> createEmailAndPassword(String email, String password);

  //hesaptan çık
  Future<bool?> signOut();
}
