import 'dart:ui';

import 'package:demacia_dashboard/utils/side_bar.dart';
import 'package:demacia_dashboard/utils/top_bar.dart';
import 'package:demacia_dashboard/home/home_page.dart';
import 'package:demacia_dashboard/test/test_page.dart';
import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Flutter Demo',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      // This is the theme of your application.
      //
      // TRY THIS: Try running your application with "flutter run". You'll see
      // the application has a purple toolbar. Then, without quitting the app,
      // try changing the seedColor in the colorScheme below to Colors.green
      // and then invoke "hot reload" (save your changes or press the "hot
      // reload" button in a Flutter-supported IDE, or press "r" if you used
      // the command line to start the app).
      //
      // Notice that the counter didn't reset back to zero; the application
      // state is not lost during the reload. To reset the state, use hot
      // restart instead.
      //
      // This works for code too, not just values: Most code changes can be
      // tested with just a hot reload.
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    ),
    home: Home(),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;

  List<Screen> screens = <Screen>[
    HomePage(),
    TestPage(screenIndex: 1),
    TestPage(screenIndex: 2),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopBar(),
    drawer: SideBar(
      width: getSideBarWidth() * 3,
      listTileList: screens.map((Screen screen) => listIcons(screen, true)).toList(),
    ),
    backgroundColor: Colors.black,
    body: Row(
      children: [
        Drawer(
          width: getSideBarWidth(),
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadiusDirectional.horizontal(
              end: Radius.circular(16),
            ),
          ),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children:
                  screens.map((Screen screen) => listIcons(screen, false)).toList(),
            ),
          ),
        ),
        Flexible(flex: 2, child: screens[screenIndex]),
      ],
    ),
  );

  ListTile listIcons(Screen screen, bool isOpen) => ListTile(
    minVerticalPadding: 20,
    title: isOpen
    ? Row(
      children: [
        Icon(
          screenIndex == screen.screenIndex
              ? screen.iconSelected
              : screen.iconUnselected,
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          screen.screenName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: screenIndex == screen.screenIndex
              ? FontWeight.bold
              : FontWeight.normal
          ),
        )
      ],
    )
    : Icon(
      screenIndex == screen.screenIndex
        ? screen.iconSelected
        : screen.iconUnselected,
    ),
    iconColor: Colors.white,
    selectedColor: Colors.amber,
    selected: screenIndex == screen.screenIndex,
    onTap: () => setState(() => screenIndex = screen.screenIndex),
  );

  double getSideBarWidth() {
    const double minWidth = 60;
    const double maxWidth = 80;

    return clampDouble(
      MediaQuery.sizeOf(context).width / 20,
      minWidth,
      maxWidth,
    );
  }
}
