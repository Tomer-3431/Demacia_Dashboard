import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';

class HomePage extends Screen {
  const HomePage({super.key})
    : super(
        screenIndex: 0,
        iconUnselected: Icons.home_outlined,
        iconSelected: Icons.home,
        screenName: "Home Page",
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
