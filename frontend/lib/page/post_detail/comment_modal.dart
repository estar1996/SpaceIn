import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CommentModal extends StatefulWidget {
  final int postId;
  final int userId;

  const CommentModal({Key? key, required this.postId, required this.userId})
      : super(key: key);

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  List<dynamic>? comments;
  List<dynamic>? userName;

  Dio dio = Dio();
  final TextEditingController _commentController = TextEditingController();
  String? currentUserName; // 현재 사용자의 이름을 저장할 변수

  @override
  void initState() {
    super.initState();
    getComments();
    getCurrentUserName(); // 현재 사용자의 이름을 가져오기 위해 호출
  }

  Future getCurrentUserName() async {
    // 현재 사용자의 이름을 가져오는 비동기 함수
    try {
      final response = await dio
          .get('http://k8a803.p.ssafy.io:8080/api/user/${widget.userId}');
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          currentUserName = data['userName']; // 현재 사용자의 이름 업데이트
        });
      } else {
        // Handle the error scenario
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  Future getComments() async {
    try {
      final response = await dio.get(
          'http://k8a803.p.ssafy.io:8080/api/comment/comments/${widget.postId}');
      if (response.statusCode == 200) {
        setState(() {
          comments = response.data;
          userName = [];
          for (var comment in comments!) {
            userName!.add(comment['userName']);
          }
        });
      } else {
        // Handle the error scenario
      }
    } catch (e) {
      // Handle any exceptions
    }
  }

  Future<void> postComment(BuildContext context, String text) async {
    print(text);
    try {
      await dio.post('http://k8a803.p.ssafy.io:8080/api/comment', data: {
        'postId': widget.postId,
        'userId': widget.userId,
        'commentText': text,
      });
      FocusScope.of(context).unfocus();
      _commentController.clear();
      setState(() {
        comments = [
          ...comments!,
          {
            'userName': currentUserName,
            'commentText': text
          } // 현재 사용자의 이름으로 댓글 작성
        ];
        userName!.add(currentUserName);
      });
    } catch (e) {
      // Handle any exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        top: 30,
        left: 10,
        right: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: comments?.isEmpty == true
                ? const Center(
                    child: Text(
                      '작성된 댓글이 없습니다.',
                    ),
                  )
                : ListView.builder(
                    itemCount: comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(userName?[index] ?? ''),
                        subtitle: Text(comments?[index]['commentText'] ?? ''),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _commentController,
            keyboardType: TextInputType.multiline,
            minLines: 1,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '댓글을 입력하세요',
              suffixIcon: IconButton(
                onPressed: () {
                  postComment(context, _commentController.text);
                },
                icon: const Icon(Icons.create_rounded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
