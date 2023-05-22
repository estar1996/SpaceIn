import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/common/api.dart';

class PostDetail {
  // final dio = DioServices()
  final int postId;
  final String commentText;
  final String userNickname;
  final int commentCount;
  final int commentId;

  PostDetail({
    required this.postId,
    required this.commentText,
    required this.userNickname,
    required this.commentCount,
    required this.commentId,
  });
  factory PostDetail.fromJson(Map<String, dynamic> json) {
    return PostDetail(
      postId: json['postId'],
      commentText: json['commentText'],
      userNickname: json['userNickname'],
      commentCount: json['commentCount'],
      commentId: json['commentId'],
    );
  }
}

SecureStorage secureStorage = SecureStorage();
late String accessToken;

class CommentApi {
  final dio = DataServerDio.instance();

//댓글 작성
  Future addComment(String text, int postId) async {
    print('댓글 작성');
    print(text);
    if (text != '') {
      try {
        final dio = DataServerDio.instance();
        final formData = {
          "postId": postId,
          "commentText": text,
        };
        print(formData);
        final response = await dio.post(Paths.comments, data: formData);
        print('성공!?$response');
      } catch (error) {
        print(error);
      }
    }
  }

//댓글 조회
  Future commentList(int postId) async {
    try {
      final dio = DataServerDio.instance();
      final response = await dio.get(Paths.getComments, data: postId);
      return response.data;
    } catch (e) {
      print(e);
      throw Exception('조회실패');
    }
  }

  Future deleteComments(int commentId) async {
    try {
      final dio = DataServerDio.instance();
      final response = await dio.get(Paths.deleteComment, data: commentId);
      print('댓글정보 가져오깅 ${response.data}');
    } catch (error) {
      print(error);
      throw Exception('댓글조회실패');
    }
  }
}
