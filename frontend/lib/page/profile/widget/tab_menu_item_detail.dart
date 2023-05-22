import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';

class TabMenuItemDetail extends StatelessWidget {
  final String textTitle;
  final List<String> itemList;

  const TabMenuItemDetail({
    Key? key,
    required this.itemList,
    required this.textTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<String> imageList = itemList.map((item) => item.toString()).toList();
    // print(imageList);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: PRIMARY_COLOR,
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
            // children: [
            //   Text(
            //     textTitle,
            //     style: TextStyle(
            //       color: Colors.black45,
            //     ),
            //   ),
            //   GridView.count(
            //       crossAxisCount: 4,
            //       crossAxisSpacing: 10,
            //       mainAxisSpacing: 13,
            //       children: imageList
            //           .map((item) =>
            //               Container(width: 50, height: 50, child: Text(item)))
            //           .toList()),
            // ],
            ),
      ),
    );
  }
}
