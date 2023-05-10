import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/comment_modal.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final postText = '오늘 날씨 좋다';

  final userName = 'nickname';

  final commentCount = 22;

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    List lst = [
      {
        'name': '양',
        'color': Colors.red,
        'text': '오늘의',
        'comment': 10,
        'like': 3,
      },
      {
        'name': '희',
        'color': Colors.blue,
        'text': '날씨는',
        'comment': 6,
        'like': 12,
      },
      {
        'name': '진',
        'text': '맑음',
        'color': Colors.green,
        'comment': 7,
        'like': 3,
      },
    ];
    // 게시글 통신할 것

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      extendBodyBehindAppBar: true,
      // body: ListView.builder(
      //   itemBuilder: (context, index) {
      body: SizedBox(
        width: size.width,
        height: size.height,
        // child: PageView(
        //   onPageChanged: (int index) => value.changePage(index),
        //   children: [],
        // ),
        // child: PageView.builder(
        //   controller: _pageController,
        //   itemBuilder: (BuildContext context, int index) {
        //     return Container();
        //   },
        // ),
        child: PageView(
          controller: pageController,
          scrollDirection: Axis.vertical,
          children: lst.map(
            (e) {
              return Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: e["color"],
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            e["text"],
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: const Color.fromRGBO(30, 30, 30, 0.5),
                            ),
                            padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            // color: Colors.grey,
                            child: Text(
                              e['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CommentCount(),
                            LikeCount(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ).toList(),
        ),
      ),
    );
  }

  Widget CommentCount() {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (context) => const CommentModal(),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
        child: Column(
          children: const [
            Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white,
              size: 35,
            ),
            Text(
              '11',
              // commentCount,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LikeCount() {
    return Container(
      // decoration: BoxDecoration(color: Colors.blue),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: const [
          Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 35,
          ),
          Text(
            '11',
            // commentCount,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
