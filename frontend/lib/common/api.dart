import 'package:dio/dio.dart';
import 'package:frontend/common/secure_storage.dart';
//
// SecureStorage secureStorage = SecureStorage();
// final token = secureStorage.getAccessToken();
// Future getToken() async {
//   await token.then((value) => () {
//         accessToken = value;
//       });
// }

class DataServerDio {
  // SecureStorage secureStorage = SecureStorage();
  // late String? accessToken;
  // final token = secureStorage.getAccessToken();
  // Future getToken() async {
  //   await token.then((value) => () {
  //         accessToken = value;
  //       });
  // }

  getToken() {
    // TODO: implement getToken
    print('들어오는지 모르겠다');
    throw UnimplementedError();
  }

  static Dio instance() {
    final dio = Dio();
    dio.options.baseUrl = 'http://k8a803.p.ssafy.io:8080/';
    dio.options.connectTimeout = Duration(milliseconds: 5000);
    dio.options.receiveTimeout = Duration(milliseconds: 5000);
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Get token from SecureStorage
          final storage = SecureStorage();
          final token = await storage.getAccessToken();

          // Set token in header
          if (token != null) {
            options.headers['Authorization'] = token;
          }
          // print('토큰토큰$token');
          return handler.next(options);
        },
      ),
      // print('통신 토큰 확인$token');
      // dio.interceptors.add(InterceptorsWrapper(
      //   onRequest: (options, handler) {
      //     return handler.next(options);
      //   },
      //   onResponse: (options, handler) {
      //     return handler.next(options);
      //   },
      //   onError: (DioError error, handler) {
      //     print("inteceptor: ${error.response!.statusCode}");
      //   },
      // ));
    );

    return dio;
  }
}

class Paths {
  // to server
  static const posts = '/api/posts'; // 글 작성
  static const comments = '/api/comment'; // 댓글 작성
  static const login = 'login/oauth2/code/google'; // 토큰
  static const signup = 'user/signup'; // 회원 가입
  static const myPage = 'mypage/getData'; // 유저페이지
  static const myPagePost = 'mypage/getPost'; // 유저페이지
  static const myPageItem = 'mypage/getItem'; // 유저페이지
  static const deleteUser = 'mypage/deleteUser';
}

// final SecureStorage secureStorage = SecureStorage();
// final token = secureStorage.getAccessToken();
// class DataServerDio {
//   static Future<Dio> instance() async {
//     final SecureStorage secureStorage = SecureStorage();
//     final token = await secureStorage.getAccessToken();
//     final dio = Dio();
//     dio.options.baseUrl = 'http://k8a803.p.ssafy.io:8080/';
//     dio.options.connectTimeout = Duration(milliseconds: 5000);
//     dio.options.receiveTimeout = Duration(milliseconds: 5000);
//     await token.then((value) => dio.options.headers['token'] = value);
//     return dio;
//   }
// }
