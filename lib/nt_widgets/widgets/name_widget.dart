import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';
import 'package:flutter/material.dart';

class NameWidget extends NtWidget {
  final String? name;

  const NameWidget({
    super.key,
    required super.title,
    super.topic,
    this.name,
  });

  @override
  State<NameWidget> createState() => _NameWidgetState();
}

class _NameWidgetState extends State<NameWidget> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.name.toString());
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    height: widget.size,
    width: widget.size,
    child: Center(
      child: Text(
        widget.name ?? widget.topic!.data,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.normal,
          fontSize: 14,
          decoration: TextDecoration.none,
        ),
      ),
    ),
  );
}
