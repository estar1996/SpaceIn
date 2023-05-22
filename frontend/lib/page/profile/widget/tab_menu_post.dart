import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;

class TabMenuPost extends StatefulWidget {
  final NLatLng? newPosition;
  const TabMenuPost({Key? key, this.newPosition}) : super(key: key);

  @override
  State<TabMenuPost> createState() => _TabMenuPostState();
}

class _TabMenuPostState extends State<TabMenuPost> {
  List<dynamic>? userData;
  NLatLng? userPosition;

  @override
  void initState() {
    super.initState();
    _getUserPost();
  }

  Future _getUserPost() async {
    try {
      final userInfo = await ProfileApi().getUserPost();
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocatorEnums.LocationAccuracy.high,
      );
      print('위치정보 $position');

      setState(() {
        userPosition = NLatLng(
          double.parse(position.latitude.toStringAsFixed(4)),
          double.parse(position.longitude.toStringAsFixed(4)),
        );
        userData = userInfo.data["postList"];
      });
    } catch (error) {
      print(error);
    }
    // userInfoList = await ProfileApi().getProfile();
    // final userInfo = await userInfoList;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.newPosition);
    print("유저위치 $userPosition");

    print("유저가 쓴 글 $userData");
    return Container(
      color: Colors.grey.withOpacity(0.2),
      child: userData == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : userData!.isEmpty
              ? const Center(
                  child: Text(
                  '작성된 글이 없습니다',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ))
              : GridView.builder(
                  key: const PageStorageKey("글"),
                  itemCount: userData?.length ?? 0,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, childAspectRatio: 9 / 16),
                  itemBuilder: ((context, index) {
                    final post = userData![index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PostDetailPage(
                                    postId: post['postId'],
                                    latitude: userPosition!.latitude,
                                    longitude: userPosition!.longitude,
                                  )),
                        );
                      },
                      child: Container(
                          // color: Colors.white,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              width: 0.5,
                              color: Colors.grey,
                              // color: Colors.grey,
                            ),
                          ),
                          child: Image.network(
                            post['fileUrl'],
                            fit: BoxFit.fitWidth,
                          )),
                    );
                  })),
    );
  }
}
