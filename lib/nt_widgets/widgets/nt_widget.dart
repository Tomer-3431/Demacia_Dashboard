import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:flutter/widgets.dart';

abstract class NtWidget extends StatefulWidget{
  final String title;
  final NtTopic? topic;

  const NtWidget({
    super.key,
    required this.title,
    this.topic,
  });
}