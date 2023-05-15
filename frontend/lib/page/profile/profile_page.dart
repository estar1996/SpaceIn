import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/page/profile/widget/my_info.dart';
import 'package:frontend/page/profile/widget/tab_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SafeArea(
        child: Column(
          children: [
            MyInfo(
              name: '누워있는우주인',
              star: 220,
              profileImage: 'assets/Planet-8.png',
            ),
            Expanded(child: TabMenu()),
          ],
        ),
      ),
    );
  }
}
