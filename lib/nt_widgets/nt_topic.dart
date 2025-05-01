import 'package:demacia_dashboard/nt_widgets/widgets/number_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class NtTopic {
  NtTopic({
    required this.name,
    required this.directory,
    required this.type,
    required this.id,
    required this.onDrop,
    required this.data,
    required this.size,
  });

  final String name;
  final String directory;
  final Type type;
  final int id;
  final dynamic data;
  final void Function(Offset position, NtTopic data) onDrop;
  final double size;

  Widget build(BuildContext context) => Draggable<NtTopic>(
    data: this,
    feedback: NumberWidget(
      size: size, 
      number: data,
      title: name,
    ),
    childWhenDragging: Opacity(
      opacity: 0.3,
      child: ListTile(
        title: Text(name, textDirection: TextDirection.rtl, style: TextStyle()),
      ),
    ),
    child: ListTile(
      title: Text(name, textDirection: TextDirection.rtl, style: TextStyle()),
    ),
  );

  Color getColorByType() {
    return switch (type) {
      const (int) => Colors.blue,
      const (String) => Colors.red,
      const (double) => Colors.purple,
      const (bool) => Colors.yellow,
      Type() => Colors.black,
    };
  }
}
