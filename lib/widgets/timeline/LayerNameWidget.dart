import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//TODO: Figureout how to make the variables final and still be changed/ accessed externally
class LayerNameWidget extends StatefulWidget {
  final String name;
  bool visible;
  bool locked;
  LayerNameWidget({
    super.key,
    required this.name,
    this.locked = false,
    this.visible = true,
  });

  @override
  State<LayerNameWidget> createState() => _LayerNameState();
}

class _LayerNameState extends State<LayerNameWidget> {
  late bool visible;
  late bool locked;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    var fgColor = Theme.of(context).colorScheme.onSecondaryContainer;

    BoxDecoration layerDecoration = BoxDecoration(
      border: Border(
        bottom: BorderSide(color: colorScheme.secondaryContainer, width: 1.0),
      ),
    );

    Text layerText = Text(
      widget.name,

      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: fgColor,
        fontSize: textTheme.bodySmall?.fontSize,
      ),
    );
    var lockAsset = const Image(
      image: AssetImage('assets/images/icn_lock_black.png'),
    );
    var eyeAsset = const Image(
      image: AssetImage('assets/images/icn_eye_black.png'),
    );
    double icnWidth = 15;
    var lockIcon = IconButton(
      iconSize: icnWidth,
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxWidth: 18),
      alignment: Alignment.center,
      icon: widget.locked == true
          ? Icon(color: fgColor, size: icnWidth, Icons.lock_rounded)
          : Icon(color: fgColor, size: icnWidth, Icons.lock_open_rounded),
      onPressed: () {
        setState(() {
          widget.locked = !widget.locked;
        });
      },
    );
    var eyeIcon = IconButton(
      iconSize: icnWidth,
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxWidth: 18),
      alignment: Alignment.center,
      icon: widget.visible == true
          ? Icon(color: fgColor, size: icnWidth, Icons.visibility_rounded)
          : Icon(color: fgColor, size: icnWidth, Icons.visibility_off_rounded),
      onPressed: () {
        setState(() {
          widget.visible = !widget.visible;
        });
      },
    );
    return Container(
      decoration: layerDecoration,
      height: 25,
      width: 208,
      alignment: Alignment.topLeft,
      padding: EdgeInsetsGeometry.fromLTRB(10, 5, 0, 0),
      child: Row(spacing: 5, children: [eyeIcon, lockIcon, layerText]),
    );
  }
}
