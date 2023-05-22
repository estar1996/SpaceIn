import 'package:flutter/material.dart';
import 'package:frontend/page/homepage/home_model.dart';
import 'dart:math';
import 'package:frontend/common/navbar.dart';
import 'package:frontend/page/post_write/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  final List<Planet> _planetlist = planetList;
  final int _startIndex = 1;
  final int _endIndex = 3;

  double get _currentOffset {
    bool inited = _pageController.hasClients &&
        _pageController.position.hasContentDimensions;
    return inited ? _pageController.page! : _pageController.initialPage * 1.0;
  }

  int get _currentIndex {
    int index = _currentOffset.round() % _planetlist.length;
    if (index < 0) {
      index += _planetlist.length;
    }
    return index;
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 3);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backlogo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            return _buildScreen();
          },
        ),
      ),
    );
  }

  Stack _buildScreen() {
    final Size size = MediaQuery.of(context).size;
    final Planet currentPlanet =
        _planetlist[(_currentIndex + 1) % _planetlist.length];
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: size.width * 1.0,
          child: BgImage(
            currentIndex: _currentIndex,
            space: currentPlanet,
            pageOffset: _currentOffset,
          ),
        ),
        SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 10),
              Text(
                _planetlist[(_currentIndex + 1) % _planetlist.length].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w100,
                  color: Colors.white,
                  fontFamily: 'Roboto', // 로봇 우주같은 느낌의 폰트 선택
                  letterSpacing: 2.0, // 글자 간격 조정
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5), // 그림자 색상
                      blurRadius: 2, // 그림자의 흐림 정도
                      offset: const Offset(2, 2), // 그림자의 위치
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.1),
            ],
          ),
        ),
        Center(
          child: SizedBox(
            height: size.width,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                double value = 0.0;
                double vp = 30;
                double scale = max(vp, (_currentOffset - index).abs());

                if (_pageController.position.haveDimensions) {
                  value = index.toDouble() - (_pageController.page ?? 0);
                  value = (value * 0.7).clamp(-1, 1);
                }

                int displayIndex = (index + _startIndex) % _planetlist.length;

                return GestureDetector(
                  onTap: () {
                    int tappedIndex =
                        (index + _startIndex) % _planetlist.length;
                    print(tappedIndex);
                    if (tappedIndex == 0) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) =>
                                NavBar(index: tappedIndex + 1)),
                      );
                    }

                    if (tappedIndex >= _startIndex &&
                        tappedIndex <= _endIndex) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => (tappedIndex == 3
                              ? const PostPage()
                              : NavBar(index: tappedIndex + 1)),
                        ),
                      );
                    }
                  },
                  child: Transform.rotate(
                    angle: pi * value,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 200 - scale * 5),
                      child: FittedBox(
                        child: Image.asset(
                          _planetlist[displayIndex].image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class BgImage extends StatefulWidget {
  const BgImage({
    Key? key,
    required this.currentIndex,
    required this.space,
    required this.pageOffset,
  }) : super(key: key);

  final int currentIndex;
  final Planet space;
  final double pageOffset;

  @override
  State<BgImage> createState() => _BgImageState();
}

class _BgImageState extends State<BgImage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double value = 0.0;
    value = (widget.pageOffset - widget.currentIndex).abs();
    return Opacity(
      opacity: 0.2,
      child: Transform.rotate(
        angle: pi * value + pi / 180,
        child: SizedBox(
          width: size.width * 1.5,
          height: size.width * 1.5,
          child: Image.asset(
            widget.space.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
