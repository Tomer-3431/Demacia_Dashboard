import 'package:demacia_dashboard/nt_widgets/nt_topic.dart';
import 'package:flutter/material.dart';

class Folder {
  final String name;
  final int spaces;

  List<Folder> subFolders = [];
  List<NtTopic> files = [];

  Folder({
    required this.name, 
    this.spaces = 0
  });

  void sort() {
    subFolders.sort((a, b) => a.name.compareTo(b.name));
    files.sort((a, b) => a.name.compareTo(b.name));
  }

  Widget build(BuildContext context) {
    sort();

    return AnimatedMenuTile(
      title: name,
      spaces: spaces,
      children: [
        ...subFolders.map((Folder subFolder) => subFolder.build(context)),
        ...files.map((NtTopic file) => file.build(context)),
      ],
    );
  }
}

class AnimatedMenuTile extends StatefulWidget {
  final String title;
  final List<Widget> children;
  final int spaces;

  const AnimatedMenuTile({
    super.key,
    required this.title,
    required this.children,
    required this.spaces,
  });

  @override
  State<AnimatedMenuTile> createState() => _AnimatedMenuTileState();
}

class _AnimatedMenuTileState extends State<AnimatedMenuTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _iconTurns;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _iconTurns = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2),
      margin: EdgeInsets.symmetric(
        vertical: 5,
        horizontal: widget.spaces == 0 ? 20 : 0,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _handleTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(width: 8),
                RotationTransition(
                  turns: _iconTurns,
                  child: const Icon(Icons.expand_more),
                ),
                SizedBox(width: widget.spaces * 16), // Indent based on nesting
              ],
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: EdgeInsets.only(
                right: widget.spaces * 16.0 + 12.0,
              ), // More padding for nested items
              child: Container(
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                padding: const EdgeInsets.only(right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: widget.children,
                ),
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
