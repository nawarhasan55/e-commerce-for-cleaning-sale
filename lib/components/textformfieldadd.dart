import 'package:flutter/material.dart';

class TestTextFormFieldAdd extends StatelessWidget {
  final String hinttext;

  final TextEditingController mycontroller;

  final String? Function(String?)? validator;

  final TextInputType? keyboardType;





  TestTextFormFieldAdd(
      {super.key,
        required this.hinttext,
        required this.mycontroller,
        required this.validator,
        this.keyboardType,


      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      keyboardType: keyboardType,
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.purple.shade200)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 2, color: Colors.purple.shade200),
        ),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey),

      ),
    );
  }
}
