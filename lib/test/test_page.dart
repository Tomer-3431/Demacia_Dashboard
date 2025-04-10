import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';

class TestPage extends Screen {
  const TestPage({
    super.key,
    required super.screenIndex,
  }) : super(
    iconUnselected: Icons.science_outlined,
    iconSelected: Icons.science,
    screenName: "Test Page"
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