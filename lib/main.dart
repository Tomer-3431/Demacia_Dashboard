import 'package:demacia_dashboard/bar/sidebar.dart';
import 'package:demacia_dashboard/bar/top_bar.dart';
import 'package:demacia_dashboard/home/home_page.dart';
import 'package:demacia_dashboard/home/test_page.dart';
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
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int screenIndex = 0;

  List<Widget> screens = <Widget>[
    HomePage(),
    TestPage(),
    TestPage(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: TopBar(),
    drawer: Sidebar(),
    body: Row(
      children: [
        Container(
          height: MediaQuery.sizeOf(context).height,
          width: 100,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
          color: Colors.deepPurple,
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                listIcons(Icons.looks_one, 0),
                listIcons(Icons.looks_two, 1),
                listIcons(Icons.looks_3, 2),
              ],
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: screens[screenIndex],
        )
      ],
    ),
  );

  ListTile listIcons(IconData icon, int screen) {
    return ListTile(
      title: Icon(icon),
      iconColor: Colors.white,
      selectedColor: Colors.amber,
      selected: screenIndex == screen,
      onTap: () {
        screenIndex = screen;
      },
    );
  }
}
