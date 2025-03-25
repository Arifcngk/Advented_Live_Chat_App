import 'package:get_it/get_it.dart';
import 'package:live_chat/repository/user_repo.dart';
import 'package:live_chat/services/cloudinary_storege_service.dart';
import 'package:live_chat/services/fake_auth_service.dart';
import 'package:live_chat/services/firebase_auth_service.dart';
import 'package:live_chat/services/firebase_storege_service.dart';
import 'package:live_chat/services/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => FirebaseStoregeService());
  locator.registerLazySingleton(() => CloudinaryStoregeService());
}
