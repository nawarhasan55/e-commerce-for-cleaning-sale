import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../components/textformfield.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController userName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool showPassword = true;

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
                      "SignUp",
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
                    Text(
                      "Username",
                      style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TestTextFormField(
                      hinttext: 'Enter Your Username',
                      mycontroller: userName,
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      },
                      obscureTextbool: false,
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
                      keyboardType: TextInputType.emailAddress,
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
                      obscureTextbool: showPassword,
                      suffixIcon: showPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      onPressedIcon: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                      mycontroller: password,
                      validator: (val) {
                        if (val == "") {
                          return "can't be empty";
                        }
                      },
                      //keyboardType: TextInputType.emailAddress,
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
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                              Get.to(() => Login());
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                print('The password provided is too weak.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'The password provided is too weak.',
                                ).show();
                              } else if (e.code == 'email-already-in-use') {
                                print(
                                    'The account already exists for that email.');
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc:
                                      'The account already exists for that email.',
                                ).show();
                              }
                            } catch (e) {
                              print(e);
                            }
                          }
                        },
                        child: Text(
                          "SignUp",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        color: Colors.blue[900],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Get.off(() => Login());
                      },
                      child: Row(
                        children: [
                          Text(
                            "Have An Account?",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800]),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Login",
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
