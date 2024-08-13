import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required void Function() onVerificationComplete});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPasswordController = TextEditingController();
  TextEditingController phoneNumberController1 = TextEditingController();
  TextEditingController phoneNumberController2 = TextEditingController();
  TextEditingController otpController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode verifyPasswordFocusNode = FocusNode();
  FocusNode phoneNumberFocusNode1 = FocusNode();
  FocusNode phoneNumberFocusNode2 = FocusNode();
  FocusNode otpFocusNode = FocusNode();

  bool authOk = false;

  bool passwordHide = true;
  bool requestedAuth = false;
  late String verificationId;
  bool showLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential.user != null) {
        setState(() {
          print("인증완료 및 로그인성공");
          authOk = true;
          requestedAuth = false;
        });
        if (_auth.currentUser != null) {
          await _auth.currentUser!.delete();
          print("auth정보삭제");
        }
        print("auth정보삭제");
        _auth.signOut();
        print("phone로그인된것 로그아웃");
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        print("인증실패..로그인실패");
        showLoading = false;
      });

      await Fluttertoast.showToast(
          msg: e.message ?? '에러 발생',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          fontSize: 16.0);
    }
  }

  Future<UserCredential> signUpUserCredential(
      {required String email, required String password}) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      void errorToast(String message) {
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            fontSize: 16.0);
      }

      switch (e.code) {
        case "email-already-in-use":
          errorToast("이미 사용중인 이메일입니다");
          break;
        case "invalid-email":
          errorToast("잘못된 이메일 형식입니다");
          break;
        case "operation-not-allowed":
          errorToast("사용할 수 없는 방식입니다");
          break;
        case "weak-password":
          errorToast("비밀번호 보안 수준이 너무 낮습니다");
          break;
        default:
          errorToast("알수없는 오류가 발생했습니다");
      }
      rethrow; // 예외를 다시 던져 반환 타입과 일치시키기
    } catch (e) {
      Fluttertoast.showToast(
        msg: "알 수 없는 오류가 발생했습니다",
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        fontSize: 16.0,
      );
      rethrow;
    }
  }

  // 전화번호를 포맷팅하는 함수
