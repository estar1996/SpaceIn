import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;

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
        color: Colors.blue.withOpacity(0.2),
      );
      _controller?.addOverlay(circleOverlay); // 변수 뒤에 ?를 붙여줍니다.
    }

    await _loadMarkers();
    _isLoaded = true;

    _setLocationTrackingMode(NLocationTrackingMode.follow); // 마지막 줄에 추가

    setState(() {});
  }

  void _showModal(Map<String, dynamic> item) {
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
              Text(
                item['content'] ?? '', // marker의 content 보여주기
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

  Future<void> _loadMarkers() async {
    final String data =
        await rootBundle.loadString('lib/src/map/markerlist.json');
    final List<dynamic> jsonResult = json.decode(data);

    final markers = jsonResult.map((item) {
      final String id = item['key'];
      final double latitude = item['latitude'];
      final double longitude = item['longitude'];
      final NLatLng position = NLatLng(latitude, longitude);
      const myMarkerIcon = NOverlayImage.fromAssetImage(
        'assets/Star2.png',
      );
      const markerSize = Size(40, 40);
      final marker = NMarker(
        id: id,
        position: position,
        icon: myMarkerIcon,
        size: markerSize,
      );

      if (_currentPosition != null) {
        final double distance = Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          position.latitude,
          position.longitude,
        );

        if (distance <= 300) {
          // 100m 반경 이내의 마커만 필터링
          marker.setOnTapListener((marker) {
            // 마커를 클릭했을 때 실행할 코드
            _showModal(item);
          });
        }
      }

      return marker;
    }).toList();

    final addableMarkers = markers.map((marker) => marker).toSet();
    _controller?.addOverlayAll(addableMarkers);

    setState(() {});
  }

//마커 추가하기

  // void addMarker() {
  //   _currentMarker = NMarker(
  //     id: viewId,
  //     position:
  //         NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
  //   );

  //   setState(() {
  //     _
  //   });
  // }

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
