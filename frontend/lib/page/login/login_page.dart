import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/api.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/homepage/home_geum.dart';
import 'package:frontend/page/login/data/login_data.dart';
import 'package:frontend/page/login/join_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
      // 'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  Dio dio = DataServerDio.instance();
  final SecureStorage _storage = SecureStorage();
  // GoogleSignInAccount? _currentUser;

  // bool _isAuthorized = false; // has granted permissions?
  // String _contactText = '';

  @override
  void initState() {
    super.initState();
    // fetchSecureStorage();
  }

  // token 발급
  Future<void> _handleSignIn(context) async {
    await _googleSignIn.signOut(); //
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('구글유저 정보 = $googleUser');
      String? accessToken = googleAuth.accessToken;
      print(accessToken);

      final response =
          await LoginApi().SendToken(accessToken, context, googleUser.email);

      // 토큰 만료시 재인증
      if (response == 500) {
        print('accessToken이 만료되었습니다. 다시 인증을 요청합니다.');
        await _googleSignIn.disconnect();
        await _googleSignIn.signIn();
        final GoogleSignInAccount? refreshedUser = _googleSignIn.currentUser;
        final GoogleSignInAuthentication refreshedAuth =
            await refreshedUser!.authentication;
        accessToken = refreshedAuth.accessToken;
      } else if (response == 401) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => JoinPage(
                    token: accessToken,
                    userEmail: googleUser.email,
                  )),
        );
      }

      // 로그인 성공!
      else {
        await _storage.setAccessToken(response["token"]);
        await _storage.setRefreshToken(response["refreshToken"]);
        print('이동안해?');
        // await _storage.setAccessToken(token);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } catch (error) {
      print("Error occured while signing in: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        height: size.height,
        width: size.width,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    width: 200,
                    image: AssetImage(
                      'assets/Rocket-2.png',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    onTap: () {
                      _handleSignIn(context);
                    },
                    child: Container(
                      width: 300,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(90),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Center(
                        child: Row(
                          children: [
                            const Image(
                              image: AssetImage('assets/google_login.png'),
                              width: 50,
                              height: 50,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  '구글 로그인',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
