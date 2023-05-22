import 'package:flutter/material.dart';
import 'package:frontend/common/navbar.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/data/profile_data.dart';
import 'package:frontend/page/profile/profile_page.dart';

class ChangeNickname extends StatefulWidget {
  const ChangeNickname({Key? key}) : super(key: key);

  @override
  State<ChangeNickname> createState() => _ChangeNicknameState();
}

class _ChangeNicknameState extends State<ChangeNickname> {
  final _nicknameController = TextEditingController();

  Future sendNickname() async {
    // print('안녕!');
    // LoginApi().
    final String nickname = _nicknameController.text;
    final response = await ProfileApi().changeNickname(nickname);
    print(response);
    Navigator.of(context).pop();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavBar(index: 3)),
    );
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('닉네임 변경'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nicknameController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return '닉네임을 입력해주세요.';
            }
            return null;
          },
          decoration: const InputDecoration(
            hintText: '새로운 닉네임을 입력하세요.',
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('취소'),
        ),
        ElevatedButton(
          onPressed: () {
            sendNickname();
          },
          child: const Text('변경'),
        ),
      ],
    );
  }
}
