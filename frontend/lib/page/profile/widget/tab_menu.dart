import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:frontend/page/profile/widget/tab_menu_post.dart';

class TabMenu extends StatefulWidget {
  const TabMenu({Key? key}) : super(key: key);

  @override
  _TabMenuState createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: 3,
      vsync: this, //vsync에 this 형태로 전달해야 애니메이션이 정상 처리됨
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
          ),
          child: TabBar(
            tabs: [
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Icon(
                  Icons.grid_on,
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Icon(
                  Icons.assignment,
                ),
              ),
              Container(
                height: 50,
                alignment: Alignment.center,
                child: Icon(
                  Icons.shopping_bag_rounded,
                ),
              ),
            ],
            labelColor: Colors.white,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            indicatorColor: Colors.white,
            unselectedLabelColor: SECONDARY_COLOR,
            controller: _tabController,
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              TabMenuPost(),
              // GridView.builder(
              //     key: const PageStorageKey("GRID_VIEW"),
              //     itemCount: 1000,
              //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              //       crossAxisCount: 3,
              //     ),
              //     itemBuilder: ((context, index) {
              //       List<int> _number = [
              //         Random().nextInt(255),
              //         Random().nextInt(255),
              //         Random().nextInt(255)
              //       ];
              //       return InkWell(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => PostDetailPage()),
              //           );
              //         },
              //         child: Container(
              //           color: Color.fromRGBO(
              //               _number[0], _number[1], _number[2], 1),
              //           child: Center(
              //               child: Text(
              //             "Grid View $index",
              //             style: const TextStyle(
              //                 fontSize: 16,
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold),
              //           )),
              //         ),
              //       );
              //     })),
              Container(
                color: Colors.yellow[200],
                alignment: Alignment.center,
                child: Text(
                  'Tab1 View',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Container(
                color: Colors.green[200],
                alignment: Alignment.center,
                child: Text(
                  'Tab2 View',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
