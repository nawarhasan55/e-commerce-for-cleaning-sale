import 'package:flutter/material.dart';

class TestTextFormField extends StatelessWidget {
  final String hinttext;

  final TextEditingController mycontroller;

  final String? Function(String?)? validator;

  final TextInputType? keyboardType;

  final IconData? suffixIcon;
  bool obscureTextbool =false ;
  final void Function()? onPressedIcon;

   TestTextFormField(
      {super.key,
      required this.hinttext,
      required this.mycontroller,
      required this.validator,
      this.keyboardType,
      this.suffixIcon,
      this.onPressedIcon,
        required this.obscureTextbool,
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureTextbool,
      keyboardType: keyboardType,
      validator: validator,
      controller: mycontroller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(color: Colors.blue)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide(width: 2, color: Colors.blue),
        ),
        hintText: hinttext,
        hintStyle: TextStyle(color: Colors.grey),
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: onPressedIcon, icon: Icon(suffixIcon ))
            : null,
      ),
    );
  }
}
