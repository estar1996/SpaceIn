import 'package:flutter/material.dart';
import 'package:frontend/common/background.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/homepage/home_page.dart';
import 'package:frontend/page/login/data/login_data.dart';
import 'package:frontend/page/login/login_page.dart';

class JoinPage extends StatefulWidget {
  final String? token;
  final String userEmail;
  const JoinPage({Key? key, required this.token, required this.userEmail})
      : super(key: key);

  @override
  State<JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<JoinPage> {
  final TextEditingController _nicknameController = TextEditingController();
  FocusNode textFocus = FocusNode();
  final SecureStorage _storage = SecureStorage();

  @override
  void initState() {
    super.initState();
    // fetchSecureStorage();
  }

  Future joinUser() async {
    // LoginApi().
    final String nickname = _nicknameController.text;
    final response =
        await LoginApi().joinUser(widget.token, nickname, widget.userEmail);
    print(nickname);
    print(response);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
  // Future fetchSecureStorage() async {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(textFocus);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            TextButton(
                onPressed: joinUser,
                child: Text('제출',
                    style: TextStyle(
                      color: Colors.white,
                    )))
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Background(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '닉네임',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: TextField(
                    // focusNode: widget.textFocus,
                    maxLength: 12,
                    controller: _nicknameController,
                    decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '닉네임을 입력해주세요.',
                        hintStyle: TextStyle(
                          color: Colors.black45,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
