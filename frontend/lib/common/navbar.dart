import 'package:flutter/material.dart';
import 'package:frontend/common/colors.dart';
import 'package:frontend/page/homepage/home_geum.dart';
import 'package:frontend/page/profile/profile_page.dart';
import 'package:frontend/src/map/mainmap.dart';
import 'package:frontend/page/shop/shop_page.dart';
import 'package:frontend/page/post_write/post_page.dart';

class NavBar extends StatefulWidget {
  final int index;
  const NavBar({Key? key, required this.index}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int currentIndex = widget.index;
  final screens = [
    const HomePage(),
    const MainMap(),
    const ShopPage(),
    const ProfilePage(),
    // LoginPage(),
    // const PostPage(),
    // ProfilePage(),
  ];

  void _onItemTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // int currentIndex = widget.index;
    // ConnectRoute _connectRoute = ConnectRoute();
    return Scaffold(
      body: screens[currentIndex],
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            colors: [
              Color(0xFF96C7EB),
              Color(0xFFD06BCC),
            ],
          ),
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          elevation: 0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostPage()),
            );
          },
          backgroundColor: Colors.transparent,
          child: const Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 75,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          color:
                              currentIndex == 0 ? PRIMARY_COLOR : Colors.grey,
                        ),
                        Text(
                          '홈',
                          style: TextStyle(
                            color:
                                currentIndex == 0 ? PRIMARY_COLOR : Colors.grey,
                            fontWeight: currentIndex == 0
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 75,
                    onPressed: () {
                      currentIndex = 1;
                      _onItemTap(currentIndex);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map_rounded,
                          color:
                              currentIndex == 1 ? PRIMARY_COLOR : Colors.grey,
                        ),
                        Text(
                          '지도',
                          style: TextStyle(
                            color:
                                currentIndex == 1 ? PRIMARY_COLOR : Colors.grey,
                            fontWeight: currentIndex == 1
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 75,
                    onPressed: () {
                      currentIndex = 2;
                      _onItemTap(currentIndex);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_rounded,
                          color:
                              currentIndex == 2 ? PRIMARY_COLOR : Colors.grey,
                        ),
                        Text(
                          '상점',
                          style: TextStyle(
                            color:
                                currentIndex == 2 ? PRIMARY_COLOR : Colors.grey,
                            fontWeight: currentIndex == 2
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 70,
                    onPressed: () {
                      currentIndex = 3;
                      _onItemTap(currentIndex);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_rounded,
                          color:
                              currentIndex == 3 ? PRIMARY_COLOR : Colors.grey,
                        ),
                        Text(
                          '프로필',
                          style: TextStyle(
                            color:
                                currentIndex == 3 ? PRIMARY_COLOR : Colors.grey,
                            fontWeight: currentIndex == 3
                                ? FontWeight.bold
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
