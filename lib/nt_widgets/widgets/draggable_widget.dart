import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DraggableWidget extends StatefulWidget {
  final double size;
  final Offset initPositon;
  final Widget child;

  const DraggableWidget({
    super.key,
    required this.size,
    required this.initPositon,
    required this.child,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  late Offset positon;
  late double width;
  late double height;
  bool isGrabbing = false;

  @override
  void initState() {
    super.initState();
    positon = widget.initPositon * widget.size;
    width = widget.size;
    height = widget.size;
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned(
        left: positon.dx,
        top: positon.dy,
        width: width,
        height: height,
        child: GestureDetector(
          onPanUpdate: (details) => setState(() {
            isGrabbing = true;
            positon += details.delta;
          }),
          onPanEnd:
            (details) {
              positon /= widget.size;
              double x = positon.dx.round() * widget.size;
              double y = positon.dy.round() * widget.size;
              x = x.clamp(0, 15 * widget.size);
              y = y.clamp(0, 9 * widget.size);
              setState(() {
                isGrabbing = false;
                positon = Offset(x, y);
              });
            },
          child: MouseRegion(
            cursor: isGrabbing ? SystemMouseCursors.allScroll : MouseCursor.defer,
            child: widget.child
          ),
        ),
      ),
      getMouseArea(Alignment.topLeft),
      getMouseArea(Alignment.topCenter),
      getMouseArea(Alignment.topRight),
      getMouseArea(Alignment.centerRight),
      getMouseArea(Alignment.bottomRight),
      getMouseArea(Alignment.bottomCenter),
      getMouseArea(Alignment.bottomLeft),
      getMouseArea(Alignment.centerLeft),
    ]
  );

  Positioned getMouseArea(Alignment area) => Positioned(
    left: positon.dx + switch (area.x) {
      -1 => 0,
      0 => 16,
      1 => width - 16,
      _ => 0,
    },
    top: positon.dy + switch (area.y) {
      -1 => 0,
      0 => 16,
      1 => height - 16,
      _ => 0,
    },
    child: GestureDetector(
      onPanUpdate: (details) {
        width += details.delta.dx * area.x;
        height += details.delta.dy * area.y;
        setState(() {
          if (((width <= 0.6 * widget.size) && area.y != 0) || ((height <= 0.6 * widget.size) && area.x != 0)) {
            if ((width <= 0.6 * widget.size) && (height <= 0.6 * widget.size)) {
              width = 0.6 * widget.size;
              height = 0.6 * widget.size;
            } else if (width <= 0.6 * widget.size && area.y != 0) {
              width = 0.6 * widget.size;
              height = height.clamp(0.6 * widget.size, double.infinity);
              positon += Offset(0, details.delta.dy);
            } else if (height <= 0.6 * widget.size && area.x != 0) {
              height = 0.6 * widget.size;
              width = width.clamp(0.6 * widget.size, double.infinity);
              positon += Offset(details.delta.dx, 0);
            }
          } else {
            positon = Offset(positon.dx + (area.x == -1 && width > widget.size * 0.6 ? (details.delta.dx) : 0), 
            positon.dy + (area.y == -1 && height > widget.size * 0.6 ? (details.delta.dy ) : 0));
            width = width.clamp(0.6 * widget.size, double.infinity);
            height = height.clamp(0.6 * widget.size, double.infinity);
          } 
        });
      },
      onPanEnd: (details) {
        positon /= widget.size;
        width /= widget.size;
        height /= widget.size;
        double x = positon.dx.round() * widget.size;
        double y = positon.dy.round() * widget.size;
        x = x.clamp(0, 15 * widget.size);
        y = y.clamp(0, 9 * widget.size);
        setState(() {
          positon = Offset(x, y);
          width = width.round() * widget.size;
          height = height.round() * widget.size;
        });
      },
      child: MouseRegion(
        cursor: switch ((area.x, area.y)) {
          (-1, -1) || (1, 1) => SystemMouseCursors.resizeUpLeft,
          (1, 0) || (-1, 0) => SystemMouseCursors.resizeRight,
          (0, 1) || (0, -1) => SystemMouseCursors.resizeUp,
          (-1, 1) || (1, -1) => SystemMouseCursors.resizeUpRight,
          (_, _) => SystemMouseCursors.none,
        },
        child: SizedBox(
          width: switch (area.x) {
            -1 => 16,
            0 => (width - 32).clamp(0, double.infinity),
            1 => 16,
            _ => 16
          },
          height: switch (area.y) {
            -1 => 16,
            0 => (height - 32).clamp(0, double.infinity),
            1 => 16,
            _ => 16
          },
        ),
      ),
    ),
  );
}
