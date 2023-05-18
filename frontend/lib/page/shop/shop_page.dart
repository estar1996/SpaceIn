import 'package:flutter/material.dart';
import 'package:page_indicator/page_indicator.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:frontend/page/shop/shop_detail.dart';
import 'package:frontend/page/shop/shop_bottom.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/secure_storage.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  late PageController controller;

  GlobalKey<PageContainerState> key = GlobalKey();

  List<Map<String, dynamic>> imageList = [];

  List<bool> imageHaveList = [];

  List<Map<String, dynamic>> bgList = [];

  List<bool> bgHaveList = [];

  late int workPoint = 0;

  final dio = Dio();

  @override
  void initState() {
    super.initState();
    controller = PageController();

    checkItem();
  }

  void checkItem() async {
    Response response;
    final token = await SecureStorage().getAccessToken();
    // print('이게 토큰이야 $token');

    response = await dio.get(
      'http://k8a803.p.ssafy.io:8080/shop/checkitem',
      options: Options(headers: {'Authorization': token}),
    );

    setState(() {
      workPoint = response.data['userMoney'];

      for (Map<String, dynamic> dt in response.data['itemList']) {
        if (!dt['haveItem']) {
          if (dt['itemFileName'][0] == 'b' && dt['itemFileName'][1] == 'g') {
            // print('이거 bg $dt');
            bgList.add(dt);
          } else {
            // print('이건 image $dt');
            imageList.add(dt);
          }
        }
      }
    });
    // print('이게 지금 데이터야 ${response.data['itemList']}');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  //  int itemId
  void buyItem(int price, int itemId, bool type) async {
    Map<String, int> requestBody = {
      'itemId': itemId,
    };

    if (type) {
      for (int i = 0; i < bgList.length; i++) {
        if (bgList[i]['itemId'] == itemId) {
          setState(() {
            bgList.removeAt(i);
          });
        }
      }
    } else {
      for (int i = 0; i < imageList.length; i++) {
        if (imageList[i]['itemId'] == itemId) {
          setState(() {
            imageList.removeAt(i);
          });
        }
      }
    }

    final token = await SecureStorage().getAccessToken();

    // print('이게 토큰이야 $token');
    Response response =
        await dio.post('http://k8a803.p.ssafy.io:8080/shop/buyitem',
            data: requestBody,
            options: Options(
              headers: {'Authorization': token},
            ));

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
                  // final index = bgList.indexOf(i);
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
                                // .itemName
                                address: i['itemFileName'],
                                buyItem: buyItem,
                                // .itemPrice
                                price: i['itemPrice'],
                                itemId: i['itemId'],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(horizontal: 6.0),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // i.itemName
                              image: AssetImage(
                                  'assets/background/${i['itemFileName']}'),
                              fit: BoxFit.cover,
                              // i.haveItem
                              colorFilter: !i['haveItem']
                                  ? ColorFilter.mode(
                                      Colors.black.withOpacity(0.5),
                                      BlendMode.darken)
                                  : null,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          // i.haveItem
                          child: !i['haveItem']
                              ? Center(
                                  child: Text(
                                    '🌟 ${i['itemPrice']}',
                                    style: const TextStyle(
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
                                // i.itemName
                                address: i['itemFileName'],
                                buyItem: buyItem,
                                // i.itemPrice
                                price: i['itemPrice'],
                                // itemId: i.itemId
                                itemId: i['itemId'],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            // i.haveItem
                            border: i['haveItem']
                                ? Border.all(
                                    color: Colors.black12,
                                    width: 1,
                                  )
                                : null,
                            image: DecorationImage(
                              image: AssetImage('assets/${i['itemFileName']}'),
                              fit: BoxFit.fitWidth,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Stack(
                            children: [
                              // i.haveItem
                              if (!i['haveItem'])
                                Opacity(
                                  opacity: 0.5,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                  ),
                                ),
                              // i.haveItem
                              if (!i['haveItem'])
                                Center(
                                  child: Text(
                                    '🌟 ${i['itemPrice']}',
                                    style: const TextStyle(
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
