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
        // 로그아웃
        if (value == 0) {
          storage.deleteAccessToken();
          storage.deleteRefreshToken();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        }
        // 회원탈퇴
        else if (value == -1) {
          try {
            ProfileApi().UserDelete();
            print('삭제 명령 고고');

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
            );
          } catch (e) {
            print(e);
          }
        }
        // 닉네임 변경
        else if (value == 1) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ChangeNickname();
            },
          );
        }
        // setState(() {
        //   selectedItem = value.toString();
        // });
        // Navigator.pushNamed(context, value.toString());
      },
      itemBuilder: (BuildContext bc) {
        return const [
          PopupMenuItem(
            value: 1,
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
