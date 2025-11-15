import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shapey/app_state/file_model.dart';
import 'package:shapey/widgets/timeline/timeline_actions.dart';

class LayerName extends ConsumerStatefulWidget {
  final FileLayer layer;
  const LayerName({super.key, required this.layer});
  @override
  ConsumerState<LayerName> createState() => _LayerNameState();
}

class _LayerNameState extends ConsumerState<LayerName> {
  late bool hidden;
  late String name;
  late bool locked;
  final FocusNode textFieldFocusNode = FocusNode();
  bool canRename = false;

  late TextEditingController textEditController;

  @override
  void initState() {
    super.initState();
    name = widget.layer.name();
    hidden = widget.layer.isHidden();
    locked = widget.layer.isLocked();
    textEditController = TextEditingController(text: name);
  }

  @override
  void dispose() {
    textEditController.dispose();
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LayerName oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.layer.name() != widget.layer.name()) {
      name = widget.layer.name();
      textEditController.text = name;
    }
    if (oldWidget.layer.isHidden() != widget.layer.isHidden()) {
      hidden = widget.layer.isHidden();
    }
    if (oldWidget.layer.isLocked() != widget.layer.isLocked()) {
      locked = widget.layer.isLocked();
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("${DateTime.now().toIso8601String()} Layer Name refresh");
    final bool isMultiSelected = widget.layer.isMultiSelectActive();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    var fgColor = colorScheme.onSecondaryContainer;
    var bgColor = colorScheme.surfaceBright;
    if (isMultiSelected) {
      fgColor = colorScheme.onSecondary;
      bgColor = colorScheme.onPrimaryFixedVariant;
    }

    BoxDecoration layerDecoration = BoxDecoration(
      color: bgColor,
      border: Border(
        bottom: BorderSide(color: colorScheme.secondaryContainer, width: 1.0),
      ),
    );

    var layerTextStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: fgColor,
      fontSize: textTheme.bodySmall?.fontSize,
    );
    var outputTextField = TextField(
      focusNode: textFieldFocusNode,
      enabled: canRename,
      controller: textEditController,
      style: layerTextStyle,
      textAlignVertical: TextAlignVertical.center,
      decoration: const InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 3),
        border: InputBorder.none,
      ),
    );
    Flexible layerText = Flexible(
      child: SizedBox(
        height: 30,
        child: Focus(
          onFocusChange: (hasFocus) {
            if (!hasFocus) {
              setState(() => canRename = false);
            }
          },
          child: Listener(
            onPointerDown: (event) => action_highlightLayer(ref, widget.layer),
            child: GestureDetector(
              onDoubleTap: () {
                setState(() => canRename = true);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  textFieldFocusNode.requestFocus();
                });
              },
              child: outputTextField,
            ),
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
      icon: hidden == false
          ? Icon(color: fgColor, size: icnWidth, Icons.visibility_rounded)
          : Icon(color: fgColor, size: icnWidth, Icons.visibility_off_rounded),
      onPressed: () {
        setState(() {
          hidden = !hidden;
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

/// The Layer Names on the left side, IE Visible, locked, Layer name list
class TimelineNamesList extends ConsumerWidget {
  final ScrollController tlNameViewScrollbar;
  final double layerHeight;
  const TimelineNamesList({
    super.key,
    required this.tlNameViewScrollbar,
    required this.layerHeight,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ONLY listen to layer changes
    final List<FileLayer> layers = ref.watch(
      fileNotifier.select((s) => s.layers),
    );
    return ListView.builder(
      itemCount: layers.length,

      prototypeItem: SizedBox(height: layerHeight),
      scrollDirection: Axis.vertical,
      cacheExtent: 500 * layerHeight,
      controller: tlNameViewScrollbar,
      addRepaintBoundaries: false,
      addAutomaticKeepAlives: true,
      itemBuilder: (context, layerIndex) => LayerName(
        key: ValueKey("Row-LayerName-$layerIndex"),
        layer: layers[layerIndex],
      ),
    );
  }
}
