import 'package:demacia_dashboard/screen.dart';
import 'package:flutter/material.dart';

class TestPage extends Screen {
  const TestPage({
    super.key,
    required super.screenIndex,
  }) : super(
    iconData: Icons.science_outlined 
  );

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black,
    child: Center(
      child: Text(
        "Test Page",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
        ),
      ),
    ),
  );
}