import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/api.dart';
import 'package:frontend/common/secure_storage.dart';
import 'package:frontend/page/homepage/home_geum.dart';
import 'package:frontend/page/login/data/login_data.dart';
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
    print('너뭐냐?');
    try {
      await _googleSignIn.signOut(); // 기존의 사용자 인증 정보 삭제
      print('로그인 시도');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      print('구글 로그인 성공');
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      print('$googleUser 구글유저');
      final String? accessToken = googleAuth.accessToken;
      final response =
          await LoginApi().SendToken(accessToken, context, googleUser.email);
      print(response);
      await _storage.setAccessToken(response["token"]);
      await _storage.setRefreshToken(response["refreshToken"]);
      print('이동안해?');
      // await _storage.setAccessToken(token);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (error) {
      print("Error occured while signing in: $error");
    }
  }

  // Future<void> signOutAndSignIn() async {
  //   await _googleSignIn.signOut(); // 기존의 사용자 인증 정보 삭제
  //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //   final GoogleSignInAuthentication googleAuth =
  //       await googleUser!.authentication;
  // 새로운 사용자 인증 정보 받아오기
  // ...

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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // ); // _handleSignIn(context);
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
