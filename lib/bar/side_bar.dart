import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    super.key
  });

  @override
  Widget build(BuildContext context) => Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text('Drawer Header'),
        ),
        ListTile(
          title: const Text('Home'),
          selected: true,
        ),
        ListTile(
          title: const Text('Business'),
        ),
        ListTile(
          title: const Text('School'),
        )
      ],
    ),
  );
}
