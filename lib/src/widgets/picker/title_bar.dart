import 'package:flutter/material.dart';

import '../../theme.dart';

class MainTitle extends StatelessWidget {
  final VoidCallback? onClose;
  final String title;
  final TextStyle? titleStyle;

  const MainTitle({Key? key, required this.title, this.titleStyle, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title,
              style: titleStyle ?? textTheme.titleSmall,
            ),
          ),
          onClose != null ? IconButton(icon: const Icon(Icons.close, color: Colors.black, size: 18), onPressed: onClose) : const SizedBox(height: 48)
        ],
      ),
    );
  }
}
