import 'package:flutter/material.dart';

abstract class Screen extends StatefulWidget {
  const Screen({
    super.key,
    required this.screenIndex,
    required this.iconData,
  });
  final int screenIndex;
  final IconData iconData;
}