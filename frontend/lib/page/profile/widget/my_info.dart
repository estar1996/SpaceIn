import 'package:flutter/material.dart';
import 'package:frontend/page/profile/widget/popup_menu.dart';

class MyInfo extends StatelessWidget {
  final String name;
  final int star;
  final String profileImage;

  const MyInfo(
      {Key? key,
      required this.name,
      required this.star,
      required this.profileImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('$name, $star, $profileImage');
    return SafeArea(
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 30,
              top: 20,
              bottom: 20,
            ),
            child: Row(children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(90),
                  image: DecorationImage(
                    image: NetworkImage(profileImage),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PopupMenu(),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Row(
                        children: [
                          // const Image(
                          //   width: 20,
                          //   height: 20,
                          //   image: AssetImage(
                          //     'assets/Star1.png',
                          //   ),
                          // ),
                          SizedBox(width: 5),
                          Text(
                            '🌟 $star',
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
