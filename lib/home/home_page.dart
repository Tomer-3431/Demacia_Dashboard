import 'package:demacia_dashboard/screen.dart';
import 'package:flutter/material.dart';

class HomePage extends Screen {
  const HomePage({
    super.key,
  }): super(
    screenIndex: 0,
    iconData: Icons.home
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    child: Center(
      child: Text(
        "Home Page",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  );
}