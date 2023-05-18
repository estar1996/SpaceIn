import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/common/navbar.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/post_write/post_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

// final SecureStorage storage = SecureStorage();

class _HomePageState extends State<HomePage> {
  final SecureStorage storage = SecureStorage();
  late Future<String?> _refreshTokenFuture;
  String? _refreshToken;

  @override
  void initState() {
    super.initState();
    _refreshTokenFuture = storage.getRefreshToken();
    _refreshTokenFuture.then((value) {
      setState(() {
        _refreshToken = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(_refreshTokenFuture);
    print(_refreshToken);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Background(
            child: Stack(
          children: [
            Positioned(
              top: 50,
              left: 50,
              width: 300,
              height: 300,
              child: IconButton(
                icon: Image.asset('assets/SolarSystem.png'),
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NavBar(index: 2),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 300,
              left: 300,
              width: 100,
              height: 100,
              child: IconButton(
                icon: Image.asset('assets/Rocket-2.png'),
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NavBar(index: 3),
                    ),
                  );
                },
              ),
            ),
            //MAP PAGE
            Positioned(
              top: 600,
              left: 150,
              width: 300,
              height: 300,
              child: IconButton(
                icon: Image.asset('assets/Planet-2.png'),
                onPressed: () async {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const NavBar(index: 1),
                    ),
                  );
                },
              ),
            ),
            // WRITE PAGE
            Positioned(
              top: 300,
              left: 000,
              width: 300,
              height: 300,
              child: IconButton(
                icon: Image.asset('assets/Telescope.png'),
                onPressed: () {
                  // 클릭 시 이동할 페이지
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PostPage()),
                  );
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
