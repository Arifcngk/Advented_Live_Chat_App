import 'dart:io';

abstract class StoregeBase {
  Future<String> uploadFile(String userID, String fileType, File uploadFile);
}
