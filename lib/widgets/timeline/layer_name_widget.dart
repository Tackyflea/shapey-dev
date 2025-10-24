import 'package:flutter/material.dart';

class LayerName extends StatefulWidget {
  final String name;
  final bool visible;
  final bool locked;
  const LayerName({
    super.key,
    required this.name,
    this.locked = false,
    this.visible = true,
  });
  @override
  State<LayerName> createState() => _LayerNameState();
}

class _LayerNameState extends State<LayerName> {
  late bool visible;
  late String name;
  late bool locked;

  late TextEditingController textEditController;
  @override
  void initState() {
    super.initState();
    name = widget.name;
    visible = widget.visible;
    locked = widget.locked;
    textEditController = TextEditingController(text: name);
  }

  @override
  void dispose() {
    textEditController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LayerName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != widget.name) {
      name = widget.name;
      textEditController.text = name;
    }
    if (oldWidget.visible != widget.visible) visible = widget.visible;
    if (oldWidget.locked != widget.locked) locked = widget.locked;
  }

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

    var layerTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: fgColor,
      fontSize: textTheme.bodySmall?.fontSize,
    );
    Flexible layerText = Flexible(
      child: SizedBox(
        height: 30,
        child: TextField(
          controller: textEditController,
          // readOnly: !widget.textFieldEditable,
          style: layerTextStyle,
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 3),
            border: InputBorder.none,
          ),
        ),
      ),
    );

    // var lockAsset = const Image(
    //   image: AssetImage('assets/images/icn_lock_black.png'),
    // );
    double icnWidth = 15;
    var lockIcon = IconButton(
      iconSize: icnWidth,
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxWidth: 18),
      alignment: Alignment.center,
      icon: locked == true
          ? Icon(color: fgColor, size: icnWidth, Icons.lock_rounded)
          : Icon(color: fgColor, size: icnWidth, Icons.lock_open_rounded),
      onPressed: () {
        setState(() {
          locked = !locked;
        });
      },
    );
    var eyeIcon = IconButton(
      iconSize: icnWidth,
      padding: EdgeInsets.all(0),
      constraints: BoxConstraints(maxWidth: 18),
      alignment: Alignment.center,
      icon: visible == true
          ? Icon(color: fgColor, size: icnWidth, Icons.visibility_rounded)
          : Icon(color: fgColor, size: icnWidth, Icons.visibility_off_rounded),
      onPressed: () {
        setState(() {
          visible = !visible;
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
