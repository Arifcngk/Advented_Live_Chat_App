import 'dart:io';

import 'package:live_chat/services/storege_base.dart';
import 'package:cloudinary/cloudinary.dart';

class CloudinaryStoregeService implements StoregeBase {
  final Cloudinary _cloudinary = Cloudinary.signedConfig(
    apiKey: 'cKjjk0MO3-GPr_iLmALQDr1dbhA',
    apiSecret: '833536691621619',
    cloudName: 'djcistcf8',
  );

  @override
  Future<String> uploadFile(
    String userID,
    String fileType,
    File uploadFile,
  ) async {
    try {
      final response = await _cloudinary.upload(
        file: fileType,
        resourceType: CloudinaryResourceType.image,
        folder:
            'user_profile_pics/', // opsiyonel, istediğiniz klasörü belirleyebilirsiniz
      );
      return response.secureUrl.toString(); // Yüklenen resmin URL'si
    } catch (e) {
      print('Resim yükleme hatası: $e');
      return '';
    }
  }
}
