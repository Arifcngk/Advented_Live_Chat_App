import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';
import 'package:live_chat/services/fake_auth_service.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

enum AppModde { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService =
      locator<FirebaseAuthService>();
  final FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  final FirestoreDbService _firestoreDbService = locator<FirestoreDbService>();

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
      UserModel? _user = await _firebaseAuthService.signInGoogle();
      bool result = await _firestoreDbService.saveUser(_user);
      if (result == true) {
        return _user;
      } else {
        return null;
      }
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
      UserModel? _user = await _firebaseAuthService.createEmailAndPassword(
        email,
        password,
      );
      bool result = await _firestoreDbService.saveUser(_user);
      if (result == true) {
        return _user;
      } else {
        return null;
      }
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
