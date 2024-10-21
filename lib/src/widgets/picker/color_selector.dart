import 'package:flutter/material.dart';

import '../../theme.dart';
import 'hex_textfield.dart';

/// toolbar with :
/// - a color preview
/// - a hex color field
/// - an optional eyeDropper button
class ColorSelector extends StatelessWidget {
  final Color color;

  final bool withAlpha;

  final double thumbWidth;

  final FocusNode focus;

  final Color? defaultColor;

  final ValueChanged<Color> onColorChanged;

  final Color? highlightColor;

  final VoidCallback? onEyePick;

  final String undoText;

  const ColorSelector({
    required this.color,
    required this.onColorChanged,
    required this.focus,
    this.defaultColor,
    this.highlightColor,
    this.undoText = 'Undo',
    this.onEyePick,
    this.withAlpha = false,
    this.thumbWidth = 96,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildColorThumb(),
          if (onEyePick != null) const SizedBox(width: 10),
          if (onEyePick != null) // null if eyeDrop is disabled
            ElevatedButton(style: ButtonStyle(elevation: WidgetStateProperty.all(3), padding: WidgetStateProperty.all(const EdgeInsets.all(15))), onPressed: onEyePick, child: Icon(Icons.colorize, color: highlightColor ?? Colors.blue)),
          if (defaultColor != null) const SizedBox(width: 10),
          if (defaultColor != null) ElevatedButton(style: ButtonStyle(elevation: WidgetStateProperty.all(3), backgroundColor: WidgetStatePropertyAll(defaultColor!.opacity < 1 ? Colors.white : defaultColor), padding: WidgetStateProperty.all(const EdgeInsets.all(15))), onPressed: () => onColorChanged(defaultColor!), child: Text(undoText, style: TextStyle(color: highlightColor ?? Colors.blue))),
        ],
      ),
    );
  }

  Widget _buildColorThumb() => Material(
        color: Colors.white,
        elevation: 3,
        borderRadius: defaultBorderRadius,
        child: Container(
          width: thumbWidth,
          height: 36,
          decoration: BoxDecoration(
            color: color,
            borderRadius: defaultBorderRadius,
          ),
        ),
      );
}
