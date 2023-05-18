import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/page/login/join_page.dart';

class LoginApi {
  final dio = Dio();
  // 토큰 확인
  Future SendToken(String? token, context, userEmail) async {
    print('회원확인!');
    if (token != null) {
      try {
        final header = {
          "accessToken": token,
        };
        Response response = await dio.post(
            'http://k8a803.p.ssafy.io:8080/login/oauth2/code/google',
            options: Options(headers: header));
        print('응답 성공이면 여기로! ${response.data}');
        print(response.data['token']);
        return response.data;
        // 토큰 저장
        // await _storage.setAccessToken(token);
      } on DioError catch (e) {
        if (e.response?.statusCode == 401) {
          return 401;
          // print('회원없음');
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //       builder: (context) => JoinPage(
          //             token: token,
          //             userEmail: userEmail,
          //           )),
          // );
        } else {
          print(e);
          return 500;
        }
      }
    }
  }

  // 회원 가입
  Future joinUser(String? token, String nickname, String userEmail) async {
    try {
      final formData = {"email": userEmail, "userNickname": nickname};
      print(formData);
      final response = await dio
          .post('http://k8a803.p.ssafy.io:8080/user/signup', data: formData);
      return response.data;
    } on DioError catch (e) {
      print('에러발생 $e');
      // throw Exception('조회실패');
    }
  }
}
