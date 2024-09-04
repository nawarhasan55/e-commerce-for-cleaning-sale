import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled2/auth/signup.dart';
import 'package:untitled2/normal/home_page_normal.dart';
import '../components/textformfield.dart';
import '../home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool showPassword = true;

  Future signInWithGoogle() async {
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
    await FirebaseAuth.instance.signInWithCredential(credential);
    final String ll = googleUser!.email ;
    if(ll=="nawar.ali.hasan55@gmail.com"){
      Get.off(() => HomePage());
    }else{
      Get.off(()=>HomePageNormal()) ;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[100],
        appBar: AppBar(
          backgroundColor: Colors.cyan[100],
        ),
        body: Container(
          padding: EdgeInsets.all(15),
          child: ListView(
            children: [
              Form(
                key: formState,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Login To Continue Using The App",
                      style: TextStyle(
                          fontSize: 20,
                          // fontWeight: FontWeight.bold,
                          color: Colors.deepOrange),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Email",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TestTextFormField(
                      hinttext: 'Enter Your Email',
                      mycontroller: email,
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      },
                      obscureTextbool: false,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TestTextFormField(
                      hinttext: "Enter Your Password",
                      mycontroller: password,
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      },
                      obscureTextbool: showPassword,
                      suffixIcon: showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onPressedIcon: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (email.text == "") {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'please entry your email',
                          ).show();
                          return;
                        }
                        try {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: email.text);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Warning',
                            desc:
                                'Sure From Your Email And Reset Your Password',
                          ).show();
                        } on FirebaseAuthException catch (e) {
                          print("===============");
                          print(e);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10, bottom: 20),
                        alignment: Alignment.topRight,
                        child: Text(
                          "Forget Password?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800]),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () async {
                          if (formState.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              if (credential.user!.emailVerified) {
                                if (email.text ==
                                    "nawar.ali.hasan55@gmail.com") {
                                  Get.off(() => HomePage());
                                } else {
                                  Get.off(() => HomePageNormal());
                                }
                              } else {
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'Go To Your Email And Verify',
                                ).show();
                              }
                            } on FirebaseAuthException catch (e) {
                              print("======================");
                              print(e);

                              print("======================");
                              print(e.code);
                              if (e.code == 'invalid-email') {
                                print('No user found for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'No user found for that email.',
                                ).show();
                              } else if (e.code == 'invalid-credential') {
                                print('Wrong password provided for that user.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'Wrong password provided for that user.',
                                ).show();
                              }
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue[800],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        child: Text(
                          "Login With Google",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.deepOrange,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(() => SignUp());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Don't Have An Account?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Register",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
