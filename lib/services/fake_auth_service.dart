import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  final String userID = "123456789052";
  @override
  Future<UserModel?> currentUser() async {
    return await Future.delayed(
      Duration(seconds: 1),
      () => UserModel(userID: userID),
    );
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(userID: userID),
    );
  }

  @override
  Future<bool?> signOut() async {
    return Future.value(true);
  }
  
  @override
  Future<UserModel> signInGoogle() {
    // TODO: implement signInGoogle
    throw UnimplementedError();
  }
  

  @override
  Future<UserModel?> createEmailAndPassword(String email, String password) {
    // TODO: implement createEmailAndPassword
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel?> sigInEmailAndPassword(String email, String password) {
    // TODO: implement sigInEmailAndPassword
    throw UnimplementedError();
  }
}
