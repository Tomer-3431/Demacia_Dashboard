import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NtTopic {
  NtTopic({
    required this.name,
    required this.directory,
    required this.type,
    required this.id,
  });

  final String name;
  final String directory;
  final Type type;
  final int id;


  Widget build(BuildContext context) => ListTile(
    title: Text(
      name,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        // color: getColorByType()
      ),
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