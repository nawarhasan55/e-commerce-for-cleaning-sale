import 'package:flutter/material.dart';

class materialComponent extends StatelessWidget {
  materialComponent(
      {super.key,
      required this.data,
      required this.assetName,
      required this.onTap,
      required this.onLongPress});

  final String? data;
  final String? assetName;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      elevation: 8,
      borderRadius: BorderRadius.circular(20),
      //for image border
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.black12,
        onTap: onTap,
        onLongPress: onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Ink.image(
                image: NetworkImage(
                  "${assetName}",
                ),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "${data}",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
