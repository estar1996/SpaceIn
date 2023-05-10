import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/common/navbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
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
                      builder: (context) => NavBar(index: 1),
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
                      builder: (context) => NavBar(index: 3),
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
                      builder: (context) => NavBar(index: 1),
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
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
