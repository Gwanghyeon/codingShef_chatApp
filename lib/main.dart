import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // 플러터 코어 엔진의 초기화, 파이어베이스를 사용하기 위한 사전 작업
  WidgetsFlutterBinding.ensureInitialized();
  // 위의 함수를 통해 Firebase.initializeApp 사용 가능
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginSignUpScreen(),
    );
  }
}
