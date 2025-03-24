
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/fake_auth_service.dart';
import 'package:live_chat/services/firebase_auth_service.dart';

enum AppModde { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  // Uygulama Hangi modda başlatılsın ?
  AppModde appModde = AppModde.RELEASE;
  @override
  Future<UserModel?> currentUser() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      return _firebaseAuthService.currentUser();
    }
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<bool?> signOut() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return _firebaseAuthService.signOut();
    }
  }

  @override
  Future<UserModel?> signInGoogle() async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.signInGoogle();
    } else {
      return _firebaseAuthService.signInGoogle();
    }
  }

  @override
  Future<UserModel?> createEmailAndPassword(
    String email,
    String password,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.createEmailAndPassword(email, password);
    } else {
      return _firebaseAuthService.createEmailAndPassword(email, password);
    }
  }

  @override
  Future<UserModel?> sigInEmailAndPassword(
    String email,
    String password,
  ) async {
    if (appModde == AppModde.DEBUG) {
      return await _fakeAuthService.sigInEmailAndPassword(email, password);
    } else {
      return _firebaseAuthService.sigInEmailAndPassword(email, password);
    }
  }
}
