import 'package:dio/dio.dart';
import 'package:frontend/common/api.dart';
import 'package:frontend/common/secure_storage.dart';

class UserInfo {
  final String username;
  final int usermoney;
  final fileUrl;

  UserInfo({
    required this.username,
    required this.usermoney,
    required this.fileUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      username: json['userNickname'],
      usermoney: json['userMoney'],
      fileUrl: json['userImage'],
    );
  }
}

SecureStorage secureStorage = SecureStorage();
final SecureStorage storage = SecureStorage();
late String accessToken;

class ProfileApi {
  final dio = DataServerDio.instance();

  // 유저 정보
  Future getProfile() async {
    try {
      final response = await dio.get(Paths.myPage);
      print('유저정보 가져오깅 ${response}');

      return response;
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }

  // 유저 글 정보
  Future getUserPost() async {
    try {
      final response = await dio.get(Paths.myPagePost);
      print('유저글목록 가져오깅 ${response}');

      return response;
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }

  // 유저 아이템 정보
  Future getUserItem() async {
    try {
      final response = await dio.get(Paths.myPageItem);
      print('유저아이템목록 가져오깅 ${response.data['backgroundItem']}');
      return response.data['backgroundItem'];

      // return response;
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }

  // 유저 스티커 정보
  Future getUserSticker() async {
    try {
      final response = await dio.get(Paths.myPageSticker);
      print('유저스티커목록 가져오깅 ${response.data['stickerItem']}');

      return response.data['stickerItem'];
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }

  // 회원 탈퇴
  Future UserDelete() async {
    try {
      print('탈퇴해보자');
      print(dio.options.headers);
      final response = await dio.post(Paths.deleteUser);
      print('삭제된건강 ${response.data}');
      storage.deleteAccessToken();
      storage.deleteRefreshToken();
    } catch (error) {
      print(error);

      throw Exception('조회실패');
    }
  }

  // 닉네임 변경
  Future changeNickname(String nickname) async {
    print('닉네임 바꿀거임 $nickname');
    try {
      final formData = {"nickName": nickname};
      print(formData);
      final response = await dio.post(Paths.changeUser, data: formData);
      return response.data;
    } on DioError catch (e) {
      print('에러발생 $e');
    }
  }
}
