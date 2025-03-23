import 'package:flutter/material.dart';
import 'package:live_chat/constant/app/locator.dart';
import 'package:live_chat/screen/landing_view_screnn.dart';
import 'package:live_chat/constant/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: buildAppTheme(),
      home: LandingViewScreen(),
    );
  }
}
