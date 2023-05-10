import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late PageController controller;

  GlobalKey<PageContainerState> key = GlobalKey();

  @override
  void initState() {
    super.initState();
    controller = PageController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      appBar: AppBar(
        title: const Text(
          '스토어',
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white.withOpacity(0),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 인기순위
          Container(
            height: 200,
            padding: const EdgeInsets.all(16),
            child: PageIndicatorContainer(
              key: key,
              align: IndicatorAlign.bottom,
              length: 3,
              indicatorSpace: 10.0,
              child: PageView(
                controller: controller,
                children: const <Widget>[
                  Image(
                    image: AssetImage('assets/ShopBanner_1.png'),
                  ),
                  Image(
                    image: AssetImage('assets/ShopBanner_2.png'),
                  ),
                  Image(
                    image: AssetImage('assets/ShopBanner_3.png'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              '낙서를 더 돋보이게',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: const Text(
              '스티커',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // 이미지 리스트
        ],
      ),
    );
  }
}

// 에셋에서 불러올 이미지 리스트
List<String> assetImages = [
  'assets/Asteroid.png',
  'assets/Astronaut-1.png',
  'assets/Planet-1.png'

  // 추가적인 이미지 경로를 여기에 추가할 수 있습니다.
];
