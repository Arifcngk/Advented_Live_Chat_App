import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:live_chat/services/storege_base.dart';

class FirebaseStoregeService implements StoregeBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<String> uploadFile(
    String userID,
    String fileType,
    File uploadFile,
  ) async {
    try {
      // Dosya adını benzersiz yapmak için timestamp ekliyoruz.
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

      // Depolama referansını oluşturuyoruz.
      Reference storageRef = _firebaseStorage.ref().child("users/$userID/$fileType/$fileName");

      // Dosyayı Firebase Storage'a yüklüyoruz.
      UploadTask uploadTask = storageRef.putFile(uploadFile);
      TaskSnapshot snapshot = await uploadTask;

      // Dosya başarıyla yüklendi mi kontrol edelim.
      if (snapshot.state == TaskState.success) {
        String downloadURL = await snapshot.ref.getDownloadURL();
        print("Dosya başarıyla yüklendi: $downloadURL");
        return downloadURL;
      } else {
        print("Dosya yüklenirken bir hata oluştu!");
        return "";
      }
    } catch (e) {
      print("Dosya yükleme hatası: $e");
      return "";
    }
  }
}