String formatPhoneNumber(String phoneNumber) {
  // 사용자 입력에서 '0'을 포함한 경우 '+82' 국가 코드 추가
  if (phoneNumber.startsWith("0")) {
    return "+82${phoneNumber.substring(1)}";
  }
  // 이미 국가 코드가 포함된 경우 그대로 반환
  return phoneNumber;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('회원가입'),
        ),
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                  children: [
                    const Expanded(flex: 1, child: Text("이름")),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: TextFormField(
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                            isDense: true,
                            hintText: "이름 입력",
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(nameFocusNode),
                          focusNode: nameFocusNode,
                          keyboardType: TextInputType.name,
                          controller: nameController,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("이메일")),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              isDense: true,
                              hintText: "이메일 입력",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(passwordFocusNode),
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("비밀번호")),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              isDense: true,
                              hintText: "비밀번호 입력",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(verifyPasswordFocusNode),
                            focusNode: passwordFocusNode,
                            obscureText: passwordHide,
                            controller: passwordController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("")),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: TextFormField(
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 10.0),
                              isDense: true,
                              hintText: "비밀번호 재입력",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: verifyPasswordFocusNode,
                            obscureText: passwordHide,
                            controller: verifyPasswordController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Expanded(flex: 1, child: Text("휴대폰")),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                                child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: numberInsert(
                                      editAble: false,
                                      hintText: "010",
                                    )),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: numberInsert(
                                    editAble: authOk ? false : true,
                                    hintText: "0000",
                                    focusNode: phoneNumberFocusNode1,
                                    controller: phoneNumberController1,
                                    textInputAction: TextInputAction.next,
                                    maxLegnth: 4,
                                    widgetFunction: () {
                                      FocusScope.of(context)
                                          .requestFocus(phoneNumberFocusNode2);
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: numberInsert(
                                    editAble: authOk ? false : true,
                                    hintText: "0000",
                                    focusNode: phoneNumberFocusNode2,
                                    controller: phoneNumberController2,
                                    textInputAction: TextInputAction.done,
                                    maxLegnth: 4,
                                  ),
                                ),
                              ],
                            )),
                            const SizedBox(
                              width: 5,
                            ),
                            authOk
                                ? const ElevatedButton(
                                    onPressed: null, child: Text("인증완료"))
                                : phoneNumberController1.text.length == 4 &&
                                        phoneNumberController2.text.length == 4
                                    ? ElevatedButton(
                                        onPressed: () async {
                                          setState(() {
                                            showLoading = true;
                                          });
                                          await _auth.verifyPhoneNumber(
                                            timeout:
                                                const Duration(seconds: 60),
                                            codeAutoRetrievalTimeout:
                                                (String verificationId) {
                                              // Auto-resolution timed out...
                                            },
                                            phoneNumber: 
                                              // formatPhoneNumber("${phoneNumberController1.text.trim()}${phoneNumberController2.text.trim()}"),
                                                "+8210${phoneNumberController1.text.trim()}${phoneNumberController2.text.trim()}",
                                            verificationCompleted:
                                                (phoneAuthCredential) async {
                                              print("otp 문자옴");
                                            },
                                            verificationFailed:
                                                (verificationFailed) async {
                                              print(verificationFailed.code);

                                              print("코드발송실패");
                                              setState(() {
                                                showLoading = false;
                                              });
                                            },
                                            codeSent: (verificationId, resendingToken) async {
                                              print("코드보냄");
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "010-${phoneNumberController1.text}-${phoneNumberController2.text} 로 인증코드를 발송하였습니다. 문자가 올때까지 잠시만 기다려 주세요.",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.green,
                                                  fontSize: 12.0);
                                              setState(() {
                                                requestedAuth = true;
                                                FocusScope.of(context)
                                                    .requestFocus(otpFocusNode);
                                                showLoading = false;
                                                this.verificationId =
                                                    verificationId;
                                              });
                                            },
                                          );
                                        },
                                        child: const Text("인증요청"))
                                    : const ElevatedButton(
                                        onPressed: null, child: Text("인증요청")),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  authOk
                      ? const SizedBox()
                      : Visibility(
                          visible: requestedAuth,
                          child: Row(
                            children: [
                              const Expanded(flex: 1, child: Text("")),
                              Expanded(
                                flex: 3,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: numberInsert(
                                        editAble: true,
                                        hintText: "6자리 입력",
                                        focusNode: otpFocusNode,
                                        controller: otpController,
                                        textInputAction: TextInputAction.done,
                                        maxLegnth: 6,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          PhoneAuthCredential
                                              phoneAuthCredential =
                                              PhoneAuthProvider.credential(
                                                  verificationId:
                                                      verificationId,
                                                  smsCode: otpController.text);
                                          signInWithPhoneAuthCredential(
                                              phoneAuthCredential);
                                        },
                                        child: const Text("확인")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.length > 1 &&
                          passwordController.text.length > 1 &&
                          verifyPasswordController.text.length > 1) {
                        if (passwordController.text ==
                            verifyPasswordController.text) {
                          if (authOk) {
                            setState(() {
                              showLoading = true;
                            });

                            await signUpUserCredential(
                                email: emailController.text,
                                password: passwordController.text);

                            setState(() {
                              showLoading = false;
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "휴대폰 인증을 완료해주세요.",
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                fontSize: 16.0);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "비밀번호를 확인해 주세요.",
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "이메일 및 비밀번호를 입력해 주세요.",
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            fontSize: 16.0);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                        minimumSize: const Size(double.infinity, 0),
                        textStyle:
                            const TextStyle(fontWeight: FontWeight.bold)),
                    child: const Text('가입하기'),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
            Positioned.fill(
              child: Visibility(
                  visible: showLoading,
                  child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Center(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 80,
                              color: Colors.white,
                              child: const Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Text("잠시만 기다려 주세요"),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Opacity(
                                    opacity: 0,
                                    child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator()),
                                  ),
                                ],
                              )))))),
            )
          ],
        ));
  }

  Widget numberInsert({
    bool? editAble,
    String? hintText,
    FocusNode? focusNode,
    TextEditingController? controller,
    TextInputAction? textInputAction,
    Function? widgetFunction,
    int? maxLegnth,
  }) {
    return TextFormField(
      enabled: editAble,
      style: const TextStyle(
        fontSize: 12,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        isDense: true,
        counterText: "",
        hintText: hintText,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        disabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      textInputAction: textInputAction,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      focusNode: focusNode,
      controller: controller,
      maxLength: maxLegnth,
      onChanged: (value) {
        if (value.length >= maxLegnth!) {
          if (widgetFunction == null) {
            print("noFunction");
          } else {
            widgetFunction();
          }
        }
        setState(() {});
      },
      onEditingComplete: () {
        if (widgetFunction == null) {
          print("noFunction");
        } else {
          widgetFunction();
        }
      },
    );
  }
}
