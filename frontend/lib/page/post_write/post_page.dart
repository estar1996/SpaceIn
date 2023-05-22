import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/page/post_write/sticker/background_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/page/post_write/drawing/drawing_page.dart';
import 'package:frontend/page/post_write/sticker/sticker.dart';
import 'package:frontend/page/post_write/sticker/sticker_button.dart';

import 'package:screenshot/screenshot.dart';

import 'package:geolocator/geolocator.dart';
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart'
    as geolocatorEnums;

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import 'package:frontend/common/navbar.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:frontend/common/secure_storage.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final TextEditingController _controller = TextEditingController();
  String text = "";
  final int _maxLength = 140;
  final int _maxLines = 10;
  Color _backgroundColor = Colors.white;
  File? _backgroundImage;
  bool _isBottomSheetOpen = false;
  bool _isBlackhole = false;
  bool _isBlackholeActive = false;
  Position? _currentPosition;
  List<String> imageList = [];
  List<Widget> stickerList = [];

  List<String> bgList = [];
  List<Widget> bgButtonList = [];

  bool _isColorImage = true;
  String _backgroundColorImage = 'assets/background/bg_whitespace.png';

  final dio = Dio();
  List<Widget> imageOnscreen = [];
  // ignore: prefer_final_fields
  final blackholeKey = GlobalKey();
  late Rect iconRect = Rect.zero;
  bool _showDrawingPage = false;

  //캡쳐에 필요한 값들
  final int _counter = 0;
  late Uint8List? _imageFile;
  final double _appBarHeight = 56.0;
  bool _isCaptured = false;

  ScreenshotController screenshotController = ScreenshotController();

  //Textfield용 focus 조절장치
  final focuseNode = FocusNode();

  MediaType contentType = MediaType.parse('image/jpeg');

  late FToast fToast;

  @override
  void initState() {
    // 초기 이미지 목록에 따른 버튼을 생성하기 위한 state 저장

    checkItem();

    fToast = FToast();
    fToast.init(context);
  }

  void checkItem() async {
    Response response;
    final token = await SecureStorage().getAccessToken();
    // print('이게 토큰이야 $token');

    response = await dio.get(
      'http://k8a803.p.ssafy.io:8080/shop/checkitem',
      options: Options(headers: {'Authorization': token}),
    );

    setState(() {
      for (Map<String, dynamic> dt in response.data['itemList']) {
        if (dt['haveItem']) {
          if (dt['itemFileName'][0] == 'b' && dt['itemFileName'][1] == 'g') {
            // print('이거 bg $dt');
            bgList.add('assets/background/${dt['itemFileName']}');
          } else {
            // print('이건 image $dt');
            imageList.add('assets/${dt['itemFileName']}');
          }
        }
      }

      for (String ads in imageList) {
        stickerList.add(stickerButton(
          address: ads,
          addSticker: _addSticker,
        ));
      }

      for (String ads in bgList) {
        bgButtonList.add(backgroundButton(
            address: ads,
            changeBackgroundImage: _changeBackgroundImage,
            changeBackgroundType: _changeBackgroundType));
      }
    });
    // print('이게 지금 데이터야 ${response.data['itemList']}');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _changeBackgroundImage(String str) {
    setState(() {
      _backgroundColorImage = str;
    });
  }

  void _changeBackgroundType(bool result) {
    setState(() {
      _isColorImage = result;
    });
  }

  // 배경색 변화 버튼을 위한 함수
  void _changeBackgroundColor(Color color) {
    setState(() {
      _backgroundColor = color;
    });
  }

  // 사용자의 갤러리에서 이미지를 불러오기 위한 함수
  Future getImage() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (PickedFile != null) {
        _backgroundImage = File(PickedFile.path);
      } else {
        _backgroundImage = null;
      }
    });
    _changeBackgroundType(false);
  }

  // bottomsheet을 보이는가 안보이는가를 판단
  void _toggleBottomSheet() {
    setState(() {
      _isBottomSheetOpen = !_isBottomSheetOpen;
    });
  }

  //사용자에게 사진을 찍어 저장하도록 한다.
  Future takeShot() async {
    final PickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    setState(() {
      if (PickedFile != null) {
        _backgroundImage = File(PickedFile.path);
      } else {
        _backgroundImage = null;
      }
    });
    _changeBackgroundType(false);
  }

  void _showBlackhole() {
    setState(() {
      _isBlackhole = true;
    });
  }

  void _hideBlackhole() {
    setState(() {
      _isBlackhole = false;
    });
  }

  void _checkBlackhole(bool intersection) {
    if (intersection) {
      if (!_isBlackholeActive) {
        setState(() {
          _isBlackholeActive = true;
        });
      }
    } else {
      if (_isBlackhole) {
        setState(() {
          _isBlackholeActive = false;
        });
      }
    }
  }

  // sticker를 추가하는 함수
  void _addSticker(String str) {
    setState(() {
      imageOnscreen.add(
        Sticker(
          // globalkey: _keys.last,
          adress: str,
          showBlackhole: _showBlackhole,
          hideBlackhole: _hideBlackhole,
          checkBlackhole: _checkBlackhole,
          iconkey: blackholeKey,
          // changeOrder: _changeOrder,
        ),
      );
    });
  }

  void _toggleDrawingPage() {
    setState(() {
      _showDrawingPage = !_showDrawingPage;
    });
  }

  // 글을 작성완료하는 현재 위치를 구해서 post하는 함수
  void _gainCurrentLocation(
      BuildContext context, MultipartFile multipartfile) async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: geolocatorEnums.LocationAccuracy.high,
    );
    final NLatLng newPosition = NLatLng(
      double.parse(position.latitude.toStringAsFixed(4)),
      double.parse(position.longitude.toStringAsFixed(4)),
    );

    final token = await SecureStorage().getAccessToken();
    // print('position은 ${newPosition.latitude}, ${newPosition.longitude}');

    FormData formData = FormData();

    formData.fields.add(MapEntry('postContent', text));

    formData.fields
        .add(MapEntry('postLatitude', newPosition.latitude.toString()));

    formData.fields
        .add(MapEntry('postLongitude', newPosition.longitude.toString()));

    formData.files.add(MapEntry('multipartFile', multipartfile));

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        'http://k8a803.p.ssafy.io:8080/api/posts',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Authorization': token,
          },
        ),
      );

      // print(response);
    } catch (e) {
      _errorToast();
      // print(e);
    }
  }

  _starToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("성공적으로 별을 남겼습니다."),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  _errorToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red[400],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check),
          SizedBox(
            width: 12.0,
          ),
          Text("별을 남기는데 실패했습니다."),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1920,
      minWidth: 1080,
      quality: 50,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(builder: (context) {
      return Screenshot(
        controller: screenshotController,
        child: Container(
          decoration: BoxDecoration(
            image: _isColorImage
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(_backgroundColorImage),
                  )
                : DecorationImage(
                    fit: BoxFit.cover,
                    image: FileImage(_backgroundImage!),
                  ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              toolbarHeight: _appBarHeight,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: !_isCaptured
                  ? IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    )
                  : null,
              actions: !_isCaptured
                  ? [
                      IconButton(
                        onPressed: () {
                          // print(text);
                          setState(() {
                            _showDrawingPage = false;
                            _isCaptured = true;
                          });
                          screenshotController.capture().then((image) async {
                            final result = await testComporessList(image!);

                            MultipartFile multipartFile =
                                MultipartFile.fromBytes(
                              result,
                              filename: 'image.jpg',
                              contentType: contentType,
                            );

                            _gainCurrentLocation(context, multipartFile);

                            _starToast();

                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const NavBar(index: 1),
                              ),
                              (route) => false,
                            );
                          }).catchError((onError) {
                            print('여긴 423 $onError');
                          });
                        },
                        icon: const Icon(
                          Icons.check,
                          color: Colors.black,
                        ),
                      ),
                    ]
                  : null,
            ),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: <Widget>[
                  DrawingPage(
                    showDrawingPage: _showDrawingPage,
                  ),
                  if (!_showDrawingPage)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(0, -50),
                            child: IntrinsicWidth(
                              child: TextField(
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                controller: _controller
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _controller.text.length),
                                  ),
                                onChanged: (String newVal) {
                                  final lines = newVal.split('/n').length;
                                  if (newVal.length <= _maxLength &&
                                      lines <= _maxLines) {
                                    text = newVal;
                                  } else {
                                    _controller.text = text;
                                  }
                                },
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                minLines: 2,
                                style: const TextStyle(
                                  fontSize: 25,
                                  height: 1.25,
                                  letterSpacing: 1.0,
                                ),
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '아무 글이나 입력하세요.'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  // 여기부터 개별 이미지 위젯
                  ...imageOnscreen,
                  if (_isBlackhole)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Padding(
                          key: blackholeKey,
                          padding: const EdgeInsets.all(35),
                          child: Icon(
                            Icons.delete,
                            size: _isBlackholeActive ? 60 : 40,
                            color:
                                _isBlackholeActive ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            floatingActionButton: Container(
              // duration: const Duration(milliseconds: 200),
              // curve: Curves.linear,
              margin: EdgeInsets.only(
                  bottom: _isBottomSheetOpen ? 55 : 0, right: 0.0),
              child: Visibility(
                visible: !_isCaptured,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    MyFloatingButton3(toggleDrawingPage: _toggleDrawingPage),
                    MyFloatingButton1(appState: this),
                    MyFloatingButton2(appState: this),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class MyFloatingButton1 extends StatelessWidget {
  final _PostPageState appState;

  const MyFloatingButton1({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: () {
          final tabController =
              TabController(length: 2, vsync: Scaffold.of(context));
          appState._toggleBottomSheet();
          showModalBottomSheet(
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              )),
              backgroundColor: const Color.fromARGB(255, 190, 112, 201),
              context: context,
              builder: (BuildContext context) {
                return SizedBox(
                  height: 270,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          color: const Color.fromRGBO(248, 248, 248, 1),
                          child: TabBar(
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.black87,
                            indicator: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(15),
                                  topLeft: Radius.circular(15),
                                ),
                              ),
                              color: Color.fromARGB(255, 190, 112, 201),
                            ),
                            controller: tabController,
                            tabs: const <Widget>[
                              Tab(
                                text: '배경',
                              ),
                              Tab(
                                text: '스티커',
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                crossAxisCount: 4,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 13,
                                children: appState.bgButtonList,
                              ),
                            ),
                            Container(
                              color: const Color.fromARGB(255, 190, 112, 201),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GridView.count(
                                  crossAxisCount: 4,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 13,
                                  children: appState.stickerList,
                                ),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ),
                );
              }).whenComplete(() => appState._toggleBottomSheet());
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.color_lens_outlined));
  }
}

class MyFloatingButton2 extends StatelessWidget {
  final _PostPageState appState;

  const MyFloatingButton2({
    Key? key,
    required this.appState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        appState._toggleBottomSheet();
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            )),
            backgroundColor: const Color.fromARGB(255, 190, 112, 201),
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            appState.getImage();
                          },
                          child: const Text('사진 불러오기'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            appState.takeShot();
                          },
                          child: const Text('사진 촬영하기'),
                        ),
                        // ElevatedButton(
                        //   onPressed: () {
                        //     appState._deleteImage();
                        //   },
                        //   child: const Text('사진 제거'),
                        // )
                      ],
                    ),
                  ));
            }).whenComplete(() => appState._toggleBottomSheet());
      },
      backgroundColor: Colors.deepPurple[100],
      child: const Icon(Icons.photo_camera_back),
    );
  }
}

class MyFloatingButton3 extends StatelessWidget {
  final toggleDrawingPage;

  const MyFloatingButton3({
    super.key,
    required this.toggleDrawingPage,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: UniqueKey(),
      onPressed: () {
        toggleDrawingPage();
      },
      child: const Icon(Icons.note_alt_outlined),
    );
  }
}
