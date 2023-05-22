import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/page/login/login_page.dart';

void main() async {
  // await dotenv.load(fileName: 'assets/config/.env'); // .env 파일 로드
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: '9rsbvoo9dm');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool back = false;
  // int time = 0;
  // int duration = 1000;
  // Future<bool> willPop() async {
  //   int now = DateTime.now().millisecondsSinceEpoch;
  //   if (Navigator.of(context).canPop()) {
  //     return true;
  //   } else if (back && time >= now) {
  //     back = false;
  //     exit(0);
  //   } else {
  //     time = DateTime.now().millisecondsSinceEpoch + duration;
  //     print("again tap");
  //     back = true;
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text("Press again the button to exit")));
  //   }
  //   return false;
  // }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
