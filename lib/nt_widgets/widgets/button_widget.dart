import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends NtWidget {
  final void Function() onTap;
  final String buttonName;
  final double size;

  const ButtonWidget({
    super.key,
    required super.title,
    required this.onTap,
    required this.buttonName,
    this.size = 50,
  });

  @override
  State<StatefulWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onTap,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 1.5),
            borderRadius: BorderRadius.circular(32),
          ),
          width: widget.size * 0.85,
          height: widget.size * 0.45,
          child: Center(
            child: Text(
              widget.buttonName,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    ),
  );
}
