import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;
import 'package:dio/dio.dart';

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
    return Post(
        postId: json['postId'],
        postLatitude: json['postLatitude'],
        postLongitude: json['postLongitude'],
        postContent: json['postContent'],
        postLikes: json['postLikes']);
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

  Future<void> _getCurrentLocation() async {
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
          color: const Color(0xFF9479CD).withOpacity(0.2));
      _controller?.addOverlay(circleOverlay); // 변수 뒤에 ?를 붙여줍니다.
    }

    await _loadMarkers();
    _isLoaded = true;

    _setLocationTrackingMode(NLocationTrackingMode.follow); // 마지막 줄에 추가

    setState(() {});
  }

  void _showModal(List<String> contents) {
    if (contents.isEmpty) return; // Exit if there are no contents
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: ((context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final content in contents)
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Future<List<Post>> fetchPosts() async {
    try {
      final response =
          await Dio().get('http://k8a803.p.ssafy.io:8080/api/posts/');
      final jsonResult = response.data as List<dynamic>;

      final List<Post> posts =
          jsonResult.map((json) => Post.fromJson(json)).toList();

      return posts;
    } catch (e) {
      // Handle error
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
      final NLatLng position = NLatLng(latitude, longitude);
      final int likes = post.postLikes;
      const myMarkerIcon = NOverlayImage.fromAssetImage(
        'assets/Star2.png',
      );
      const markerSize = Size(40, 40);
      final String content = post
          .postContent; // Replace with the actual content property from your API

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

    setState(() {});

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
            _showModal(markerContent);
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
