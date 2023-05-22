import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:frontend/common/api.dart';

class CommentModal extends StatefulWidget {
  final int postId;

  const CommentModal({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<CommentModal> {
  List<dynamic>? comments;
  List<dynamic>? userName;
  String? currentUserName;

  Dio dio = Dio();
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.clear();
    _getComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _postComment() async {
    final text = _commentController.text;
    if (text.isNotEmpty) {
      try {
        final dio = DataServerDio.instance();
        final formData = {
          "postId": widget.postId,
          "commentText": text,
        };
        final response = await dio.post(Paths.comments, data: formData);
        print('Success! $response');
        _commentController.clear();
        _getComments();
      } catch (error) {
        print(error);
      }
    }
  }

  Future<void> _getComments() async {
    try {
      final dio = DataServerDio.instance();
      final response = await dio.get(
        '${Paths.getComments}${widget.postId}',
      );
      setState(() {
        comments = response.data;
        print('댓글 잘가져감?');
        print(comments);
      });
    } catch (error) {
      print('댓글 가져오기 오류');
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
                    child: Text('작성된 댓글이 없습니다.'),
                  )
                : ListView.builder(
                    itemCount: comments?.length ?? 0,
                    itemBuilder: (context, index) {
                      final comment = comments![index];
                      return ListTile(
                        title: Text(comment['userName'] ?? ''),
                        subtitle: Text(comment['commentText'] ?? ''),
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
