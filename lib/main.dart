import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/screen/landing_view_screnn.dart';
import 'package:live_chat/constant/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:live_chat/viewmodel/user_view_model.dart';

void main() async {
  await dotenv.load(fileName: ".env"); // .env dosyasını yükle
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(), // ViewModel Tanımlanması
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: buildAppTheme(),
        home: LandingViewScreen(),
      ),
    );
  }
}
