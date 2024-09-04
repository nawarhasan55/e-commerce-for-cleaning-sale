import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/cart/cart.dart';
import 'package:untitled2/components/listtilecomponent.dart';
import 'package:untitled2/goods/add_goods.dart';
import 'package:untitled2/goods/edit_goods.dart';
import 'package:untitled2/home_page.dart';
import '../cart/cart_content.dart';

class Goods extends StatefulWidget {
  final String categoryId;

  const Goods({super.key, required this.categoryId});

  @override
  State<Goods> createState() => _GoodsState();
}

class _GoodsState extends State<Goods> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("goods")
        .get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
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
        title: Text('PRODUCTS'),
        //centerTitle: true,
        actions: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Get.to(() => CartContent());
                  },
                  icon: Icon(Icons.shopping_cart)),
              Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Consumer<Cart>(
                    builder: (context, cart, child) {
                      return Text("${cart.count}");
                    },
                  ))
            ],
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : PopScope(
              canPop: false,
              onPopInvoked: (bool val) {
                Get.offAll(HomePage());
              },
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  print("my url is=====================${data[index]["url"]}");
                  return Consumer<Cart>(builder: (context, cart, child) {
                    return ListTileComponent(
                      details: '${data[index]["details"]}',
                      img: data[index]["url"],
                      title: '${data[index]["name"]}',
                      subtitle: '${data[index]["price"]}',
                      onTap: () {},
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
                            Get.to(() => EditGoods(
                                  goodsId: data[index].id,
                                  categoriesId: widget.categoryId,
                                  oldName: data[index]["name"],
                                  oldPrice: data[index]["price"],
                                  oldDetails: data[index]["details"],
                                ));
                          },
                          btnCancelOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection("categories")
                                .doc(widget.categoryId)
                                .collection("goods")
                                .doc(data[index].id)
                                .delete();
                            Get.offAll(() => HomePage());
                            setState(() {});
                          },
                        ).show();
                      },
                      onPressed: () {
                        print("==============${cart.count}");

                        cart.addItem(data[index]);
                      },
                      icon: Icons.add_shopping_cart,
                    );
                  });
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddGoods(
                docId: widget.categoryId,
              ));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple[500],
      ),
    );
  }
}
