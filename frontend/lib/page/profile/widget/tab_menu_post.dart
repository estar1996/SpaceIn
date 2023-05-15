import 'dart:math';

import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';

class TabMenuPost extends StatefulWidget {
  const TabMenuPost({Key? key}) : super(key: key);

  @override
  State<TabMenuPost> createState() => _TabMenuPostState();
}

class _TabMenuPostState extends State<TabMenuPost> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        key: const PageStorageKey("글"),
        itemCount: 1000,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PostDetailPage()),
              );
            },
            child: Container(
              color: PRIMARY_COLOR,
              child: Center(
                  child: Text(
                "List $index",
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              )),
            ),
          );
        }));
  }
}
