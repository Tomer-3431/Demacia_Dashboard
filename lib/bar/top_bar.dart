
import 'package:flutter/material.dart';

class TopBar extends AppBar {
  TopBar({
    super.key,
  });

  @override
  final bool centerTitle = true;

  @override
  final Widget title = Text(
    "Demacia Dashboard",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  );

  @override
  final Color backgroundColor = Colors.purple;
  
  @override
  final Widget leading = Builder(
    builder: (BuildContext context) => IconButton(
      onPressed: () => Scaffold.of(context).openDrawer(),
      icon: Icon(
        Icons.menu,
        color: Colors.white,
      )
    )
  );
}