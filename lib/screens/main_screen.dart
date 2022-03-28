import 'package:chat_app/add_image/add_image.dart';
import 'package:chat_app/config/palette.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// 인증을 위한 파이어베이스
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginSignUpScreen extends StatefulWidget {
  const LoginSignUpScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignUpScreen> createState() => _LoginSignUpScreenState();
}

class _LoginSignUpScreenState extends State<LoginSignUpScreen> {
  // 사용자 인증을 위한 변수
  final _authentification = FirebaseAuth.instance;

  bool showSpinner = false;

  bool isSignupScreen = true;
  final _formKey = GlobalKey<FormState>();
  // for saving account information
  String email = '';
  String password = '';
  String userName = '';

  void _checkLogout() {
    _authentification.signOut();
  }

  void _tryValidation() {
    final isValid = _formKey.currentState!.validate();
    if (isValid) {
      // 폼 전체의 값을 세이브
      _formKey.currentState!.save();
    }
  }

  Future<void>? _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Container(
              padding: const EdgeInsets.only(top: 20),
              width: 150,
              height: 300,
              child: const AddImage(),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _checkLogout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: ModalProgressHUD(
        // to show spinner while backend work is on progress
        inAsyncCall: showSpinner,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              // text widgets for introducing message
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Container(
                  height: 400,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage('image/forest_background.jpg'),
                    fit: BoxFit.fill,
                  )),
                  child: Container(
                    padding: const EdgeInsets.only(top: 90, left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                            text: const TextSpan(
                                text: 'Welcome',
                                style: TextStyle(
                                  fontSize: 20,
                                  wordSpacing: 1.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                children: [
                              TextSpan(
                                  text: ' to Giddoyo Chat',
                                  style: TextStyle(
                                      fontSize: 25,
                                      wordSpacing: 1.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                            ])),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Sign up to continue',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // TextformField
              Positioned(
                top: 180,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  // important! use of MediaQuery is for getting the exact size of the emulator being used
                  width: MediaQuery.of(context).size.width - 40,
                  height: isSignupScreen ? 280 : 250,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 3,
                        )
                      ]),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // login text
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  isSignupScreen = false;
                                });
                              }),
                              child: Column(
                                children: [
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSignupScreen
                                          ? Palette.textColor1
                                          : Palette.activeColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // widget 자체에 조건을 걸 수 있음
                                  if (!isSignupScreen)
                                    Container(
                                      height: 2,
                                      width: 50,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            ),
                            // sign up text
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSignupScreen = true;
                                });
                              },
                              child: Column(
                                children: [
                                  Text(
                                    'SIGN UP',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isSignupScreen
                                          ? Palette.activeColor
                                          : Palette.textColor1,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isSignupScreen)
                                    Container(
                                      height: 2,
                                      width: 50,
                                      color: Colors.orange,
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                        Form(
                          key: _formKey,
                          child: isSignupScreen
                              ? Column(
                                  children: [
                                    // login
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        key: const ValueKey(1),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter information';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          userName = value!;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.account_box_rounded,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1),
                                          hintText: 'user name',
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                    // email
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        key: const ValueKey(2),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter information';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          email = value!;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1),
                                          hintText: 'E-mail',
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                    // password
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        obscureText: true,
                                        key: const ValueKey(3),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter information';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          password = value!;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.password_sharp,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1),
                                          hintText: 'Password',
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    // login
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        key: const ValueKey(4),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter information';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          email = value!;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.email_sharp,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1),
                                          hintText: 'Enter email',
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                    ),
                                    // password
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        obscureText: true,
                                        key: const ValueKey(5),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'enter information';
                                          }
                                          return null;
                                        },
                                        onSaved: (value) {
                                          password = value!;
                                        },
                                        decoration: const InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.password_sharp,
                                            color: Palette.iconColor,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Palette.textColor1),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30))),
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Palette.textColor1),
                                          hintText: 'Password',
                                          contentPadding: EdgeInsets.all(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              // button
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen ? 430 : 390,
                // positioned 위젯이 가로방향으로 전체 스크린을 차지할 수 있도록 하는 값 설정
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        setState(() {
                          showSpinner = true;
                        });

                        if (isSignupScreen) {
                          _tryValidation();
                          await _showAlert(context);
                          try {
                            final newUser = await _authentification
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);

                            // 추가 정보 입력
                            FirebaseFirestore.instance
                                .collection('user')
                                .doc(newUser.user!.uid)
                                // map 의 형태로 데이터 입력
                                .set({'userName': userName, 'email': email});

                            // 잘 등록이 되었다면
                            if (newUser.user != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const ChatScreen())));
                              showSpinner = false;
                            }
                            // 화면 이동시 멈출 수 있도록 false 값으로 설정
                            setState(() {
                              showSpinner = false;
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                                  Text('Please Check your email and password'),
                              backgroundColor: Colors.blue,
                            ));
                          }
                        } else {
                          try {
                            _tryValidation();
                            final newUser = await _authentification
                                .signInWithEmailAndPassword(
                                    email: email, password: password);
                            if (newUser.user != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: ((context) => const ChatScreen())));
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please Check your email')));
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.red],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // google Login
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
                top: isSignupScreen
                    ? MediaQuery.of(context).size.height - 110
                    : MediaQuery.of(context).size.height - 150,
                right: 0,
                left: 0,
                child: Column(
                  children: [
                    isSignupScreen
                        ? const Text('or Sign up with')
                        : const Text('or Sign in with'),
                    const SizedBox(
                      height: 8,
                    ),
                    TextButton.icon(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          minimumSize: const Size(140, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Palette.googleColor,
                        ),
                        onPressed: () {},
                        icon: const Icon(Icons.add),
                        label: const Text('Google')),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
