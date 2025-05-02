import 'package:flutter/widgets.dart';

abstract class NtWidget extends StatefulWidget{
  final String title;

  const NtWidget({
    super.key,
    required this.title,
  });
}