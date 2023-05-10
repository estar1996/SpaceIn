import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/common/api.dart';

class PostDetailApi {
  // final dio = DioServices()
  final dio = DataServerDio.instance();
  final userId = 1;
  final postId = 1;
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
        // if (response == null) {
        //   print('댓글 작성 성공');
        // } else {
        //   print('댓글 작성 실패');
        // }
      } catch (error) {
        print('왜');
        print(error);
      }
    }
  }

  Future commentList(int postId) async {
    print('댓글리스트조회');
    try {
      print('댓글 띄워조');
      final response = await dio.get('${Paths.comments}/comments/$postId');
      print('response $response');
      print(response.runtimeType);

      // for (final data in response.data) {
      //   print(data);
      // }
      return response.data;

      // final data = jsonDecode(response);
      // print(data.toList());
      print('띄움!');
    } catch (e) {
      print(e);
      throw Exception('조회실패');
    }
  }
}

List<Map<String, String>> item = [
  {
    "userName": "양양",
    "commentText": "으아아악",
  },
];

List items = [
  {
    "videoUrl": "assets/videos/video_1.mp4",
    "name": "Vannak Niza🦋",
    "caption": "Morning, everyone!!",
    "songName": "original sound - Łÿ Pîkâ Ćhûû",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1663771856684033.jpeg",
    "likes": "1.5M",
    "comments": "18.9K",
    "shares": "80K",
    "albumImg":
        "https://images.unsplash.com/photo-1502982899975-893c9cf39028?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=800&q=60"
  },
  {
    "videoUrl": "assets/videos/video_2.mp4",
    "name": "Dara Chamroeun",
    "caption": "Oops 🙊 #fyp #cambodiatiktok",
    "songName": "original sound - 💛💛Khantana 🌟",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/ba13e655825553a46b1913705e3a8617.jpeg",
    "likes": "4.4K",
    "comments": "5.2K",
    "shares": "100",
    "albumImg":
        "https://images.unsplash.com/photo-1462804512123-465343c607ee?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80"
  },
  {
    "videoUrl": "assets/videos/video_3.mp4",
    "name": "9999womenfashion",
    "caption": "#블루모드",
    "songName": "original sound - 🖤Khün MÄk🇰🇭",
    "profileImg":
        "https://p16-tiktokcdn-com.akamaized.net/aweme/720x720/tiktok-obj/1664576339652610.jpeg",
    "likes": "100K",
    "comments": "10K",
    "shares": "8.5K",
    "albumImg":
        "https://images.unsplash.com/photo-1457732815361-daa98277e9c8?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80"
  },
];
