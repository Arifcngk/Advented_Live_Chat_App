import 'package:live_chat/model/user_model.dart';

abstract class DatabaseBase {
  Future<bool> saveUser(UserModel? user);
}
