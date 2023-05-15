import 'package:flutter/material.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/login/login_page.dart';

enum SampleItem { itemOne, itemTwo }

class PopupMenu extends StatefulWidget {
  const PopupMenu({Key? key}) : super(key: key);
  @override
  State<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  var selectedItem = '';
  final SecureStorage storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: Offset(100, 20),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      icon: Icon(
        Icons.settings_rounded,
        color: Colors.white,
      ),
      onSelected: (value) {
        if (value == 0) {
          storage.deleteAccessToken();
          storage.deleteRefreshToken();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginPage()));
        }
        setState(() {
          selectedItem = value.toString();
        });
        Navigator.pushNamed(context, value.toString());
      },
      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            //     onTap: () {
            //   Navigator.pop(context);
            // },
            child: Text('닉네임변경'),
          ),
          PopupMenuItem(
            value: 0,
            child: Text('로그아웃'),
          ),
        ];
      },
    );
  }
}
