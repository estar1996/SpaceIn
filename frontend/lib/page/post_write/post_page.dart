import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/page/post_write/drawing/drawing_page.dart';
import 'package:frontend/page/post_write/sticker/sticker.dart';
import 'package:frontend/page/post_write/sticker/sticker_button.dart';

import 'package:screenshot/screenshot.dart';

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
  late List<String> imageList;
  List<Widget> imageOnscreen = [];
  List<Widget> stickerList = [];
  // ignore: prefer_final_fields
  final blackholeKey = GlobalKey();
  late Rect iconRect = Rect.zero;
  bool _showDrawingPage = false;

  //캡쳐에 필요한 값들
  final int _counter = 0;
  late Uint8List? _imageFile;
  double _appBarHeight = 56.0;
  bool _isCaptured = false;

  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    // 초기 이미지 목록에 따른 버튼을 생성하기 위한 state 저장
    imageList = [
      'assets/Asteroid.png',
      'assets/Astronaut-1.png',
      'assets/Planet-14.png',
      'assets/Star1.png'
    ];

    for (String ads in imageList) {
      stickerList.add(stickerButton(
        address: ads,
        addSticker: _addSticker,
      ));
    }
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
  }

  // 현재 배경 사진으로 저장된 값을 없앤다.
  void _deleteImage() {
    setState(() {
      _backgroundImage = null;
    });
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

  Future<dynamic> ShowCapturedWidget(
      BuildContext context, Uint8List capturedImage) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Captured widget screenshot"),
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_isBottomSheetOpen) {
      Navigator.of(context).pop();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MaterialApp(
        home: Builder(builder: (context) {
          return Screenshot(
            controller: screenshotController,
            child: Container(
              decoration: BoxDecoration(
                image: _backgroundImage != null
                    ? DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_backgroundImage!),
                      )
                    : null,
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.white,
                appBar: AppBar(
                  toolbarHeight: _appBarHeight,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.black,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _appBarHeight = 0;
                          _isCaptured = true;
                        });
                        screenshotController.capture().then((image) async {
                          ShowCapturedWidget(context, image!);
                          setState(() {
                            _imageFile = image;
                            _appBarHeight = 56.0;
                            _isCaptured = false;
                          });
                        }).catchError((onError) {
                          print(onError);
                        });
                      },
                      icon: const Icon(
                        Icons.check,
                        color: Colors.black,
                      ),
                    ),
                  ],
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
                                    controller: _controller
                                      ..selection = TextSelection.fromPosition(
                                        TextPosition(
                                            offset: _controller.text.length),
                                      ),
                                    onChanged: (String newVal) {
                                      final lines = newVal.split('\n').length;
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
                                color: _isBlackholeActive
                                    ? Colors.red
                                    : Colors.green,
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
                        MyFloatingButton3(
                            toggleDrawingPage: _toggleDrawingPage),
                        MyFloatingButton1(appState: this),
                        MyFloatingButton2(appState: this),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
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
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              children: <Widget>[
                                ElevatedButton(
                                  child: const Text('Close BottomSheet'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Black'),
                                  onPressed: () {
                                    appState
                                        ._changeBackgroundColor(Colors.black45);
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('White'),
                                  onPressed: () {
                                    appState
                                        ._changeBackgroundColor(Colors.white);
                                  },
                                ),
                              ],
                            ),
                            Container(
                              color: const Color.fromARGB(255, 190, 112, 201),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: appState.stickerList,
                              ),
                            )
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
