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
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(16),
    ),
    height: size,
    width: size,
    child: GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.purple,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(32),
            ),
            width: size * 0.85,
            height: size * 0.45,
            child: Center(
              child: Text(
                name, 
                style: TextStyle(
                  color: Colors.white
                )
              )
            ),
          ),
        ),
      ),
    ),
  );
}
