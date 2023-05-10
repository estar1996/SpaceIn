import 'package:flutter/material.dart';
import 'package:frontend/page/homepage/home_page.dart';
import 'package:frontend/src/map/mainmap.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  // await dotenv.load(fileName: 'assets/config/.env'); // .env 파일 로드
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(clientId: '9rsbvoo9dm');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}
