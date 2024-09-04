import 'package:flutter/material.dart';

class CustomBottonUpload extends StatelessWidget {
  final void Function()? onPressed;

  final String title;

  CustomBottonUpload({
    super.key,
    this.onPressed,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      child: Text(title),
      height: 40,
      minWidth: 200,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.blue,
      textColor: Colors.white,
    );
  }
}
