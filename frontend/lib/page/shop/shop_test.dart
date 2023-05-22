import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/page/post_write/sticker/background_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/page/post_write/drawing/drawing_page.dart';
import 'package:frontend/page/post_write/sticker/sticker.dart';
import 'package:frontend/page/post_write/sticker/sticker_button.dart';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class ShopTest extends StatefulWidget {
  const ShopTest({super.key});

  @override
  State<ShopTest> createState() => _ShopTestState();
}

class _ShopTestState extends State<ShopTest> {
  final TextEditingController _controller = TextEditingController();
  String text = "";
  final int _maxLength = 140;
  final int _maxLines = 10;
  File? _backgroundImage;
  bool _isBottomSheetOpen = false;
  bool _isBlackhole = false;
  bool _isBlackholeActive = false;
  List<String> imageList = [
    'assets/Asteroid.png',
    'assets/Astronaut-1.png',
    'assets/Astronaut-2.png',
    'assets/Astronaut-3.png',
    'assets/Astronaut-4.png',
    'assets/Comet.png',
    'assets/Planet & Rocket.png',
    'assets/Planet-1.png',
    'assets/Planet-2.png',
    'assets/Planet-3.png',
    'assets/Planet-4.png',
    'assets/Planet-5.png',
    'assets/Planet-6.png',
    'assets/Planet-7.png',
    'assets/Planet-8.png',
    'assets/Planet-9.png',
    'assets/Planet-10.png',
    'assets/Planet-11.png',
    'assets/Planet-12.png',
    'assets/Planet-13.png',
    'assets/Planet-14.png',
    'assets/Planet-15.png',
    'assets/Rocket-1.png',
    'assets/Rocket-2.png',
    'assets/Rover.png',
    'assets/SolarSystem.png',
    'assets/SpaceSatellite.png',
    'assets/SpaceShip-1.png',
    'assets/SpaceShip-2.png',
    'assets/Star1.png',
    'assets/Star2_1.png',
    'assets/Star2_2.png',
    'assets/Star2_3.png',
    'assets/Star2_4.png',
    'assets/Star2_5.png',
    'assets/Star2.png',
    'assets/Telescope.png',
    'assets/UFO.png',
  ];
  List<Widget> stickerList = [];

  List<String> bgList = [
    'assets/background/bg_blackspace.png',
    'assets/background/bg_bluered.png',
    'assets/background/bg_box.png',
    'assets/background/bg_check.png',
    'assets/background/bg_check2.png',
    'assets/background/bg_cute.png',
    'assets/background/bg_flower.png',
    'assets/background/bg_gradient.png',
    'assets/background/bg_gradient2.png',
    'assets/background/bg_greenaura.png',
    'assets/background/bg_letter.png',
    'assets/background/bg_letter2.png',
    'assets/background/bg_line.png',
    'assets/background/bg_mountain.png',
    'assets/background/bg_newspaper.png',
    'assets/background/bg_night.png',
    'assets/background/bg_ocean.png',
    'assets/background/bg_paper.png',
    'assets/background/bg_pearl.png',
    'assets/background/bg_photoedit.png',
    'assets/background/bg_photoedit2.png',
    'assets/background/bg_sky.png',
    'assets/background/bg_sky2.png',
    'assets/background/bg_twinkle.png',
    'assets/background/bg_whitespace.png',
  ];
  List<Widget> bgButtonList = [];

  bool _isColorImage = true;
  String _backgroundColorImage = 'assets/background/bg_whitespace.png';

  final dio = Dio();
  List<Widget> imageOnscreen = [];
  // ignore: prefer_final_fields
  final blackholeKey = GlobalKey();
  late Rect iconRect = Rect.zero;
  bool _showDrawingPage = false;

  //Textfield용 focus 조절장치
  final focuseNode = FocusNode();

  MediaType contentType = MediaType.parse('image/jpeg');

  late FToast fToast;

  @override
  void initState() {
    // 초기 이미지 목록에 따른 버튼을 생성하기 위한 state 저장

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Builder(builder: (context) {
      return Container(
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
            toolbarHeight: 56,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
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
                                  TextPosition(offset: _controller.text.length),
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
                                  hintText: '아이템을 체험해보세요.'),
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
                          color: _isBlackholeActive ? Colors.red : Colors.green,
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
      );
    });
  }
}

class MyFloatingButton1 extends StatelessWidget {
  final _ShopTestState appState;

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
  final _ShopTestState appState;

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
