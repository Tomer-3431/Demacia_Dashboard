import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';
import 'package:flutter/material.dart';

class NumberWidget extends NtWidget {
  const NumberWidget({
    super.key,
    required super.topic,
    required super.title,
  });

  @override
  State<NumberWidget> createState() => _NumberWidgetState();
}

class _NumberWidgetState extends State<NumberWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.topic!.data.toString());
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Text(
      widget.topic!.data.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.normal,
        fontSize: 14,
        decoration: TextDecoration.none,
      ),
    ),
  );
}
