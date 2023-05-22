import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/widget/my_info.dart';
import 'package:frontend/page/profile/widget/tab_menu.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // NLatLng? newPosition;
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
      print('유저정보 $userInfo');
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(newPosition);
    print("받아보까??$userData");
    return Background(
      child: userData == null
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : SafeArea(
              child: Column(
                children: [
                  MyInfo(
                    name: userData?["userNickname"] ?? '우주인',
                    star: userData?["userMoney"] ?? 0,
                    profileImage: userData?["userImage"],
                  ),
                  Expanded(
                    child: TabMenu(),
                  ),
                ],
              ),
            ),
    );
  }
}
