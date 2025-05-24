import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';
import 'package:flutter/material.dart';

class BooleanWidget extends NtWidget {
  final void Function(bool value) onChange;

  const BooleanWidget({
    super.key,
    required super.title,
    required super.topic,
    this.onChange = _default,
  });

  static void _default(value) {}

  @override
  State<StatefulWidget> createState() => _BooleanWidgetState();
} 

class _BooleanWidgetState extends State<BooleanWidget> {
  bool state = true;

  @override
  void initState() {
    super.initState();

    state = widget.topic!.data as bool;
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: widget.size,
    height: widget.size,
    child: Switch(
      mouseCursor: SystemMouseCursors.click,
      value: state, 
      onChanged: (bool value) {
        widget.onChange(value);
        setState(() {
          state = value;
        });
      },
    ),
  );
}