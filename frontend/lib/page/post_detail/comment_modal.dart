import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/data/post_detail_data.dart';

class CommentModal extends StatefulWidget {
  final int postId;
  final int userId;

  const CommentModal({Key? key, required this.postId, required this.userId})
      : super(key: key);

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  List<dynamic>? comments; // comments 변수를 배열로 선언
  List<dynamic>? userName; // userName 변수를 배열로 선언
  String? currentUserName; // 현재 사용자의 이름을 저장할 변수

  Dio dio = Dio();
  final TextEditingController _commentController = TextEditingController();
  // String? currentUserName; // 현재 사용자의 이름을 저장할 변수

  @override
  void initState() {
    super.initState();
    _commentController.clear(); // 댓글 입력 필드 초기화
    _getComments(); // 댓글 목록 다시 불러오기
    // FocusScope.of(context).unfocus(); // 키보드 포커스 해제
  }

  Future _postComment() async {
    try {
      await CommentApi().addComment(_commentController.text, widget.postId);
    } catch (error) {
      print(error);
    }
  }

  Future _getComments() async {
    try {
      final response = await CommentApi().commentList(widget.postId);
      setState(() {
        comments = response['commentText'];
        userName = response['userNickcname'];
      });
    } catch (error) {
      print(error);
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
                  _postComment();
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
