import 'package:demacia_dashboard/nt_widgets/nt_sidebar/nt_folder.dart';
import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:flutter/material.dart';

class NtSidebar extends StatefulWidget {
  const NtSidebar({super.key, required this.topics});

  @override
  State<NtSidebar> createState() => _NtSidebarState();

  final List<NtTopic> topics;
}

class _NtSidebarState extends State<NtSidebar> {
  bool isOpen = true;

  @override
  void initState() {
    super.initState();

    isOpen = true;
  }

  @override
  Widget build(BuildContext context) => Container(
        width: isOpen ? 300 : 50,
        decoration: BoxDecoration(
          color: Colors.purpleAccent.shade100,
          borderRadius: const BorderRadiusDirectional.horizontal(
            end: Radius.circular(8),
          ).resolve(TextDirection.rtl),
        ),
        child: isOpen
            ? Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: getTopics(Folder(name: ""))),
                    ),
                  ),
                  ListTile(
                    title: Icon(Icons.keyboard_double_arrow_right),
                    onTap: () => setState(() => isOpen = !isOpen),
                  ),
                ],
              )
            : Center(
                child: Expanded(
                  child: ListTile(
                    title: Icon(Icons.keyboard_double_arrow_left),
                    onTap: () => setState(() => isOpen = !isOpen),
                  ),
                ),
              ),
      );

  List<Widget> getTopics(Folder root) {
    for (NtTopic topic in widget.topics) {
      final List<String> parts = topic.directory.split("/");
      Folder current = root;
      int spaces = root.spaces + 1;

      for (int i = 0; i < parts.length; i++) {
        final String part = parts[i];
        final Folder? folderIfExisting = current.subFolders
            .where((Folder folder) => folder.name == part)
            .firstOrNull;

        if (folderIfExisting != null) {
          current = folderIfExisting;
          spaces++;
        } else {
          Folder newNode = Folder(name: part, spaces: spaces);
          current.subFolders.add(newNode);
          current = newNode;
          spaces++;
        }
      }
      current.files.add(topic);
    }

    root.sort();
    return [
      ...root.subFolders.map((subFolder) => subFolder.build(context)),
      ...root.files.map((file) => file.build(context)),
    ];
  }
}
