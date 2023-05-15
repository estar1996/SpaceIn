import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/common/api.dart';

class PostDetailApi {
  // final dio = DioServices()
  final dio = DataServerDio.instance();
  final userId = 1;
  final postId = 1;

  //댓글 작성
  Future addComment(String text) async {
    print('댓글 작성');
    print(text);
    if (text != '') {
      try {
        final formData = {
          "postId": postId,
          "userId": userId,
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
      final response = await dio.get('${Paths.comments}/comments/$postId');
      return response.data;
    } catch (e) {
      print(e);
      throw Exception('조회실패');
    }
  }
}
