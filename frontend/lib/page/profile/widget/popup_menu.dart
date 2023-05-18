import 'package:flutter/material.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/login/login_page.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/widget/nickname_modal.dart';

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
      offset: Offset(100, 50),
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
        } else if (value == -1) {
          try {
            ProfileApi().UserDelete();
            print('삭제 명령 고고');
            storage.deleteAccessToken();
            storage.deleteRefreshToken();
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          } catch (e) {
            print(e);
          }
          ;
        }
        setState(() {
          selectedItem = value.toString();
        });
        Navigator.pushNamed(context, value.toString());
      },
      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            // onTap: ChangeNickname(),
            child: Text('닉네임변경'),
          ),
          PopupMenuItem(
            value: 0,
            child: Text('로그아웃'),
          ),
          PopupMenuItem(
            value: -1,
            child: Text('회원탈퇴'),
          )
        ];
      },
    );
  }
}
