import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/categories/add_categories.dart';
import 'package:untitled2/categories/edit_categories.dart';
import 'package:untitled2/goods/goods.dart';
import 'auth/login.dart';
import 'cart/cart.dart';
import 'cart/cart_content.dart';
import 'components/material_component.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                Get.to(() => Goods(
                      categoryId: data[index].id,
                    ));
              },
              onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: 'Warning',
                  btnCancelText: "Delete",
                  btnOkText: "Update",
                  desc: 'What Do You Want ?',
                  btnOkOnPress: () {
                    Get.to(() => EditCategories(
                        docId: data[index].id, oldName: data[index]["name"]));
                  },
                  btnCancelOnPress: () async {
                    await FirebaseFirestore.instance
                        .collection("categories")
                        .doc(data[index].id)
                        .delete();
                    Get.offAll(() => HomePage());
                    setState(() {});
                  },
                ).show();
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddCategories());
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[500],
      ),
    );
  }
}

