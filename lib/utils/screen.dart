import 'package:flutter/material.dart';

abstract class Screen extends StatefulWidget {
  const Screen({
    super.key,
    required this.screenIndex,
    required this.iconUnselected,
    required this.iconSelected,
    required this.screenName,
  });
  final int screenIndex;
  final IconData iconUnselected;
  final IconData iconSelected;
  final String screenName;
}
