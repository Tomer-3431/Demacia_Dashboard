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

  @override
  void initState() {
    super.initState();
    positon = widget.initPositon * widget.size;
  }

  @override
  Widget build(BuildContext context) => Positioned(
    left: positon.dx,
    top: positon.dy,
    child: GestureDetector(
      onPanUpdate: (details) => setState(() => positon += details.delta),
      onPanEnd:
          (details) => setState(() {
            positon /= widget.size;
            double x = positon.dx.round() * widget.size;
            double y = positon.dy.round() * widget.size;
            x = x.clamp(0, 14 * widget.size);
            y = y.clamp(0, 8 * widget.size);
            positon = Offset(x, y);
          }),
      child: widget.child,
    ),
  );
}
