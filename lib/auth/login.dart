import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_courses/components/custombuttonauth.dart';
import 'package:flutter_courses/components/customlogoauth.dart';
import 'package:flutter_courses/components/textformfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool loding = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loding
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 50),
                      const CustomLogoAuth(),
                      Container(height: 20),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(height: 10),
                      const Text(
                        "Login To Continue Using The App",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(height: 20),
                      const Text(
                        "Email",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(height: 10),
                      CustomTextForm(
                        validator: (val) {
                          if (val == "") {
                            return "Your Email can't be empte";
                          }
                          return null;
                        },
                        hinttext: "ُEnter Your Email",
                        mycontroller: email,
                      ),
                      Container(height: 10),
                      const Text(
                        "Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(height: 10),
                      CustomTextForm(
                        validator: (val) {
                          if (val == "") {
                            return "Your passwor can't be empte";
                          }
                          return null;
                        },
                        hinttext: "ُEnter Your Password",
                        mycontroller: password,
                      ),
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: email.text,
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.topRight,
                          child: const Text(
                            "Forgot Password ?",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomButtonAuth(
                    title: "login",
                    onPressed: () async {
                      try {
                        loding = true;
                        setState(() {});
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text,
                            );
                        loding = false;
                        setState(() {});

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'تم تسجيل الدخول بنجاح',
                          desc: 'مرحباً بك!',
                          btnOkOnPress: () {
                            loding = false;
                            setState(() {});
                            if (credential.user!.emailVerified) {
                              Navigator.popAndPushNamed(context, "homepage");
                            } else {
                              loding = false;
                              setState(() {});
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'خطأ في تسجيل الدخول',
                                desc:
                                    ' الرجاء تفعيل حساب من البريد المرسل الى الايميل الخاص بك',
                                btnOkOnPress: () {},
                              ).show();
                            }
                            loding = false;
                          },
                        ).show();
                      } on FirebaseAuthException catch (e) {
                        String message = "";
                        DialogType type = DialogType.error;

                        if (e.code == 'user-not-found') {
                          message = 'البريد الإلكتروني غير موجود';
                        } else if (e.code == 'wrong-password') {
                          message = 'كلمة المرور غير صحيحة';
                        } else {
                          message = 'حدث خطأ: ${e.message}';
                          type = DialogType.warning;
                        }
                        loding = false;
                        setState(() {});
                        AwesomeDialog(
                          context: context,
                          dialogType: type,
                          animType: AnimType.rightSlide,
                          title: 'خطأ في تسجيل الدخول',
                          desc: message,
                          btnOkOnPress: () {},
                        ).show();
                      }
                    },
                  ),
                  Container(height: 20),

                  MaterialButton(
                    height: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Colors.red[700],
                    textColor: Colors.white,
                    onPressed: () async {
                      setState(() {
                        loding = true;
                      });

                      try {
                        await signInWithGoogle();

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'تم تسجيل الدخول باستخدام Google',
                          desc: 'مرحباً بك!',
                          btnOkOnPress: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              "homepage",
                              (route) => false,
                            );
                          },
                        ).show();
                      } catch (e) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'خطأ في تسجيل الدخول',
                          desc:
                              'فشل تسجيل الدخول باستخدام Google.\n${e.toString()}',
                          btnOkOnPress: () {},
                        ).show();
                      }

                      setState(() {
                        loding = false;
                      });
                    },

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Login With Google  "),
                        Image.asset("images/4.png", width: 20),
                      ],
                    ),
                  ),
                  Container(height: 20),
                  // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed("signup");
                    },
                    child: const Center(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: "Don't Have An Account ? "),
                            TextSpan(
                              text: "Register",
                              style: TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
