import 'package:basics/int_basics.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../theme.dart';

/// custom Tabbar component
class Tabs extends StatefulWidget {
  final int selectedIndex;

  final List<String> labels;

  final List<Widget> views;

  final Color? highlightColor;

  const Tabs({
    required this.labels,
    required this.views,
    this.highlightColor,
    this.selectedIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  TabsState createState() => TabsState();
}

class TabsState extends State<Tabs> {
  int selectedIndex = 0;
  final padding = 12.0;
  final innerPadding = 4.0;

  Alignment get markerPosition {
    switch (selectedIndex) {
      case 0:
        return Alignment.topLeft;
      case 1:
        return widget.labels.length == 2 ? Alignment.topRight : Alignment.topCenter;
      case 2:
        return Alignment.topRight;
    }
    throw Exception();
  }

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabs(theme, constraints.biggest),
          Flexible(fit: FlexFit.loose, child: widget.views[selectedIndex])
        ],
      );
    });
  }

  Container _buildTabs(ThemeData theme, Size size) {
    final width = (size.width - (2 * innerPadding) - (2 * padding)) / widget.labels.length;
    return Container(
      margin: EdgeInsets.only(left: padding, right: padding),
      constraints: const BoxConstraints.expand(height: 42),
      decoration: BoxDecoration(
        borderRadius: defaultBorderRadius,
        color: theme.colorScheme.surface,
      ),
      child: Padding(
        padding: EdgeInsets.all(innerPadding),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: 200.milliseconds,
              curve: Curves.fastOutSlowIn,
              alignment: markerPosition,
              child: Container(
                width: width,
                height: size.height,
                decoration: BoxDecoration(color: widget.highlightColor ?? theme.cardColor, borderRadius: defaultBorderRadius),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: enumerate(widget.labels).map((label) => _buildTab(label, isSelected: selectedIndex == label.index, height: size.height, width: width)).toList(),
            )
          ],
        ),
      ),
    );
  }

  void _onSelectionChanged(int newIndex) => setState(() => selectedIndex = newIndex);

  Widget _buildTab(IndexedValue<String> label, {required bool isSelected, required double height, required double width}) => SizedBox(
        width: width,
        height: height,
        child: TextButton(
          onPressed: () => _onSelectionChanged(label.index),
          child: Text(label.value, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
        ),
      );
}
