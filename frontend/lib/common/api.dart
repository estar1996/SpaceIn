import 'package:dio/dio.dart';

class DataServerDio {
  static Dio instance() {
    final dio = Dio();
    dio.options.baseUrl = 'http://k8a803.p.ssafy.io:8080/';
    dio.options.connectTimeout = Duration(milliseconds: 5000);
    dio.options.receiveTimeout = Duration(milliseconds: 5000);

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (options, handler) {
        return handler.next(options);
      },
      onError: (DioError error, handler) {
        print("inteceptor: ${error.response!.statusCode}");
      },
    ));
    return dio;
  }
}

class Paths {
  // to server
  static const posts = '/api/posts'; // 글 작성
  static const comments = '/api/comment'; // 댓글 작성
}
