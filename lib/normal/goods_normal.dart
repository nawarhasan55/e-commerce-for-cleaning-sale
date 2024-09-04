import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import '../cart/cart.dart';
import '../cart/cart_content.dart';
import '../components/listtilecomponent.dart';
import 'categories_normal.dart';


class GoodsNormal extends StatefulWidget {
  final String categoryId;
  const GoodsNormal({super.key, required this.categoryId});

  @override
  State<GoodsNormal> createState() => _GoodsNormalState();
}

class _GoodsNormalState extends State<GoodsNormal> {

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
          Get.offAll(CategoriesNormal());
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

    );
  }
}
