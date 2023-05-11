import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    '스토어',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '🌟15000',
                    style: TextStyle(
                        color: Color.fromARGB(255, 80, 80, 80),
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),

          // 우주인 추천
          Container(
            height: 220,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: PageIndicatorContainer(
              key: key,
              indicatorSelectorColor: const Color.fromARGB(255, 181, 154, 240),
              indicatorColor: Colors.white,
              padding: const EdgeInsets.all(25),
              align: IndicatorAlign.bottom,
              length: 3,
              indicatorSpace: 8.0,
              child: PageView(
                controller: controller,
                children: const <Widget>[
                  Image(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/ShopBanner_1.png'),
                  ),
                  Image(
                    width: 300,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/ShopBanner_2.png'),
                  ),
                  Image(
                    width: 300,
                    fit: BoxFit.fill,
                    image: AssetImage('assets/ShopBanner_3.png'),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '낙서를 더 돋보이게🌠',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: FlutterCarousel(
              options: CarouselOptions(
                viewportFraction: 0.3,
                height: 150.0,
                initialPage: 1,
                showIndicator: false,
              ),
              items: [1, 2, 3, 4, 5].map((i) {
                Color itemColor;
                if (i == 1) {
                  itemColor = Colors.amber;
                } else if (i == 2) {
                  itemColor = Colors.blue;
                } else if (i == 3) {
                  itemColor = Colors.red;
                } else if (i == 4) {
                  itemColor = Colors.green;
                } else {
                  itemColor = Colors.orange;
                }
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 6.0),
                      decoration: BoxDecoration(
                        color: itemColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Text(
                        '배경 $i',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '🎀스티커🎀',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                Icon(Icons.arrow_forward_ios_rounded),
              ],
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
