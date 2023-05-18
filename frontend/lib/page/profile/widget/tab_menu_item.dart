import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/widget/tab_menu_item_detail.dart';
import 'package:frontend/page/shop/shop_detail.dart';
import 'package:frontend/page/shop/shop_page.dart';

class TabMenuItem extends StatefulWidget {
  const TabMenuItem({Key? key}) : super(key: key);

  @override
  State<TabMenuItem> createState() => _TabMenuItemState();
}

class _TabMenuItemState extends State<TabMenuItem> {
  // late PageController controller;
  List<dynamic>? userBackground;
  List<dynamic>? userSticker;
  @override
  void initState() {
    super.initState();
    _getUserItem();
  }

  Future _getUserItem() async {
    try {
      final getBackground = await ProfileApi().getUserItem();
      final getSticker = await ProfileApi().getUserSticker();
      setState(() {
        userBackground = getBackground;
        userSticker = getSticker;
      });
    } catch (error) {
      print(error);
    }
    // userInfoList = await ProfileApi().getProfile();
    // final userInfo = await userInfoList;
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // 배경 텍스트
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '배경',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 배경 이미지 리스트
            Container(
              child: SizedBox(
                height: 240,
                child: userBackground == null
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : userBackground!.isEmpty
                        ? Center(
                            child: Text(
                              '보유한 배경이 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: userBackground!.length < 10
                                ? userBackground!.length
                                : 10,
                            itemBuilder: (BuildContext context, int index) {
                              final background = userBackground![index];
                              // print(background);
                              return Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 200,
                                // height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      'assets/background/${background['itemFileName']}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '스티커',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            // 스티커 텍스트
            Expanded(
              child: Container(
                child: userSticker == null
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white))
                    : userSticker!.isEmpty
                        ? Center(
                            child: Text(
                              '보유한 스티커가 없습니다',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            // itemCount: userSticker!.length < 10
                            //     ? userSticker!.length
                            //     : 10,
                            itemCount: userSticker?.length,
                            itemBuilder: (BuildContext context, int index) {
                              final sticker = userSticker![index];
                              // print(background);
                              return Container(
                                padding: const EdgeInsets.all(5),
                                width: 120,
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    20,
                                  ),
                                  color: Colors.white.withOpacity(0.2),
                                  // image: DecorationImage(
                                  //   // scale: 0.2,
                                  //   // opacity: 0.2,
                                  //   image: AssetImage(
                                  //     'assets/${sticker['itemFileName']}',
                                  //   ),
                                  //   fit: BoxFit.cover,
                                  // ),
                                ),
                                child: Image(
                                  image: AssetImage(
                                      'assets/${sticker['itemFileName']}'),
                                ),
                              );
                            },
                          ),
              ),
            ),
            const SizedBox(height: 20),
            // 스티커 이미지 리스트
            Container(
                // child: FlutterCarousel(
                //   options: CarouselOptions(
                //     viewportFraction: 0.3,
                //     height: 100.0,
                //     initialPage: 1,
                //     showIndicator: false,
                //   ),
                //   items: imageList.map((i) {
                //     final index = imageList.indexOf(i);
                //     return Builder(
                //       builder: (BuildContext context) {
                //         return Container(
                //           // width: MediaQuery.of(context).size.width,
                //           margin: const EdgeInsets.symmetric(
                //               horizontal: 6.0, vertical: 2.0),
                //           decoration: BoxDecoration(
                //             color: Colors.white.withOpacity(0.5),
                //             border: imageHaveList[index]
                //                 ? Border.all(
                //                     color: Colors.black12,
                //                     width: 1,
                //                   )
                //                 : null,
                //             image: DecorationImage(
                //               image: AssetImage(i),
                //               fit: BoxFit.fitWidth,
                //             ),
                //             borderRadius:
                //                 const BorderRadius.all(Radius.circular(10)),
                //           ),
                //         );
                //       },
                //     );
                //   }).toList(),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
