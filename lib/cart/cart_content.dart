import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/components/listtilecomponent.dart';
import 'package:untitled2/cart/cart.dart';

class CartContent extends StatefulWidget {
  String? categoryId;

  CartContent({super.key, this.categoryId});

  @override
  State<CartContent> createState() => _cartContentState();
}

class _cartContentState extends State<CartContent> {
  List<QueryDocumentSnapshot> data = [];

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .collection("goods")
        .get();
    data.addAll(querySnapshot.docs);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CONTENT"),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          return ListView.builder(
              itemCount: cart.basketItem.length,
              itemBuilder: (context, index) {
                return ListTileComponent(
                  img: cart.basketItem[index]["url"],
                  title: '${cart.basketItem[index]["name"]}',
                  subtitle: '${cart.basketItem[index]["price"]}',
                  icon: Icons.remove_shopping_cart,
                  onPressed: () {
                    cart.removeItem(cart.basketItem[index]);
                  },
                  details: '${cart.basketItem[index]["details"]}',
                );
              });
        },
      ),
    );
  }
}
