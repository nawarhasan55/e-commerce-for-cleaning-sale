import 'package:flutter/material.dart';

class ListTileComponent extends StatelessWidget {
  ListTileComponent({
    super.key,
    required this.img,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onLongPress,
    required this.icon,
    this.onPressed,
    required this.details,
  });

  final String? img;
  final String? title;
  final String? subtitle;
  final String? details;
  void Function()? onTap;
  void Function()? onLongPress;

  void Function()? onPressed;

  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        child: Column(
          children: [
            ListTile(
              //splashColor: Colors.black12,
              leading: Ink.image(
                image: NetworkImage(
                  "${img}",
                ),
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
              title: Text("${title}"),
              subtitle: Text("${subtitle}"),
              trailing: IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  size: 30,
                ),
              ),
            ),
            Text("${details}",style: TextStyle(
              backgroundColor: Colors.red.shade200,
            ),)
          ],
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
