// ignore_for_file: prefer_const_declarations, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class NavigationDrawerWidget extends StatelessWidget{
  final padding = EdgeInsets.symmetric(horizontal: 20.0);

  NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    final name = 'عمر امية';
    final urlImage = 'assets/Images/Dp.png';

    return Drawer(
      child: Material(
        color: Colors.black,
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  const SizedBox(height: 12.0),
                  buildMenuItem(text: 'حسابي', icon: Icons.people),
                  const SizedBox(height: 12.0),
                  buildMenuItem(text: 'رحلاتي', icon: Icons.home),
                  const SizedBox(height: 12.0),
                  buildMenuItem(text: 'مساعدة', icon: Icons.help),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
  }) =>
      InkWell(
        child: Container(
          decoration: BoxDecoration(color: Colors.blue),
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('أهلا', style: TextStyle(fontSize: 15.0, color: Colors.white)),
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
              Spacer(),
              CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromRGBO(30, 60, 168, 1),
                child: Icon(Icons.add_comment_outlined, color: Colors.white),
              )
            ],
          ),
        ),
      );
  
  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}