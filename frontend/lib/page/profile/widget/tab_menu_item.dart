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
  List<dynamic>? userData;
  @override
  void initState() {
    super.initState();
    _getUserItem();
  }

  Future _getUserItem() async {
    try {
      final userInfo = await ProfileApi().getUserItem();
      setState(() {
        userData = userInfo.data["itemList"];
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
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            // 배경 텍스트
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '배경',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                // GestureDetector(
                //   onTap: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => shopDetail(
                //           point: workPoint,
                //           type: true,
                //           imageList: bgList,
                //         ),
                //       ),
                //     );
                //   },
                //   child: const Icon(
                //     Icons.arrow_forward_ios_rounded,
                //     color: Colors.white,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20),
            // 배경 이미지 리스트
            Container(
                // padding: const EdgeInsets.all(16),
                // child: FlutterCarousel(
                //   options: CarouselOptions(
                //     // controller: CarouselController(),
                //     aspectRatio: 4 / 3,
                //     // pageSnapping: false,
                //     viewportFraction: 0.8,
                //     initialPage: 0,
                //     showIndicator: false,
                //     // disableCenter: true,
                //     // enlargeStrategy: CenterPageEnlargeStrategy.scale,
                //   ),
                //   items: bgList.map((i) {
                //     final index = bgList.indexOf(i);
                //     return Builder(
                //       builder: (BuildContext context) {
                //         return Container(
                //           width: MediaQuery.of(context).size.width,
                //           margin: const EdgeInsets.symmetric(horizontal: 6.0),
                //           decoration: BoxDecoration(
                //             image: DecorationImage(
                //               image: AssetImage(i),
                //               fit: BoxFit.cover,
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
            SizedBox(height: 20),
            // 스티커 텍스트
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '스티커',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  //아이콘 누르면 배경이나 스티커 리스트로 모달띄우기
                  // GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => TabMenuItemDetail(
                  //           textTitle: '스티커',
                  //           // type: false,
                  //           itemList: imageList,
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   child: const Icon(
                  //     Icons.arrow_forward_ios_rounded,
                  //     color: Colors.white,
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(height: 20),
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
