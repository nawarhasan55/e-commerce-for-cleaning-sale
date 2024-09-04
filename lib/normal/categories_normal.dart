
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../auth/login.dart';
import '../cart/cart.dart';
import '../cart/cart_content.dart';
import '../components/material_component.dart';
import 'goods_normal.dart';

class CategoriesNormal extends StatefulWidget {
  const CategoriesNormal({super.key});

  @override
  State<CategoriesNormal> createState() => _CategoriesNormalState();
}

class _CategoriesNormalState extends State<CategoriesNormal> {

  bool loading = true ;


  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("categories").get();
    data.addAll(querySnapshot.docs);
    loading = false ;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => CartContent());
              },
              icon: Icon(Icons.shopping_cart)),
          Padding(
              padding: EdgeInsets.only(right: 10),
              child: Consumer<Cart>(
                builder: (context, cart, child)  {

                  return Text("${cart.count}");
                },
              )),
          IconButton(
              onPressed: () async {
                GoogleSignIn googleSignIn = GoogleSignIn();
                googleSignIn.disconnect();
                await FirebaseAuth.instance.signOut();
                Get.off(
                      () => Login(),
                );
              },
              icon: Icon(Icons.exit_to_app)),
        ],
      ),
      body: loading ? Center(child: CircularProgressIndicator()) : Padding(
        padding: EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
          ),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            print("my url  ============= ${data[index]['url']}");
            return materialComponent(
              data: "${data[index]["name"]}",
              assetName: data[index]['url'],
              onTap: () {
                Get.to(() => GoodsNormal(
                  categoryId: data[index].id,
                ));
              }, onLongPress: () {  },

            );
          },
        ),
      ),
    );

  }
}

