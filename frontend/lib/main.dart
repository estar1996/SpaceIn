import 'package:flutter/material.dart';
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

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Stack(
        children: [
          //SHOP PAGE
          Positioned(
            top: 50,
            left: 50,
            width: 300,
            height: 300,
            child: IconButton(
              icon: Image.asset('assets/SolarSystem.png'),
              onPressed: () {
                // 클릭 시 이동할 페이지
              },
            ),
          ),
          //MY PAGE
          Positioned(
            top: 300,
            left: 300,
            width: 100,
            height: 100,
            child: IconButton(
              icon: Image.asset('assets/Rocket-2.png'),
              onPressed: () {
                // 클릭 시 이동할 페이지
              },
            ),
          ),
          //MAP PAGE
          Positioned(
            top: 600,
            left: 150,
            width: 300,
            height: 300,
            child: IconButton(
              icon: Image.asset('assets/Planet-2.png'),
              onPressed: () {
                // 클릭 시 이동할 페이지
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MainMap()));
              },
            ),
          ),
          // WRITE PAGE
          Positioned(
            top: 300,
            left: 000,
            width: 300,
            height: 300,
            child: IconButton(
              icon: Image.asset('assets/Telescope.png'),
              onPressed: () {
                // 클릭 시 이동할 페이지
              },
            ),
          ),
        ],
      ),
    );
  }
}
