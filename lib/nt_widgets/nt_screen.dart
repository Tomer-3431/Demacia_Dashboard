import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:demacia_dashboard/nt_widgets/nt_sidebar/nt_sidebar.dart';
import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';

class NtScreen extends Screen {
  const NtScreen({
    super.key
  }) : super(
    iconSelected: Icons.dashboard,
    iconUnselected: Icons.dashboard_outlined,
    screenIndex: 1,
    screenName: "Network Tables"
  );

  @override
  State<NtScreen> createState() => _NtScreenState();
}

class _NtScreenState extends State<NtScreen> {

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Center(
          child: Text(
            "Data",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      NtSidebar(
        topics: [
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 2", directory: "secondfolder/apple", type: int, id: 1),
          NtTopic(name: "topic 3", directory: "folder/apple", type: int, id: 2),
          NtTopic(name: "topic 1", directory: "folder", type: int, id: 0),
          NtTopic(name: "topic 4", directory: "folder/apple", type: int, id: 3),
        ],
      )
    ],
  );
}