import 'package:flutter/material.dart';

class PostDetail extends StatefulWidget {
  final color;
  const PostDetail({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  State<PostDetail> createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: widget.color,
      ),
      // ),
      // child: PageView(
      //     scrollDirection: Axis.vertical,
      //     children: reel,
      //     controller: widget.controller),
    );
  }
}
