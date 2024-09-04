import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier{

  List<QueryDocumentSnapshot> data = [];

  void addItem(QueryDocumentSnapshot item){
    data.add(item) ;
    notifyListeners() ;
  }

  void removeItem(QueryDocumentSnapshot item){
    data.remove(item) ;
    notifyListeners() ;
  }

  int get count{
    return data.length ;
  }

  List<QueryDocumentSnapshot> get basketItem{

    return data ;

  }

}