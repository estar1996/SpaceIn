import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:frontend/page/shop/shop_detail.dart';
import 'package:frontend/page/shop/shop_bottom.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late PageController controller;

  GlobalKey<PageContainerState> key = GlobalKey();

  List<String> imageList = [
    'assets/Asteroid.png',
    'assets/Astronaut-1.png',
    'assets/Astronaut-2.png',
    'assets/Astronaut-3.png',
    'assets/Astronaut-4.png',
    'assets/Comet.png',
    'assets/Planet & Rocket.png',
    'assets/Planet-1.png',
    'assets/Planet-2.png',
    'assets/Planet-3.png',
    'assets/Planet-4.png',
    'assets/Planet-5.png',
    'assets/Planet-6.png',
    'assets/Planet-7.png',
    'assets/Planet-8.png',
    'assets/Planet-9.png',
    'assets/Planet-10.png',
    'assets/Planet-11.png',
    'assets/Planet-12.png',
    'assets/Planet-13.png',
    'assets/Planet-14.png',
    'assets/Planet-15.png',
    'assets/Rocket-1.png',
    'assets/Rocket-2.png',
    'assets/Rover.png',
    'assets/SolarSystem.png',
    'assets/SpaceSatellite.png',
    'assets/SpaceShip-1.png',
    'assets/SpaceShip-2.png',
    'assets/Star1.png',
    'assets/Star2_1.png',
    'assets/Star2_2.png',
    'assets/Star2_3.png',
    'assets/Star2_4.png',
    'assets/Star2_5.png',
    'assets/Star2.png',
    'assets/Telescope.png',
    'assets/UFO.png',
  ];

  List<bool> imageHaveList = [];

  List<String> bgList = [
    'assets/background/bg_bluered.png',
    'assets/background/bg_box.png',
    'assets/background/bg_check.png',
    'assets/background/bg_check2.png',
    'assets/background/bg_cute.png',
    'assets/background/bg_flower.png',
    'assets/background/bg_gradient.png',
    'assets/background/bg_gradient2.png',
    'assets/background/bg_greenaura.png',
    'assets/background/bg_letter.png',
    'assets/background/bg_letter2.png',
    'assets/background/bg_line.png',
    'assets/background/bg_mountain.png',
    'assets/background/bg_newspaper.png',
    'assets/background/bg_night.png',
    'assets/background/bg_ocean.png',
    'assets/background/bg_pearl.png',
    'assets/background/bg_photoedit.png',
    'assets/background/bg_photoedit2.png',
    'assets/background/bg_sky.png',
    'assets/background/bg_sky2.png',
    'assets/background/bg_twinkle.png',
    'assets/background/pg_paper.png',
    'assets/background/whiteSpace.png',
  ];

  List<bool> bgHaveList = [];

  int workPoint = 1500;

  @override
  void initState() {
    super.initState();
    controller = PageController();

    for (int i = 0; i < imageList.length; i++) {
      imageHaveList.add(false);
    }

    for (int i = 0; i < bgList.length; i++) {
      bgHaveList.add(false);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void buyItem(int price) {
    setState(() {
      workPoint -= price;
    });
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      '스토어',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '🌟 $workPoint',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 80, 80, 80),
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),

            // 우주인 추천
            Container(
              height: 220,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
              child: PageIndicatorContainer(
                key: key,
                indicatorSelectorColor:
                    const Color.fromARGB(255, 181, 154, 240),
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
                children: [
                  const Text(
                    '낙서를 더 돋보이게🌠',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => shopDetail(
                            point: workPoint,
                            type: true,
                            imageList: bgList,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  ),
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
                items: bgList.map((i) {
                  final index = bgList.indexOf(i);
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            backgroundColor:
                                const Color.fromARGB(255, 190, 112, 201),
                            context: context,
                            builder: (BuildContext context) {
                              return shopBottom(
                                address: i,
                                buyItem: buyItem,
                                price: 10,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(i),
                              fit: BoxFit.cover,
                              colorFilter: !bgHaveList[index]
                                  ? ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.darken)
                                  : null,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: !bgHaveList[index]
                              ? const Center(
                                  child: Text(
                                    '🌟 10',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
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
                children: [
                  const Text(
                    '🎀스티커🎀',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => shopDetail(
                            point: workPoint,
                            type: false,
                            imageList: imageList,
                          ),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_forward_ios_rounded),
                  )
                ],
              ),
            ),
            // 이미지 리스트
            Container(
              padding: const EdgeInsets.all(16),
              child: FlutterCarousel(
                options: CarouselOptions(
                  viewportFraction: 0.3,
                  height: 150.0,
                  initialPage: 1,
                  showIndicator: false,
                ),
                items: imageList.map((i) {
                  final index = imageList.indexOf(i);
                  return Builder(
                    builder: (BuildContext context) {
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )),
                            backgroundColor:
                                const Color.fromARGB(255, 190, 112, 201),
                            context: context,
                            builder: (BuildContext context) {
                              return shopBottom(
                                address: i,
                                buyItem: buyItem,
                                price: 10,
                              );
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            border: imageHaveList[index]
                                ? Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  )
                                : null,
                            image: DecorationImage(
                              image: AssetImage(i),
                              fit: BoxFit.fitWidth,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Stack(
                            children: [
                              if (!imageHaveList[index])
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              if (!imageHaveList[index])
                                const Center(
                                  child: Text(
                                    '🌟 10',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
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
