import 'package:book_reader/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SplashScreenView(
        navigateRoute: const MainScreen(),
        duration: 3000,
        imageSize: 250,
        imageSrc: "assets/images/logo.png",
        text: "સોરઠિયાની સાહિત્ય સૃષ્ટિ",
        textType: TextType.TyperAnimatedText,
        textStyle: const TextStyle(
          color: Colors.black,
          fontSize: 30.0,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
