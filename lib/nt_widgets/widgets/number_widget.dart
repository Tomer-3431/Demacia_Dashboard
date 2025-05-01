import 'package:flutter/material.dart';

class NumberWidget extends StatefulWidget {
  final double number;
  final double size;
  final String title;

  const NumberWidget({
    super.key, 
    required this.title, 
    this.number = 0, 
    this.size = 50,
  });

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.number.toString());
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.grey[850],
      borderRadius: BorderRadius.circular(16)
    ),
    height: widget.size,
    width: widget.size,
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20)
            ),
          ),
          padding: EdgeInsets.all(4),
          height: widget.size * 0.3,
          child: Center(
            child: Text(
              widget.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              // controller:  controller,
              textAlign: TextAlign.center,
              widget.number.toString(),
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        )
      ],
    ),
  );
}
