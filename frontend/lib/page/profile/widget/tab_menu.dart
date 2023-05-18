import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:frontend/page/profile/widget/tab_menu_item.dart';
import 'package:frontend/page/profile/widget/tab_menu_mission.dart';
import 'package:frontend/page/profile/widget/tab_menu_post.dart';

class TabMenu extends StatefulWidget {
  // final List<dynamic> myPost;
  // final List<dynamic> myItem;
  const TabMenu({Key? key}) : super(key: key);

  @override
  _TabMenuState createState() => _TabMenuState();
}

class _TabMenuState extends State<TabMenu> with TickerProviderStateMixin {
  late TabController _tabController;
  List<Map<dynamic, dynamic>> missionList = [
    {
      'id': '1',
      'missionText': '미션2',
      'complete': true,
      'star': 200,
    },
    {
      'id': '2',
      'missionText': '미션2',
      'complete': false,
      'star': 100,
    },
  ];

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
              TabMenuMission(),
              TabMenuItem(),
            ],
          ),
        ),
      ],
    );
  }
}
