import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled2/cart/cart.dart';
import 'package:provider/provider.dart';
import 'auth/login.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBcGFbuvP3xTuVL5hdLaYtdGEmWWHCE6jk",
          appId: "1:18013759983:android:0b98dd357322e11462ae1a",
          messagingSenderId: "18013759983",
          projectId: "university-f5fe8",
        storageBucket: "university-f5fe8.appspot.com"
      ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('===========================User is currently signed out!');
      } else {
        print('========================User is signed in!');
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context){
      return Cart() ;
    },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.purple[200],
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
            )
        ),
        home: (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.emailVerified)
            ? HomePage()
            : Login(),
      ),
    );
  }
}
