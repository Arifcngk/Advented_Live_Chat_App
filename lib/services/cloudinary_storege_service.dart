import 'dart:io';
import 'package:live_chat/services/storege_base.dart';
import 'package:cloudinary/cloudinary.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CloudinaryStoregeService implements StoregeBase {
  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: dotenv.env['CLOUDINARY_API_KEY'] ?? '',
    apiSecret: dotenv.env['CLOUDINARY_API_SECRET'] ?? '',
    cloudName: dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '',
  );

  @override
  Future<String> uploadFile(
    String userID,
    String fileType,
    File uploadFile,
  ) async {
    try {
      final response = await _cloudinary.upload(
        file: uploadFile.path, // Düzeltme: fileType yerine uploadFile.path
        resourceType: CloudinaryResourceType.image,
        folder: 'user_profile_pics/', // Opsiyonel klasör
      );
      return response.secureUrl.toString(); // Yüklenen resmin URL'si
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return '';
    }
  }
}
