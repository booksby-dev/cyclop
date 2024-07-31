import 'package:cyclop/cyclop.dart';
import 'package:flutter/material.dart';

import '../../tabbar.dart';
import 'channel_slider.dart';
import 'hsl_sliders.dart';

typedef ChannelValueGetter = double Function(Color value);

typedef ValueLabelGetter = String Function(Color value);

class ChannelSliders extends StatefulWidget {
  final Color selectedColor;

  final ValueChanged<Color> onChange;

  final ColorPickerTitles titles;

  final Color? highlightColor;

  const ChannelSliders({required this.selectedColor, required this.titles, this.highlightColor, required this.onChange, Key? key}) : super(key: key);

  @override
  ChannelSlidersState createState() => ChannelSlidersState();
}

class ChannelSlidersState extends State<ChannelSliders> {
  bool hslMode = true;

  Color get color => widget.selectedColor;

  @override
  Widget build(BuildContext context) => Tabs(
        highlightColor: widget.highlightColor,
        labels: const [
          'HSL',
          'RGB'
        ],
        views: [
          Padding(padding: const EdgeInsets.all(8), child: HSLSliders(titles: widget.titles, color: color, onColorChanged: widget.onChange)),
          Padding(padding: const EdgeInsets.all(8), child: _buildRGBSliders()),
        ],
      );

  Column _buildRGBSliders() => Column(
        children: [
          ChannelSlider(
            label: widget.titles.red,
            selectedColor: color,
            colors: [
              color.withRed(0),
              color.withRed(255)
            ],
            channelValueGetter: (color) => color.red / 255,
            labelGetter: (color) => '${color.red}',
            onChange: (value) => widget.onChange(
              color.withRed((value * 255).toInt()),
            ),
          ),
          ChannelSlider(
            label: widget.titles.green,
            selectedColor: color,
            colors: [
              color.withGreen(0),
              color.withGreen(255)
            ],
            channelValueGetter: (color) => color.green / 255,
            labelGetter: (color) => '${color.green}',
            onChange: (value) => widget.onChange(
              color.withGreen((value * 255).toInt()),
            ),
          ),
          ChannelSlider(
            label: widget.titles.blue,
            selectedColor: color,
            colors: [
              color.withBlue(0),
              color.withBlue(255)
            ],
            channelValueGetter: (color) => color.blue / 255,
            labelGetter: (color) => '${color.blue}',
            onChange: (value) => widget.onChange(
              color.withBlue((value * 255).toInt()),
            ),
          ),
        ],
      );
}
