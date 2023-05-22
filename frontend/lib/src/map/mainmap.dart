import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:frontend/page/post_detail/post_detail_page.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:frontend/common/api.dart';

class Post {
  final int postId;
  final double postLatitude;
  final double postLongitude;
  final String postContent;
  final int postLikes;

  Post(
      {required this.postId,
      required this.postLatitude,
      required this.postLongitude,
      required this.postContent,
      required this.postLikes});

  factory Post.fromJson(Map<String, dynamic> json) {
    final int postId = json['postId'] ?? 0;
    final double postLatitude = json['postLatitude'] ?? 0.0;
    final double postLongitude = json['postLongitude'] ?? 0.0;
    final String postContent = json['postContent'] ?? '';
    final int postLikes = json['postLikes'] ?? 0;

    return Post(
      postId: postId,
      postLatitude: postLatitude,
      postLongitude: postLongitude,
      postContent: postContent,
      postLikes: postLikes,
    );
  }
}

class MainMap extends StatefulWidget {
  const MainMap({Key? key}) : super(key: key);

  @override
  State<MainMap> createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  NaverMapController? _controller; // 1. 컨트롤러 변수 선언
  Location location = Location();
  LocationData? _locationData;
  bool _isLoaded = false;
  Position? _currentPosition;
  Map<NLatLng, int> markerCounts = {};
  Map<NLatLng, List<String>> markerContents = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _gainCurrentLocation();
    _loadMarkers();
  }

  void _gainCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: geolocatorEnums.LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
      _getCurrentLocation(); // 내 위치가 갱신되면 위치 정보에 기반한 마커와 원을 다시 그림
      // await _loadMarkers(); // 데이터를 가져온 후에 마커를 추가함
    } catch (e) {
      print(e);
    }
  }

  Future<void> _printLocationTrackingMode() async {
    final NLocationTrackingMode mode =
        await _controller!.getLocationTrackingMode();
    print('Current Location Tracking Mode: $mode');
  }

  void _setLocationTrackingMode(NLocationTrackingMode mode) async {
    if (_controller != null) {
      await _controller!.setLocationTrackingMode(mode);
    } else {
      // _controller 가 null 일 경우, 현재 위치를 찾을 때까지 대기
      while (_controller == null) {
        await Future.delayed(const Duration(milliseconds: 500));
      }
      // 현재 위치를 찾은 후 LocationTrackingMode 설정
      await _controller!.setLocationTrackingMode(mode);
    }
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // 위치 서비스가 활성화되어 있는지 확인
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      // 위치 서비스가 활성화되어 있지 않은 경우, 위치 서비스 활성화 요청
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // 위치 서비스 활성화가 거부된 경우, 사용자에게 메시지를 보여줌
        return;
      }
    }

    // 위치 권한 확인
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      // 위치 권한이 거부된 경우, 위치 권한 요청
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // 위치 권한이 거부된 경우, 사용자에게 메시지를 보여줌
        return;
      }
    }

    // 내 위치 기반 원 그리기
    if (_currentPosition != null) {
      final circleOverlay = NCircleOverlay(
        id: "current",
        center:
            NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
        radius: 300,
        color: const Color(0xFF9479CD).withOpacity(0.2),
      );
      _controller?.addOverlay(circleOverlay);
      // Start the timer to periodically update the circleOverlay's position
      _startTimerToUpdateCircleOverlay();
    }

    _setLocationTrackingMode(NLocationTrackingMode.follow);

    setState(() {});

    await _loadMarkers(); // 위치가 갱신될 때마다 마커를 다시 로드

    _isLoaded = true;
  }

  void _startTimerToUpdateCircleOverlay() {
    // Cancel the previous timer if running
    _cancelTimer();

    // Start a new timer to update the circleOverlay's position every 10 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Update the position of the circleOverlay with the current location
      if (_currentPosition != null) {
        final circleOverlay = NCircleOverlay(
          id: "current",
          center:
              NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          radius: 300,
          color: const Color(0xFF9479CD).withOpacity(0.2),
        );
        // _controller?.deleteOverlay(info);
        _controller?.addOverlay(circleOverlay);
      }
    });
  }

  void _cancelTimer() {
    // Cancel the timer if it's active
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    _cancelTimer(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _showModal(double latitude, double longitude) {
    fetchPostsByLocation(latitude, longitude).then((posts) {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.fromLTRB(5, 20, 0, 0),
            height: MediaQuery.of(context).size.height * 0.3, // 원하는 크기로 조정
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final post = posts[index];
                  final postId = post.postId.toString();
                  final postLikes = post.postLikes.toString();
                  final item = post.postContent; // 개별 항목 가져오기

                  return FutureBuilder<int>(
                    future: fetchCommentCount(post.postId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // 로딩 중이라면 로딩 표시를 보여줌
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        // 에러가 발생했다면 에러 메시지를 표시함
                        return const Text('댓글 개수 가져오기 오류');
                      } else {
                        // 댓글 개수가 정상적으로 가져와졌다면 해당 값을 표시함
                        final commentCount = snapshot.data ?? 0;

                        return ListTile(
                          title: SizedBox(
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item.length > 14
                                        ? '${item.substring(0, 14)}...'
                                        : item,
                                    // Rest of your Text widget properties...개별 항목 사용
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    maxLines:
                                        1, // Display text in a single line
                                    overflow: TextOverflow
                                        .ellipsis, // Add ellipsis if text exceeds available space
                                  ),
                                ),
                                const Icon(Icons.favorite_border_rounded),
                                const SizedBox(width: 4),
                                Text(
                                  postLikes ?? '0',
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.messenger_outline_rounded),
                                const SizedBox(width: 4),
                                Text(
                                  commentCount.toString(),
                                  style: const TextStyle(color: Colors.black54),
                                ), // 댓글 개수 표시
                              ],
                            ),
                          ),
                          onTap: () {
                            // 클릭 시 원하는 페이지로 이동하는 코드 작성
                            _navigateToPage(
                                postId, latitude, longitude); // 인덱스 값을 전달
                          },
                        );
                      }
                    },
                  );
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: posts.length, // 항목 수만큼 반복
              ),
            ),
          );
        },
      );
    });
  }

  Future<int> fetchCommentCount(int postId) async {
    try {
      final dio = DataServerDio.instance();
      final response = await dio.get(
        '${Paths.getComments}$postId',
      );
      print(postId);
      print('코멘츠');
      final List<dynamic> comments = response.data as List<dynamic>;
      final int commentCount =
          comments.isNotEmpty ? comments[0]['commentCount'] as int : 0;

      print(comments[0]);
      print(comments[0]['commentCount']);
      return commentCount;
    } catch (error) {
      print(error);
      return 0;
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
          );
        }).toList();
        print('샘샘성공');
        print(posts);
        return posts;
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  void _navigateToPage(String postId, double latitude, double longitude) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailPage(
          postId: int.parse(postId),
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final response =
          await Dio().get('http://k8a803.p.ssafy.io:8080/api/posts/all');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResult = response.data as List<dynamic>;
        final List<Post> posts = jsonResult.map((json) {
          final int postLikes =
              json['postLikes'] != null ? json['postLikes'] as int : 0;
          return Post.fromJson({...json, 'postLikes': postLikes});
        }).toList();
        print('성공탱');
        return posts;
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<void> _loadMarkers() async {
    final List<Post> posts = await fetchPosts();

    final Map<NLatLng, List<String>> markerContents = {};

    final List<NMarker> markers = [];

    for (final post in posts) {
      final String id = post.postId.toString();
      final double latitude = post.postLatitude;
      final double longitude = post.postLongitude;
      final NLatLng position = NLatLng(
        double.parse(latitude.toStringAsFixed(4)),
        double.parse(longitude.toStringAsFixed(4)),
      );
      final int likes = post.postLikes;
      const myMarkerIcon = NOverlayImage.fromAssetImage(
        'assets/Star2.png',
      );
      const markerSize = Size(40, 40);
      final String content = post.postContent;

      final List<String>? existingMarkerContents = markerContents[position];
      if (existingMarkerContents != null) {
        existingMarkerContents.add(content);
      } else {
        markerContents[position] = [content];
      }

      final marker = NMarker(
        id: id,
        position: position,
        icon: myMarkerIcon,
        size: markerSize,
      );
      // Check if content has multiple items
      final List<String>? markerContent = markerContents[marker.position];
      if (markerContent != null &&
          markerContent.length > 1 &&
          markerContent.length < 10) {
        marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/Star2_1.png',
        ));
      } else if (markerContent != null &&
          markerContent.length > 9 &&
          markerContent.length < 20) {
        marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/Star2_2.png',
        ));
      } else if (markerContent != null &&
          markerContent.length > 19 &&
          markerContent.length < 50) {
        marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/Star2_3.png',
        ));
      } else if (markerContent != null &&
          markerContent.length > 49 &&
          markerContent.length < 100) {
        marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/Star2_4.png',
        ));
      } else if (markerContent != null && markerContent.length > 99) {
        marker.setIcon(const NOverlayImage.fromAssetImage(
          'assets/Star2_5.png',
        ));
      }
      markers.add(marker);
    }

    final addableMarkers = markers.toSet();
    _controller?.addOverlayAll(addableMarkers);

    if (mounted) {
      setState(() {
        // Update state here
      });
    }

    for (final marker in addableMarkers) {
      marker.setOnTapListener((marker) {
        final double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          marker.position.latitude,
          marker.position.longitude,
        );
        if (distance <= 300) {
          final List<String>? markerContent = markerContents[marker.position];
          if (markerContent != null) {
            _showModal(marker.position.latitude, marker.position.longitude);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          NaverMap(
            onMapReady: (controller) {
              setState(() {
                _controller = controller;
              });
              print("네이버 맵 로딩됨!");
              _getCurrentLocation();
              _loadMarkers();
            },
            options: const NaverMapViewOptions(
              locationButtonEnable: true,
              tiltGesturesEnable: false,
            ),
          ),
        ],
      ),
    );
  }
}
