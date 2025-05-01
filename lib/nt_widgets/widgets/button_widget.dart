import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final void Function() onTap;
  final String name;
  final double size;

  const ButtonWidget({
    super.key,
    required this.onTap,
    required this.name,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: size,
      width: size,
      color: Colors.white,
      child: Center(child: Text(name, style: TextStyle(color: Colors.black))),
    ),
  );
}
