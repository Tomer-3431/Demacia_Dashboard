
import 'package:flutter/material.dart';

class TopBar extends AppBar {
  TopBar({
    super.key,
  });

  @override
  bool get centerTitle => true;

  @override
  Widget get title => Text(
    "Demacia Dashboard",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  Color get backgroundColor => Colors.purple;
  
  @override
  Widget get leading => Builder(
    builder: (BuildContext context) => IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: Icon(
        Icons.menu,
        color: Colors.white,
      )
    )
  );
}