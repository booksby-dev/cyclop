import 'package:cyclop/src/widgets/picker/hex_textfield.dart';
import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/opacity/opacity_slider.dart';
import '../widgets/tabbar.dart';
import 'picker/color_selector.dart';
import 'picker/title_bar.dart';
import 'picker_config.dart' if (dart.library.js) 'picker_config_web.dart';
import 'selectors/channels/hsl_selector.dart';
import 'selectors/user_swatch_selector.dart';

const pickerWidth = 400.0;

const pickerHeight = 650.0;

const pickerSize = Size(pickerWidth, pickerHeight);

/// ColorPicker Widget
/// 2 or 3 tabs :
/// - material swatches
/// - HSL and RGB sliders
/// - custom swatches
///
/// Customisable with a [ColorPickerConfig]
class ColorPicker extends StatefulWidget {
  final Color selectedColor;

  /// custom swatches library
  final Set<Color> libraryColors;
  final Set<Color> myColors;

  final bool darkMode;

  /// colorPicker configuration
  final ColorPickerConfig config;

  /// color selection callback
  final ValueChanged<Color> onColorSelected;

  /// open [EyeDrop] callback
  final VoidCallback? onEyeDropper;

  /// custom swatches update callabck
  final ValueChanged<Set<Color>>? onSwatchesUpdate;

  final ColorPickerTitles titles;
  final TextStyle? titleStyle;
  final Color? highlightColor;

  /// close colorPicker callback
  final VoidCallback onClose;

  final VoidCallback? onKeyboard;

  const ColorPicker({
    required this.onColorSelected,
    required this.selectedColor,
    required this.config,
    required this.onClose,
    this.titles = const ColorPickerTitles(),
    this.highlightColor,
    this.titleStyle,
    this.onEyeDropper,
    this.onKeyboard,
    this.onSwatchesUpdate,
    this.libraryColors = const {},
    this.myColors = const {},
    this.darkMode = false,
    Key? key,
  }) : super(key: key);

  @override
  ColorPickerState createState() => ColorPickerState();
}

class ColorPickerState extends State<ColorPicker> {
  late FocusNode hexFieldFocus;

  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    hexFieldFocus = FocusNode();
    if (widget.onKeyboard != null) {
      hexFieldFocus.addListener(widget.onKeyboard!);
    }

    selectedColor = widget.selectedColor;
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.onKeyboard != null) {
      hexFieldFocus.removeListener(widget.onKeyboard!);
    }
    hexFieldFocus.dispose();
  }

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedColor != widget.selectedColor) {
      selectedColor = widget.selectedColor;
    }
  }

  void onColorChanged(Color newColor) {
    widget.onColorSelected(newColor);
    setState(() => selectedColor = newColor);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: widget.darkMode ? darkTheme : lightTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              constraints: BoxConstraints.loose(pickerSize),
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(defaultRadius),
                boxShadow: largeDarkShadowBox,
              ),
              child: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.start, children: [
                MainTitle(title: widget.titles.title, titleStyle: widget.titleStyle, onClose: widget.onClose),
                Flexible(
                  fit: FlexFit.loose,
                  child: Tabs(highlightColor: widget.highlightColor, labels: [
                    widget.titles.library,
                    if (widget.config.enableMyColors) widget.titles.myColors,
                    widget.titles.advanced
                  ], views: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: SwatchLibrary(
                          colors: widget.libraryColors,
                          currentColor: selectedColor,
                          onSwatchesUpdate: widget.onSwatchesUpdate,
                          onColorSelected: onColorChanged,
                        )),
                    if (widget.config.enableMyColors)
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: SwatchLibrary(
                            colors: widget.myColors,
                            currentColor: selectedColor,
                            onSwatchesUpdate: widget.onSwatchesUpdate,
                            onColorSelected: onColorChanged,
                          )),
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        ChannelSliders(
                          titles: widget.titles,
                          selectedColor: selectedColor,
                          highlightColor: widget.highlightColor,
                          onChange: onColorChanged,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(8),
                            child: RepaintBoundary(
                                child: Column(children: [
                              if (widget.config.enableOpacity)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: OpacitySlider(
                                      selectedColor: selectedColor,
                                      title: widget.titles.opacity,
                                      opacity: selectedColor.opacity,
                                      onChange: _onOpacityChange,
                                    )),
                              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                                  child: Text(widget.titles.hex, style: (const TextStyle()).copyWith(fontSize: theme.textTheme.titleSmall?.fontSize)),
                                ),
                                Row(mainAxisSize: MainAxisSize.max, children: [
                                  Expanded(
                                      child: HexColorField(
                                    color: selectedColor,
                                    hexFocus: hexFieldFocus,
                                    withAlpha: widget.config.enableOpacity,
                                    onColorChanged: (value) {
                                      onColorChanged(value);
                                    },
                                  )),
                                ])
                              ])
                            ])))
                      ],
                    ),
                  ]),
                ),
                defaultDivider,
                ColorSelector(
                  color: selectedColor,
                  withAlpha: widget.config.enableOpacity,
                  thumbWidth: 96,
                  highlightColor: widget.highlightColor,
                  onColorChanged: widget.onColorSelected,
                  onEyePick: widget.config.enableEyePicker ? widget.onEyeDropper : null,
                  focus: hexFieldFocus,
                )
              ])));
        },
      ),
    );
  }

  void _onOpacityChange(double value) => widget.onColorSelected(widget.selectedColor.withOpacity(value));
}

class ColorPickerTitles {
  final String title;
  final String library;
  final String myColors;
  final String advanced;
  final String hue;
  final String saturation;
  final String light;
  final String opacity;
  final String red;
  final String green;
  final String blue;
  final String hex;

  const ColorPickerTitles({this.title = 'Colors', this.library = 'Popular Colors', this.myColors = 'My Colors', this.advanced = 'Advanced', this.hue = 'Hue', this.saturation = 'Saturation', this.light = 'Lightness', this.opacity = 'Opacity', this.red = 'Red', this.green = 'Green', this.blue = 'Blue', this.hex = 'Hex Value'});
}
