import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/data/post_detail_data.dart';

class CommentModal extends StatefulWidget {
  const CommentModal({Key? key}) : super(key: key);

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  late final comments;
  // late Future<List<Map<dynamic, dynamic>>> _comments;

  Dio dio = Dio();
  final PostDetailApi postDetailApi = PostDetailApi();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getComments();
  }

  // 댓글 조회 통신
  Future getComments() async {
    comments = PostDetailApi().commentList(1);
    print(comments);
  }

  // 댓글 작성 통신
  Future postComment(context, String text) async {
    print(text);
    await PostDetailApi().addComment(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        // color: Color.fromRGBO(25, 25, 25, 0.3),
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
      // padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              // itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                    // title: Text(comments[index]['userName']),
                    // subtitle: Text(comments[index]['commentText']),
                    );
              },
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _commentController,
            keyboardType: TextInputType.multiline,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: 5, // when user presses enter it will adapt to it
            decoration: InputDecoration(
              hintText: '댓글을 입력하세요',
              suffixIcon: IconButton(
                onPressed: () {
                  // postDetailApi.addComment(_commentController.text);
                  postComment(context, _commentController.text);
                },
                icon: Icon(Icons.create_rounded),
              ),
              // suffixText: '게시',
              // border: OutlineInputBorder(),
            ),
            // onTapOutside: FocusManager.instance.primaryFocus?.unfocus(),
          ),
        ],
      ),
    );
  }
}
