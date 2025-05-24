import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:demacia_dashboard/nt_widgets/nt_sidebar/nt_sidebar.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/button_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/draggable_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/name_widget.dart';
import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NtScreen extends Screen {
  const NtScreen({super.key})
    : super(
        iconSelected: Icons.dashboard,
        iconUnselected: Icons.dashboard_outlined,
        screenIndex: 1,
        screenName: "Network Tables",
      );

  static const double size = 96;

  @override
  State<NtScreen> createState() => _NtScreenState();
}

class _NtScreenState extends State<NtScreen> {
  List<DraggableWidget> placedWidgets = [];
  Offset widgetPos = Offset(5, 5);
  int currentId = 0;
  late List<NtTopic> topics;

  @override
  void initState() {
    super.initState();

    topics = [
      NtTopic(
        name: "topic 1",
        directory: "folder",
        type: int,
        id: 0,
        data: 0.0,
        size: NtScreen.size,
      ),
      NtTopic(
        name: "topic 2",
        directory: "secondfolder/apple",
        type: int,
        id: 1,
        data: 1.0,
        size: NtScreen.size,
      ),
      NtTopic(
        name: "topic 3",
        directory: "folder/apple",
        type: int,
        id: 2,
        data: 2.0,
        size: NtScreen.size,
      ),
      NtTopic(
        name: "topic 4",
        directory: "folder/apple",
        type: String,
        id: 3,
        data: "abc",
        size: NtScreen.size,
      ),
      NtTopic(
        name: "topic 5",
        directory: "folder",
        type: bool,
        id: 4,
        data: true,
        size: NtScreen.size,
      ),
    ];

    getCurrentId();
    getWidgetPos();
    createWidgets();
  }

  void createWidgets() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    for (int i = currentId; i > 2; i--) {
      double x = (prefs.getDouble("NT.$i.x") ?? 0) / NtScreen.size;
      double y = (prefs.getDouble("NT.$i.y") ?? 0) / NtScreen.size;
      setState(() {
        placedWidgets.add(
          DraggableWidget(
            id: i,
            size: NtScreen.size,
            initPositon: Offset(x, y),
            child:
                (topics
                            .where(
                              (topic) =>
                                  topic.id ==
                                  (prefs.getInt("NT.$i.topic.id") ?? 0),
                            )
                            .firstOrNull ??
                        NtTopic(
                          name: "error topic",
                          directory: "error",
                          type: double,
                          id: -1,
                          data: -1,
                          size: NtScreen.size,
                        ))
                    .getWidget(),
          ),
        );
      });
    }
  }

  void getWidgetPos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    double x = prefs.getDouble("NT.1.x") ?? 5 * NtScreen.size;
    double y = prefs.getDouble("NT.1.y") ?? 5 * NtScreen.size;
    setState(() {
      widgetPos = Offset(x, y) / NtScreen.size;
    });
  }

  void getCurrentId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentId = prefs.getInt("NT.id") ?? 0;
    });
  }

  void removeWidgetsFromPrefs(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("NT.$id.x");
    prefs.remove("NT.$id.y");
    prefs.remove("NT.$id.width");
    prefs.remove("NT.$id.height");
    prefs.remove("NT.$id.topic.id");
    prefs.remove("NT.$id.title");
    prefs.setInt("NT.id", (prefs.getInt("NT.id") ?? 3) - 1);
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Stack(
          children: [
            CustomPaint(
              painter: GridPainter(
                gridSize: NtScreen.size,
                lineColor: Colors.deepPurple,
                lineThickness: 1,
              ),
              size: MediaQuery.sizeOf(context),
            ),
            ...rowAndColumnsNumbers(context, NtScreen.size),

            DraggableWidget(
              id: 1,
              size: NtScreen.size,
              initPositon: Offset(5, 5),
              whenPosChange:
                  (pos) => setState(() => widgetPos = pos / NtScreen.size),
              child: NameWidget(name: widgetPos.toString(), title: "test"),
            ),

            DraggableWidget(
              id: 2,
              size: NtScreen.size,
              initPositon: Offset(2, 8),
              child: ButtonWidget(
                title: "Clear Topic Widgets",
                size: NtScreen.size,
                onTap: () {
                  for (DraggableWidget widget in placedWidgets) {
                    removeWidgetsFromPrefs(widget.id);
                  }
                  setState(() => placedWidgets = []);
                },
                buttonName: "empty list",
              ),
            ),

            DragTarget<NtTopic>(
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPos = box.globalToLocal(details.offset);
                localPos /= NtScreen.size;
                localPos = Offset(
                  localPos.dx.round().toDouble().clamp(0, 14),
                  localPos.dy.round().toDouble().clamp(0, 8),
                );

                setState(() {
                  placedWidgets.add(
                    DraggableWidget(
                      id: ++currentId,
                      initPositon: localPos,
                      size: NtScreen.size,
                      child: details.data.getWidget(),
                    ),
                  );
                });
              },

              builder: (context, candidateData, rejectedData) {
                return Stack(children: placedWidgets);
              },
            ),
          ],
        ),
      ),

      NtSidebar(topics: topics),
    ],
  );

  List<Positioned> rowAndColumnsNumbers(BuildContext context, double gridSize) {
    List<Positioned> positionedList = [];
    for (
      int i = 0;
      i < (MediaQuery.sizeOf(context).height / NtScreen.size);
      i++
    ) {
      for (
        int j = 0;
        j < (MediaQuery.sizeOf(context).width / NtScreen.size);
        j++
      ) {
        positionedList.add(
          Positioned(
            top: i * gridSize,
            left: j * gridSize,
            height: gridSize,
            width: gridSize,
            child: GestureDetector(
              onTap: () => print("from top: $i, from left: $j"),
            ),
          ),
        );

        if (i == 0 || j == 0) {
          positionedList.add(
            Positioned(
              top: i * gridSize,
              left: j * gridSize,
              height: gridSize,
              width: gridSize,
              child: Center(
                child: Text(
                  i == 0 ? j.toString() : i.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }
      }
    }

    return positionedList;
  }
}

class GridPainter extends CustomPainter {
  final double gridSize;
  final Color lineColor;
  final double lineThickness;

  GridPainter({
    this.gridSize = 50.0,
    this.lineColor = Colors.grey,
    this.lineThickness = 0.5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = lineColor
          ..strokeWidth = lineThickness;

    // Vertical lines
    for (double x = 0; x <= size.width; x += gridSize) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y <= size.height; y += gridSize) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
