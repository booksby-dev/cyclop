import 'dart:math';

import 'package:flutter/material.dart';

import '../theme.dart';
import '../utils.dart';
import 'color_picker.dart';
import 'eyedrop/eye_dropper_layer.dart';
import 'picker_config.dart' if (dart.library.js) 'picker_config_web.dart';

const _buttonSize = 48.0;

class ColorButton extends StatefulWidget {
  final Color color;
  final String? text;
  final double iconSize;
  final Border? iconBorder;
  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final ColorPickerConfig config;
  final Set<Color> libraryColors;
  final Set<Color> myColors;

  final ColorPickerTitles? colorPickerTitles;

  final ValueChanged<Color> onColorChanged;

  final ValueChanged<Set<Color>>? onSwatchesChanged;

  final bool darkMode;

  final Color? highlightColor;

  const ColorButton({
    required this.color,
    required this.onColorChanged,
    this.text,
    this.iconSize = 22,
    this.iconBorder,
    this.colorPickerTitles,
    this.textStyle,
    this.titleStyle,
    this.onSwatchesChanged,
    this.config = const ColorPickerConfig(),
    this.darkMode = false,
    this.libraryColors = const {},
    this.myColors = const {},
    this.highlightColor,
    Key? key,
  }) : super(key: key);

  @override
  ColorButtonState createState() => ColorButtonState();
}

class ColorButtonState extends State<ColorButton> with WidgetsBindingObserver {
  OverlayEntry? pickerOverlay;

  late Color color;

  // hide the palette during eyedropping
  bool hidden = false;

  bool keyboardOn = false;

  double bottom = 30;

  @override
  void initState() {
    super.initState();
    color = widget.color;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(ColorButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) color = widget.color;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () => _colorPick(context),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Container(width: widget.iconSize, height: widget.iconSize, padding: const EdgeInsets.all(4), child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: widget.iconBorder, color: widget.color))),
        widget.text != null ? const SizedBox(height: 4) : const SizedBox.shrink(),
        widget.text != null ? Text(widget.text!, textAlign: TextAlign.center, style: widget.textStyle) : const SizedBox.shrink()
      ]));

  void _colorPick(BuildContext context) async {
    final selectedColor = await showColorPicker(context);
    widget.onColorChanged(selectedColor);
  }

  Future<Color> showColorPicker(BuildContext rootContext) async {
    if (pickerOverlay != null) return Future.value(widget.color);

    pickerOverlay = _buildPickerOverlay(rootContext);

    Overlay.of(rootContext).insert(pickerOverlay!);

    return Future.value(widget.color);
  }

  OverlayEntry _buildPickerOverlay(BuildContext context) {
    final mq = MediaQuery.of(context);

    final Offset offset = Offset((mq.size.width / 2.0) - (pickerWidth / 2.0) - 50, (mq.size.height / 2.0));

    final pickerPosition = calculatePickerPosition(offset, mq.size);

    return OverlayEntry(
      maintainState: true,
      builder: (c) {
        return _DraggablePicker(
          initialOffset: pickerPosition,
          bottom: bottom,
          keyboardOn: keyboardOn,
          child: IgnorePointer(
            ignoring: hidden,
            child: Opacity(
              opacity: hidden ? 0 : 1,
              child: Material(
                borderRadius: defaultBorderRadius,
                child: ColorPicker(
                  titles: widget.colorPickerTitles ?? const ColorPickerTitles(),
                  highlightColor: widget.highlightColor,
                  titleStyle: widget.titleStyle,
                  darkMode: widget.darkMode,
                  config: widget.config,
                  selectedColor: color,
                  libraryColors: widget.libraryColors,
                  myColors: widget.myColors,
                  onClose: () {
                    pickerOverlay?.remove();
                    pickerOverlay = null;
                  },
                  onColorSelected: (c) {
                    color = c;
                    pickerOverlay?.markNeedsBuild();
                    widget.onColorChanged(c);
                  },
                  onSwatchesUpdate: widget.onSwatchesChanged,
                  onEyeDropper: () => _showEyeDropperOverlay(context),
                  onKeyboard: _onKeyboardOn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Offset calculatePickerPosition(Offset offset, Size size) =>
      offset +
      Offset(
        _buttonSize,
        min(-pickerHeight / 2, size.height - pickerHeight - 50),
      );

  void _showEyeDropperOverlay(BuildContext context) {
    hidden = true;
    try {
      EyeDrop.of(context).capture(context, (value) {
        hidden = false;
        _onEyePick(value);
      }, null);
    } catch (err) {
      debugPrint('ERROR !!! _buildPickerOverlay $err');
    }
  }

  void _onEyePick(Color value) {
    color = value;
    widget.onColorChanged(value);
    pickerOverlay?.markNeedsBuild();
  }

  void _onKeyboardOn() {
    keyboardOn = true;
    pickerOverlay?.markNeedsBuild();
    setState(() {});
  }

  @override
  void didChangeMetrics() {
    final view = View.of(context);
    final size = view.display.size;
    final keyboardTopPixels = size.height - view.viewInsets.bottom;

    final newBottom = (view.physicalSize.height - keyboardTopPixels) / view.devicePixelRatio;

    setState(() => bottom = newBottom);
    pickerOverlay?.markNeedsBuild();
  }
}

class _DraggablePicker extends StatefulWidget {
  final Offset initialOffset;

  final Widget child;

  final double bottom;

  final bool keyboardOn;

  const _DraggablePicker({
    Key? key,
    required this.child,
    required this.initialOffset,
    required this.bottom,
    required this.keyboardOn,
  }) : super(key: key);

  @override
  State<_DraggablePicker> createState() => _DraggablePickerState();
}

class _DraggablePickerState extends State<_DraggablePicker> {
  late Offset offset;

  @override
  void initState() {
    super.initState();
    offset = widget.initialOffset;
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final size = mq.size;

    final onLandscape = mq.size.shortestSide < 600 && mq.orientation == Orientation.landscape;

    return Positioned(
      left: mq.isPhone ? (size.width - pickerWidth) / 2 : offset.dx.clamp(0.0, size.width - pickerWidth),
      top: mq.isPhone
          ? onLandscape
              ? 0
              : (widget.keyboardOn ? 20 : (size.height - pickerHeight) / 2)
          : offset.dy.clamp(0.0, size.height - pickerHeight),
      bottom: mq.isPhone ? 20 + widget.bottom : null,
      child: GestureDetector(onPanUpdate: _onDrag, child: widget.child),
    );
  }

  void _onDrag(DragUpdateDetails details) => setState(() => offset = offset + details.delta);
}
