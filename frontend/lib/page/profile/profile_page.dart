import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/widget/my_info.dart';
import 'package:frontend/page/profile/widget/tab_menu.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // List<dynamic> _userInfo = [];
  // SecureStorage secureStorage = SecureStorage();
  // String? accessToken;
  // late Response<dynamic> userInfoList = Response();
  // Response<dynamic>? userInfoList;
  Map<dynamic, dynamic>? userData;
  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  Future _getProfile() async {
    try {
      final userInfo = await ProfileApi().getProfile();
      setState(() {
        userData = userInfo.data;
      });
    } catch (error) {
      print(error);
    }
    // userInfoList = await ProfileApi().getProfile();
    // final userInfo = await userInfoList;
  }
  // Future<void> _getProfile() async {
  //   userInfoList = ProfileApi().getProfile(accessToken);
  //   print(userInfoList);
  // }

  @override
  Widget build(BuildContext context) {
    // print("받아보까??$userData");
    return Background(
      child: SafeArea(
        child: Column(
          children: [
            userData != null
                ? MyInfo(
                    name: userData?["userNickname"],
                    star: userData?["userMoney"],
                    profileImage: 'assets/Planet-8.png',
                  )
                : MyInfo(
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
