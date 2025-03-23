import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  final String userID = "1234567890";
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
}
