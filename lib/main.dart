import 'dart:ui';

import 'package:demacia_dashboard/nt_widgets/nt_screen.dart';
import 'package:demacia_dashboard/utils/connect.dart';
import 'package:demacia_dashboard/utils/side_bar.dart';
import 'package:demacia_dashboard/utils/top_bar.dart';
import 'package:demacia_dashboard/home/home_page.dart';
import 'package:demacia_dashboard/test/test_page.dart';
import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const Home(),
      );
}

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;
  late final Connect nt4Connection;

  late List<Screen> screens;

  @override
  void initState() {
    super.initState();
    nt4Connection = Connect();
    nt4Connection.data();
    add();
    screens = <Screen>[
      HomePage(),
      NtScreen(nt4Connection),
      TestPage(screenIndex: 2),
    ];
    initConnection();
    getScreenToPrevios();
  }

  void add() {
    nt4Connection.sendDatas('arr', "List<int>", [1, 2, 3, 4, 5, 6]);
  }

  void initConnection() async {
    await Future.delayed(Duration(seconds: 1));
    // try {
    //   nt4Connection.sendDatas('name', "String", 'value');
    //   nt4Connection.sendDatas('hi', "int", 5);
    //   nt4Connection.sendDatas('double', "double", 5.5);
    //   //print('added');
    // } catch (e) {
    //   print('Failed to connect: $e');
    // }
  }

  Future<void> getScreenToPrevios() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      screenIndex = prefs.getInt("screenIndex") ?? 0;
    });
  }

  Future<void> setScreenData(int screenIndex) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("screenIndex", screenIndex);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: TopBar(),
        drawer: SideBar(
          width: getSideBarWidth() * 3,
          listTileList:
              screens.map((Screen screen) => listIcons(screen, true)).toList(),
        ),
        backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
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
                  children: screens
                      .map((Screen screen) => listIcons(screen, false))
                      .toList(),
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
                  SizedBox(width: 10),
                  Text(
                    screen.screenName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: screenIndex == screen.screenIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
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
        onTap: () {
          setState(() => screenIndex = screen.screenIndex);
          setScreenData(screenIndex);
        },
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
