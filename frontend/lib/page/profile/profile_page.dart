import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(children: [
                            NameText(),
                            const InkWell(
                                child: Icon(
                              Icons.settings_rounded,
                              color: Colors.white,
                            ))
                          ]),
                          ProfileImg(),
                          Row(children: [
                            StarCount(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(PRIMARY_COLOR),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        side: const BorderSide(
                                            color: Colors.white)),
                                  ),
                                ),
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PostDetailPage(),
                                    ),
                                  ),
                                },
                                child: Row(children: const [
                                  Icon(
                                    Icons.shopping_bag_rounded,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "ITEM",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ]),
                              ),
                            )
                          ])
                        ]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ProfileImg() {
    return Container(
      margin: const EdgeInsets.all(5),
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        image: const DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/Planet-8.png'),
        ),
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
  // Widget ProfileImg() {
  //   return Material(
  //     shape: CircleBorder(side: BorderSide.none),
  //     elevation: 10,
  //     color: Colors.red,
  //     child: CircleAvatar(
  //       radius: 35,
  //       backgroundImage: AssetImage('assets/images/profile/astronaut2.jpg'),
  //     ),
  //   );
  // }

  Widget NameText() {
    return const Text(
      '우주인',
      style: TextStyle(fontSize: 20),
    );
  }

  Widget StarCount() {
    return const Text('✨200');
  }
}
