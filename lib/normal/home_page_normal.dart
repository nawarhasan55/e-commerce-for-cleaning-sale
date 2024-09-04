import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../auth/login.dart';
import 'categories_normal.dart';

class HomePageNormal extends StatelessWidget {
  const HomePageNormal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Get.off(
                  () => Login(),
                );
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: InkWell(
          onTap: () {
            Get.off(() => CategoriesNormal());
          },
          child: Text("WELCOM YOU ARE NORMAL USER PRESS TO CONTINUE"),
        ),
      ),
    );
  }
}
