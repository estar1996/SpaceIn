import 'package:flutter/material.dart';
import 'package:frontend/page/post_detail/comment_modal.dart';
import 'package:dio/dio.dart';
import 'dart:async';

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
  int currentIndex = -1; // 현재 표시 중인 게시물의 인덱스
  late PageController pageController; // PageView용 컨트롤러
  int commentCount = 0; // 댓글 개수 변수 추가
  List<Post> posts = []; // posts 리스트 선언 및 초기화

  @override
  void initState() {
    super.initState();
    fetchPostsByLocation(widget.latitude, widget.longitude)
        .then((fetchedPosts) {
      setState(() {
        posts = fetchedPosts;
      });
    });
    pageController = PageController(initialPage: currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose(); // Dispose the page controller
    super.dispose();
  }

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
        print('게시물 가져오기 성공');
        return post;
      } else {
        print('오류: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('오류: $e');
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
        print('주변 게시물 가져오기 성공');
        print(posts);
        return posts;
      } else {
        throw Exception('오류: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('오류: $e');
    }
  }

  // bool isLoading = false; // 로딩 상태 변수 추가
  Future<int> fetchCommentCount(int postId) async {
    try {
      isLoading = true; // 로딩 시작
      final response = await Dio().get(
        'http://k8a803.p.ssafy.io:8080/api/comment/comments/',
        queryParameters: {'postId': postId},
      );
      if (mounted) {
        if (response.statusCode == 200) {
          final List<dynamic> jsonResult = response.data as List<dynamic>;
          print('댓글 개수 가져오기 성공');
          setState(() {
            commentCount = jsonResult.length; // 댓글 개수 업데이트
          });
        } else {
          print('오류: ${response.statusCode}');
          setState(() {
            commentCount = 0; // 오류 발생 시 댓글 개수를 0으로 설정
          });
        }
      }
    } catch (e) {
      if (mounted) {
        print('오류: $e');
        setState(() {
          commentCount = 0; // 오류 발생 시 댓글 개수를 0으로 설정
        });
      }
    } finally {
      isLoading = false; // 로딩 종료
    }
  }

  // Future<void> fetchCommentCount(int postId) async {
  //   if (isLoading) return; // 이미 로딩 중이라면 중복 호출 방지

  //   try {
  //     isLoading = true; // 로딩 시작
  //     final response = await Dio().get(
  //       'http://k8a803.p.ssafy.io:8080/api/comment/comments/',
  //       queryParameters: {'postId': postId},
  //     );
  //     if (mounted) {
  //       if (response.statusCode == 200) {
  //         final List<dynamic> jsonResult = response.data as List<dynamic>;
  //         print('댓글 개수 가져오기 성공');
  //         setState(() {
  //           commentCount = jsonResult.length; // 댓글 개수 업데이트
  //         });
  //       } else {
  //         print('오류: ${response.statusCode}');
  //         setState(() {
  //           commentCount = 0; // 오류 발생 시 댓글 개수를 0으로 설정
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       print('오류: $e');
  //       setState(() {
  //         commentCount = 0; // 오류 발생 시 댓글 개수를 0으로 설정
  //       });
  //     }
  //   } finally {
  //     isLoading = false; // 로딩 종료
  //   }
  // }

  Future<int> fetchPostIndex(List<Post> posts) async {
    final postIndex = posts.indexWhere((post) => post.postId == widget.postId);
    return postIndex;
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
      fetchCommentCount(
          posts[index].postId); // currentIndex 변경 시 fetchCommentCount 호출
    });
  }

  @override
  Widget build(BuildContext context) {
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

            return FutureBuilder<int>(
              future: postIndexFuture,
              builder: (context, indexSnapshot) {
                if (indexSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (indexSnapshot.hasData) {
                  final postIndex = indexSnapshot.data!;

                  // int currentIndex = postIndex; // 현재 보고 있는 포스트의 인덱스
                  PageController pageController = PageController(
                    initialPage:
                        (currentIndex == -1 && currentIndex != postIndex
                            ? postIndex
                            : (currentIndex != postIndex
                                ? currentIndex
                                : postIndex)),
                    viewportFraction: 1.0,
                    keepPage: true,
                  );
                  print(posts.length);
                  return SizedBox(
                    width: size.width,
                    height: size.height,
                    child: PageView(
                      controller: pageController,
                      scrollDirection: Axis.vertical,
                      children: List.generate(posts.length, (index) {
                        final post = posts[index];

                        // postId와 일치하는 게시물의 댓글 개수 가져오기
                        if (currentIndex == index) {
                          fetchCommentCount(post.postId);
                        }
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(post.fileUrl ??
                                  'assets/background/whiteSpace.png'), // fileUrl을 이미지로 설정
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: const Color.fromRGBO(
                                              30, 30, 30, 0.5),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            8, 4, 8, 4),
                                        child: Text(
                                          post.userNickname,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                  ],
                                ),
                              ),
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
                      }),
                      onPageChanged: (int index) {
                        // pageController.jumpToPage(index);
                        updateCurrentIndex(index);
                      },
                    ),
                  );
                } else if (indexSnapshot.hasError) {
                  return Text('오류: ${indexSnapshot.error}');
                } else {
                  return const Text('데이터 없음');
                }
              },
            );
          } else if (snapshot.hasError) {
            return Text('오류: ${snapshot.error}');
          } else {
            return const Text('데이터 없음');
          }
        },
      ),
    );
  }

  Widget CommentCount(Post post) {
    print(post.postId);
    print('commentCount');
    print(commentCount.toString());
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
          builder: (context) =>
              CommentModal(postId: post.postId, userId: post.userId),
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
              shadows: <Shadow>[
                Shadow(color: Colors.black54, blurRadius: 15.0)
              ],
            ),
            Text(
              commentCount.toString(), // 댓글 개수 사용
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 15.0, // shadow blur
                    color: Colors.black87, // shadow color
                    offset: Offset(0, 0), // how much shadow will be shown
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget LikeCount(Post post) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
      child: Column(
        children: [
          const Icon(
            Icons.favorite_outline_rounded,
            color: Colors.white,
            size: 35,
            shadows: <Shadow>[Shadow(color: Colors.black54, blurRadius: 15.0)],
          ),
          Text(
            post.postLikes.toString(),
            style: const TextStyle(
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 15.0, // shadow blur
                  color: Colors.black87, // shadow color
                  offset: Offset(0, 0), // how much shadow will be shown
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
