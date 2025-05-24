import 'package:demacia_dashboard/nt_widgets/widgets/boolean_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/name_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/nt_widget.dart';
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
    required this.data,
    required this.size,
  });

  final String name;
  final String directory;
  final Type type;
  final int id;
  final dynamic data;
  // final void Function(Offset position, NtTopic data) onDrop;
  final double size;

  Widget build(BuildContext context) => Draggable<NtTopic>(
    data: this,
    feedback: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            padding: EdgeInsets.all(4),
            height: size * 0.3,
            child: Center(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: getWidget(),
          ),
        ],
      ),
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


  NtWidget getWidget() {
    return switch (type) {
      double || int => 
        NumberWidget(
          title: name, 
          topic: this,
        ),
      String => 
        NameWidget(
          title: name, 
          name: data, 
        ),
      bool => 
        BooleanWidget(
          title: name, 
          topic: this,
        ),
      // TODO: Handle this case.
      Type() => throw UnimplementedError(),
    };
  }

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
