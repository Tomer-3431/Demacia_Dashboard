import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key, required this.width, required this.listTileList});
  final double width;
  final List<ListTile> listTileList;

  @override
  Widget build(BuildContext context) => Drawer(
    width: width,
    backgroundColor: Colors.deepPurple,
    shape: RoundedRectangleBorder(
      borderRadius: const BorderRadiusDirectional.horizontal(
        end: Radius.circular(32),
      ),
    ),
    child: Center(
      child: ListView(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 8),
            decoration: BoxDecoration(color: Colors.purple),
            child: Text(
              "Menu",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          SizedBox(
            height:
                ((MediaQuery.sizeOf(context).height - 169 - 114) -
                    64 * listTileList.length) /
                2,
          ),
          ListView(shrinkWrap: true, children: listTileList),
        ],
      ),
    ),
  );
}
