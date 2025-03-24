import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:live_chat/model/user_model.dart';
import 'package:live_chat/services/database_base.dart';

class FirestoreDbService implements DatabaseBase {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(UserModel? user) async {
    if (user == null || user.userID.isEmpty) {
      print('Hata: Kullanıcı bilgisi geçersiz!');
      return false;
    }

    try {
      await _firebaseFirestore
          .collection('users')
          .doc(user.userID)
          .set(user.toMap());

      DocumentSnapshot<Map<String, dynamic>> _readUser =
          await _firebaseFirestore.collection('users').doc(user.userID).get();

      Map<String, dynamic>? readResult = _readUser.data();

      if (readResult == null) {
        print('Hata: Kullanıcı Firestore\'dan okunamadı!');
        return false;
      }

      UserModel _readUserInfo = UserModel.fromMap(readResult);
      print('Firestore\'dan okunan kullanıcı: ${_readUserInfo.email}');

      return true;
    } catch (e) {
      print('Firestore saveUser hatası: $e');
      return false;
    }
  }
}
