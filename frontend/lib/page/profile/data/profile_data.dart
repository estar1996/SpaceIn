import 'package:frontend/common/api.dart';

class ProfileApi {
  final dio = DataServerDio.instance();

  // 유저정보
  Future getProfile(int idx) async {
    try {
      final response = await dio.get('주소');
      print('성공!?$response');
      return response.data;
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }
}
