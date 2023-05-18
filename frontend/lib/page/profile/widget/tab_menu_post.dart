import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:frontend/page/profile/data/profile_data.dart';

class TabMenuPost extends StatefulWidget {
  const TabMenuPost({Key? key}) : super(key: key);

  @override
  State<TabMenuPost> createState() => _TabMenuPostState();
}

class _TabMenuPostState extends State<TabMenuPost> {
  List<dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _getUserPost();
  }

  Future _getUserPost() async {
    try {
      final userInfo = await ProfileApi().getUserPost();
      setState(() {
        userData = userInfo.data["postList"];
      });
    } catch (error) {
      print(error);
    }
    // userInfoList = await ProfileApi().getProfile();
    // final userInfo = await userInfoList;
  }

  @override
  Widget build(BuildContext context) {
    print("유저가 쓴 글 $userData");
    return userData == null
        ? const Center(
            child: CircularProgressIndicator(color: Colors.white),
          )
        : userData!.isEmpty
            ? const Center(
                child: Text(
                '작성된 글이 없습니다',
                style: TextStyle(
                  color: Colors.white,
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => PostDetailPage(
                      //             postId: post['postId'],
                      //             latitude: null,
                      //             longitude: null,
                      //           )),
                      // );
                    },
                    child: Container(
                        color: Colors.white,
                        // MediaQuery.of(context).size.width / 3, // Container 높이 조정
                        child: Image.network(
                          post['fileUrl'],
                          fit: BoxFit.fitWidth,
                        )
                        // child: Image(
                        //     child: Text(
                        //   "List $index",
                        //   style: const TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold),

                        ),
                  );
                }));
  }
}
