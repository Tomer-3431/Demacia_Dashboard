import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:demacia_dashboard/nt_widgets/nt_sidebar/nt_sidebar.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/button_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/draggable_widget.dart';
import 'package:demacia_dashboard/nt_widgets/widgets/number_widget.dart';
import 'package:demacia_dashboard/utils/screen.dart';
import 'package:flutter/material.dart';

class NtScreen extends Screen {
  const NtScreen({super.key})
    : super(
        iconSelected: Icons.dashboard,
        iconUnselected: Icons.dashboard_outlined,
        screenIndex: 1,
        screenName: "Network Tables",
      );

  final double size = 96;

  @override
  State<NtScreen> createState() => _NtScreenState();
}

class _NtScreenState extends State<NtScreen> {
  List<DraggableWidget> placedWidgets = [];

  void handleDrop(Offset globalPosition, NtTopic data) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    Offset localPos = box.globalToLocal(globalPosition);
    localPos /= widget.size;
    localPos = Offset(
      localPos.dx.round().toDouble().clamp(0, 14 * widget.size),
      localPos.dy.round().toDouble().clamp(0, 8 * widget.size),
    );

    setState(() {
      placedWidgets.add(
        DraggableWidget(
          initPositon: localPos,
          size: widget.size,
          child: NumberWidget(
            number: data.data, 
            size: widget.size,
            title: data.name,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Stack(
          children: [
            CustomPaint(
              painter: GridPainter(
                gridSize: widget.size,
                lineColor: Colors.deepPurple,
                lineThickness: 1,
              ),
              size: MediaQuery.sizeOf(context),
            ),
            ...rowAndColumnsNumbers(context, widget.size),

            DraggableWidget(
              size: widget.size,
              initPositon: Offset(5, 5),
              child: NumberWidget(
                number: 20, 
                size: widget.size,
                title: "test",
              ),
            ),

            DraggableWidget(
              size: widget.size,
              initPositon: Offset(2, 8),
              child: ButtonWidget(
                size: widget.size,
                onTap: () => setState(() => placedWidgets = []),
                name: "empty list",
              ),
            ),

            DragTarget<NtTopic>(
              onWillAcceptWithDetails: (data) => true,
              onAcceptWithDetails: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                Offset localPos = box.globalToLocal(details.offset);
                localPos /= widget.size;
                localPos = Offset(
                  localPos.dx.round().toDouble().clamp(0, 14 * widget.size),
                  localPos.dy.round().toDouble().clamp(0, 8 * widget.size),
                );

                setState(() {
                  placedWidgets.add(
                    DraggableWidget(
                      initPositon: localPos,
                      size: widget.size,
                      child: NumberWidget(
                        number: details.data.data,
                        size: widget.size,
                        title: details.data.name,
                      ),
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

      NtSidebar(
        topics: [
          NtTopic(
            name: "topic 1",
            directory: "folder",
            type: int,
            id: 0,
            onDrop: handleDrop,
            data: 0.0,
            size: widget.size,
          ),
          NtTopic(
            name: "topic 2",
            directory: "secondfolder/apple",
            type: int,
            id: 1,
            onDrop: handleDrop,
            data: 1.0,
            size: widget.size,
          ),
          NtTopic(
            name: "topic 3",
            directory: "folder/apple",
            type: int,
            id: 2,
            onDrop: handleDrop,
            data: 2.0,
            size: widget.size,
          ),
          NtTopic(
            name: "topic 4",
            directory: "folder/apple",
            type: int,
            id: 3,
            onDrop: handleDrop,
            data: 3.0,
            size: widget.size,
          ),
        ],
      ),
    ],
  );

  List<Positioned> rowAndColumnsNumbers(BuildContext context, double gridSize) {
    List<Positioned> positionedList = [];
    for (
      int i = 0;
      i < (MediaQuery.sizeOf(context).height / widget.size);
      i++
    ) {
      for (
        int j = 0;
        j < (MediaQuery.sizeOf(context).width / widget.size);
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
