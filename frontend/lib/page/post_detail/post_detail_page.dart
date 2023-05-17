import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/comment_modal.dart';
import 'package:dio/dio.dart';

class Post {
  final int postId;
  final int userId;
  final String userNickname;
  final String fileUrl;
  final double postLatitude;
  final double postLongitude;
  final String postContent;
  final int postLikes;

  Post({
    required this.postId,
    required this.userId,
    required this.userNickname,
    required this.fileUrl,
    required this.postLatitude,
    required this.postLongitude,
    required this.postContent,
    required this.postLikes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'] as int,
      userId: json['userId'] as int,
      userNickname: json['userNickname'] as String,
      fileUrl: json['fileUrl'] as String,
      postLatitude: json['postLatitude'] as double,
      postLongitude: json['postLongitude'] as double,
      postContent: json['postContent'] as String,
      postLikes: json['postLikes'] as int,
    );
  }
}

class PostDetailPage extends StatefulWidget {
  final int postId;
  final double latitude;
  final double longitude;

  const PostDetailPage({
    Key? key,
    required this.postId,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  int currentIndex = 0; // 현재 보고 있는 포스트의 인덱스
  Future<Post?> fetchPost(int postId, double latitude, double longitude) async {
    try {
      final response = await Dio().get(
        'http://k8a803.p.ssafy.io:8080/api/posts/$postId',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData =
            response.data as Map<String, dynamic>;
        final post = Post.fromJson(jsonData);
        print('post 성공');
        return post;
      } else {
        print('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<List<Post>> fetchPostsByLocation(
      double latitude, double longitude) async {
    try {
      final response = await Dio().get(
        'http://k8a803.p.ssafy.io:8080/api/posts/samesame',
        queryParameters: {'latitude': latitude, 'longitude': longitude},
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonResult = response.data as List<dynamic>;
        final List<Post> posts = jsonResult.map((json) {
          final int postLikes =
              json['postLikes'] != null ? json['postLikes'] as int : 0;
          return Post(
            postId: json['postId'] as int,
            postContent: json['postContent'] as String,
            postLatitude: json['postLatitude'] as double,
            postLongitude: json['postLongitude'] as double,
            postLikes: postLikes,
            fileUrl: json['fileUrl'] as String,
            userNickname: json['userNickname'] as String,
            userId: json['userId'] as int,
          );
        }).toList();
        print('샘샘성공');
        print(posts);
        return posts.where((post) => post.postId == widget.postId).toList();
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<int> fetchCommentCount(int postId) async {
    try {
      final response = await Dio().get(
        'http://k8a803.p.ssafy.io:8080/api/comment/comments/',
        queryParameters: {'postId': postId},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResult = response.data as List<dynamic>;
        final List<Post> comments = jsonResult.map((json) {
          return Post.fromJson(json);
        }).toList();
        print('comment성공');
        return comments.length;
      } else {
        print('Error: ${response.statusCode}');
        return 0;
      }
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<int> fetchPostIndex(List<Post> posts) async {
    final postIndex = posts.indexWhere((post) => post.postId == widget.postId);
    return postIndex;
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder<List<Post>>(
        future: fetchPostsByLocation(widget.latitude, widget.longitude),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;

            // postId와 일치하는 게시물의 인덱스를 가져옴
            final postIndexFuture = fetchPostIndex(posts);
            return SizedBox(
              width: size.width,
              height: size.height,
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.vertical, // 스와이프 방향을 위 아래로 설정
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = posts[index];
                  final bool isCurrentPage = index == currentIndex;
                  if (index != currentIndex) {
                    return Container(); // 현재 보고 있는 포스트와 인덱스가 다른 경우 빈 컨테이너 반환
                  }

                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(post.fileUrl ??
                            'assets\backgroundwhiteSpace.png'), // fileUrl을 이미지로 설정
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: const Color.fromRGBO(30, 30, 30, 0.5),
                                ),
                                padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                                child: Text(
                                  post.userNickname,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                        if (isCurrentPage)
                          Container(
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommentCount(post),
                                  LikeCount(post),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index; // 현재 보고 있는 포스트의 인덱스 업데이트
                  });
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return const Text('No data available');
          }
        },
      ),
    );
  }

  Widget CommentCount(Post post) {
    return FutureBuilder<int>(
      future: fetchCommentCount(post.postId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          final commentCount = snapshot.data!;
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) => const CommentModal(),
              );
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
              child: Column(
                children: [
                  const Icon(
                    Icons.chat_bubble_outline_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  Text(
                    commentCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('No data available');
        }
      },
    );
  }

  Widget LikeCount(post) {
    return Container(
      // decoration: BoxDecoration(color: Colors.blue),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_border_rounded,
            color: Colors.white,
            size: 35,
          ),
          Text(
            post.postLikes.toString(),
            // commentCount,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
