
import 'package:live_chat/model/user_model.dart';

abstract class AuthBase {
Future<UserModel?> currentUser();
Future<UserModel?> signInAnonymously();
Future<bool?> signOut();
}
