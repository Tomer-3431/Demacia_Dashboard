import 'package:flutter/material.dart';

class NumberWidget extends StatelessWidget {
  final double number;
  final double size;

  const NumberWidget({super.key, this.number = 0, this.size = 50});

  @override
  Widget build(BuildContext context) => Container(
    height: size,
    width: size,
    color: Colors.white,
    child: Center(
      child: Text(
        number.toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
